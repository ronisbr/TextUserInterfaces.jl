# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Widget: Button.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetContainer
export add_widget!, remove_widget!

################################################################################
#                                     Type
################################################################################

@widget mutable struct WidgetContainer
    border::Bool = false
    border_color::Int = 0
    focus_id::Int = 0
    title::String = ""
    title_alignment::Symbol = :l
    title_color::Int = 0
    widgets::Vector{Any} = Any[]
end

################################################################################
#                                     API
################################################################################

function create_widget(
    ::Val{:container},
    layout::ObjectLayout;
    border::Bool = false,
    border_color::Int = -1,
    title::AbstractString = "",
    title_alignment::Symbol = :l,
    title_color::Int = -1
)

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining some anchors.
    horizontal = _process_horizontal_info(layout)
    vertical   = _process_vertical_info(layout)

    if vertical == :unknown
        layout.anchor_bottom = Anchor(:parent, :bottom, 0)
        layout.anchor_top    = Anchor(:parent, :top,    0)
    end

    if horizontal == :unknown
        layout.anchor_left   = Anchor(:parent, :left,  0)
        layout.anchor_right  = Anchor(:parent, :right, 0)
    end

    # Create the widget.
    container = WidgetContainer(
        layout          = layout,
        border          = border,
        border_color    = border_color,
        title           = title,
        title_alignment = title_alignment,
        title_color     = title_color
    )

    @log info "create_widget" """
    Container created:
        Positioning = ($(vertical), $(horizontal))
        Reference   = $(obj_to_ptr(container))"""

    # Return the created container.
    return container
end

function destroy_widget!(container::WidgetContainer; refresh::Bool = true)
    # First, we need to delete all children widgets.
    while length(container.widgets) > 0
        w = pop!(container.widgets)
        destroy_widget!(w, refresh = false)
    end

    _destroy_widget!(container, refresh = refresh)

    return nothing
end

function process_focus(container::WidgetContainer, k::Keystroke)
    @unpack focus_id, parent, widgets = container

    # If there is any element in focus, ask to process the focus.
    if (focus_id > 0) && (process_focus(widgets[focus_id], k))
        sync_cursor(container)
        return true
    else
        # Now, we need to search for the next widget.
        if (k.ktype != :tab) || (!k.shift)
            return _next_widget(container)
        else
            return _previous_widget(container)
        end
    end
end

function redraw(container::WidgetContainer)
    @unpack border, border_color, buffer, parent, update_needed = container
    @unpack widgets, title_color = container

    wclear(buffer)

    if border
        border_color > 0 && wattron(buffer, border_color)
        wborder(buffer)
        border_color > 0 && wattroff(buffer, border_color)

        title_color  > 0 && wattron(buffer, title_color)
        _draw_title(container)
        title_color  > 0 && wattroff(buffer, title_color)
    end

    # Check if any widget must be redrawn.
    for widget in widgets
        if widget.update_needed
            update_needed = true
            break
        end
    end

    # Redraw all the widgets in the container if necessary.
    if update_needed
        for widget in widgets
            redraw(widget)
        end
    end

    return nothing
end

"""
    request_next_widget(container::WidgetContainer)

Request the next widget in `container`. It returns `true` if a widget has get
the focus or `false` otherwise.
"""
request_next_widget(container::WidgetContainer) = _next_widget(container)

"""
    request_prev_widget(container::WidgetContainer)

Request the previous widget in `container`. It returns `true` if a widget has
get the focus or `false` otherwise.
"""
request_prev_widget(container::WidgetContainer) = _previous_widget(container)

function require_cursor(container::WidgetContainer)
    @unpack widgets, focus_id = container
    focus_id > 0 && return require_cursor(widgets[focus_id])
    return false
end

function release_focus(container::WidgetContainer)
    container.focus_id = 0
    return true
end

################################################################################
#                      Functions related to the Container
################################################################################

"""
    add_widget!(container::WidgetContainer, widget::Widget)

Add the widget `widget` to the container `container.
"""
function add_widget!(container::WidgetContainer, widget::Widget)
    # If the widget already has a parent, then we must remove it from there
    # first.
    !isnothing(widget.parent) && remove_widget!(widget.parent, widget)

    widget.parent = container
    init_widget_buffer!(widget)
    push!(container.widgets, widget)

    # Since adding a widget into a container can change its size, we need to
    # call the repositioning algorithm.
    reposition!(widget; force = true)

    request_update!(container)

    @log info "add_widget!" """
    Add widget $(obj_desc(widget)) => $(obj_desc(container)):
        Top    = $(widget.top)
        Left   = $(widget.left)
        Height = $(widget.height)
        Width  = $(widget.width)
    """

    return nothing
end

"""
    remove_widget!(container::WidgetContainer, widget::Widget)

Remove the widget `widget` from the container `container`.
"""
function remove_widget!(container::WidgetContainer, widget::Widget)
    idx = findfirst(x->x == widget, container.widgets)

    if idx == nothing
        # TODO: Write to the log.
        return nothing
    end

    # If the widget that will be deleted has the focus, then we must pass the
    # focus.
    if container.focus_id == idx
        if length(container.widgets) > 1
            _next_widget(container)
        else
            container.focus_id = 0
        end
    end

    # Adjust the `focus_id` since the widget vector will be changed.
    container.focus_id > idx && (container.focus_id -= 1)

    # Delete the widget from the list.
    deleteat!(container.widgets, idx)

    widget.parent = nothing
    destroy_widget_buffer!(widget)

    request_update!(container)

    return nothing
end

"""
    has_focus(container::WidgetContainer, widget)

Return `true` if the widget `widget` is in focus on container `container`, or
`false` otherwise.
"""
function has_focus(container::WidgetContainer, widget)
    @unpack widgets, focus_id = container

    focus_id <= 0 && return false
    return widgets[focus_id] === widget
end

"""
    request_focus(container::WidgetContainer, widget)

Request the focus to the widget `widget` of the container `container`. It
returns `true` if the focus could be changed or `false` otherwise.
"""
function request_focus(container::WidgetContainer, widget)
    @unpack widgets, focus_id = container

    # Find the widget in the widget list.
    id = findfirst(x -> x == widget, widgets)

    # If `id` is `nothing`, then the `widget` does not belong to the
    # `container`.
    if id == nothing
        @log warning "request_focus" "$(obj_desc(widget)) does not belong to $(obj_desc(container))."
        return false
    else
        # If the widget is already in focus, then do nothing.
        if (focus_id > 0) && (widgets[focus_id] == widget)
            return true
        end

        # If an element is in focus, then it must release it before moving to
        # the next one. If the element cannot release the focus, then this
        # function will not change the focus.
        if (focus_id > 0) && !release_focus(widgets[focus_id])
            @log verbose "request_focus" "$(obj_desc(container)): $(obj_desc(widgets[focus_id])) could not handle the focus to $(obj_desc(widget))."

            # We must sync the cursor and update the TUI to make sure that the
            # cursor is in the right position.
            tui_update()
            sync_cursor(container)

            return false
        else
            old_focused_widget = focus_id > 0 ? widgets[focus_id] : nothing
            new_focused_widget = widgets[id]
            container.focus_id = id

            if old_focused_widget != nothing
                @emit_signal old_focused_widget focus_lost
            end

            if request_next_widget(new_focused_widget)
                @emit_signal new_focused_widget focus_acquired
            end

            @log verbose "request_focus" "$(obj_desc(container)): Focus was handled to widget #$(container.focus_id) -> $(obj_desc(widgets[container.focus_id]))."

            # We need to update the TUI, now that the new widget has the focus,
            # and then synchronize the cursors.
            tui_update()
            sync_cursor(container)

            # TODO: What should we do if the widget does not accept the focus?
            return true
        end
    end
end

"""
    refresh_window(container::WidgetContainer; force_redraw::Bool = false)

Ask the parent widget to refresh the window. If `force_redraw` is `true`, then
all widgets in the window will be updated.
"""
function refresh_window(container::WidgetContainer; force_redraw::Bool = false)
    return refresh_window(container.parent; force_redraw = force_redraw)
end

"""
    sync_cursor(widget::WidgetContainer)

Synchronize the cursor to the position of the focused widget in container
`container`. This is necessary because all the operations are done in the
buffer and then copied to the view.
"""
function sync_cursor(container::WidgetContainer)
    @unpack widgets, focus_id = container

    # If the window has no widget, then just hide the cursor.
    if focus_id > 0
        widget = widgets[focus_id]

        # Get the cursor position on the `buffer` of the widget.
        cy,cx = _get_window_cur_pos(get_buffer(widget))
        by,bx = _get_window_coord(get_buffer(widget))

        # Get the position of the container window.
        #
        # This algorithm assumes that the cursor position after `wmove` is
        # relative to the beginning of the container window. However, since
        # everything is a `subpad`, the window coordinate (by,bx) is relative to
        # the pad. Thus, we must subtract the `subpad` position so that the
        # algorithm is consistent.
        wy,wx = _get_window_coord(get_buffer(container))

        # Compute the coordinates of the cursor with respect to the window.
        y = by + cy - wy
        x = bx + cx - wx

        # Move the cursor.
        wmove(get_buffer(container), y, x)
    end

    # We must sync the cursor in the parent as well.
    sync_cursor(get_parent(container))

    return nothing
end

################################################################################
#                                   Helpers
################################################################################

@create_widget_helper container
