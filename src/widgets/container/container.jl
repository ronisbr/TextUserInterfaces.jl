# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Widget container.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export add_widget!, remove_widget!

################################################################################
#                                  Constants
################################################################################

# Hints for the widget container layout.
const _WIDGET_CONTAINER_HORIZONTAL_LAYOUT_HINTS = (
    anchor_left  = Anchor(:parent, :left,   0),
    anchor_right = Anchor(:parent, :right,  0),
)

const _WIDGET_CONTAINER_VERTICAL_LAYOUT_HINTS = (
    anchor_bottom = Anchor(:parent, :bottom, 0),
    anchor_top    = Anchor(:parent, :top,    0),
)

################################################################################
#                                  Object API
################################################################################

function destroy!(container::WidgetContainer)
    while length(container.widgets) > 0
        destroy!(container.widgets |> first)
    end

    invoke(destroy!, Tuple{Widget}, container)

    return nothing
end

get_inner_height(c::WidgetContainer) = c.height + (c.border ? -2 : 0)
get_inner_left(c::WidgetContainer)   = c.border ?  1 : 0
get_inner_top(c::WidgetContainer)    = c.border ?  1 : 0
get_inner_width(c::WidgetContainer)  = c.width  + (c.border ? -2 : 0)

function request_focus!(container::WidgetContainer; direction::Symbol = :next)
    # First, check if we have an object in focus.
    focused_widget = get_focused_widget(container)

    if !isnothing(focused_widget)
        request_focus!(focused_widget) && return true
    end

    # If no object is in focus or if the current one did not accept the focus,
    # search for another widget to receive the focus.
    if direction === :next
        focus_next_widget!(container)
    else
        focus_previous_widget!(container)
    end

    if !isnothing(get_focused_widget(container))
        return true
    else
        return false
    end
end

function update_layout!(container::WidgetContainer; force::Bool = false)
    # Update the layout of the container as if it is a generic widget.
    if invoke(update_layout!, Tuple{Widget}, container; force = force)
        for widget in container.widgets
            # In this case, we must force all the children to update their
            # layout because the container buffer has been recreated.
            update_layout!(widget; force = true)
        end

        return true
    else
        return false
    end
end

################################################################################
#                                  Widget API
################################################################################

function create_widget(
    ::Val{:container},
    layout::ObjectLayout;
    border::Bool = false,
    theme::Theme = tui.default_theme,
    title::AbstractString = "",
    title_alignment::Symbol = :l,
)
    # Create the widget.
    container = WidgetContainer(
        layout           = layout,
        border           = border,
        horizontal_hints = _WIDGET_CONTAINER_HORIZONTAL_LAYOUT_HINTS,
        id               = reserve_object_id(),
        theme            = theme,
        title            = title,
        title_alignment  = title_alignment,
        vertical_hints   = _WIDGET_CONTAINER_VERTICAL_LAYOUT_HINTS,
    )

    @log INFO "create_widget" """
    Container created:
      ID               = $(container.id)
      border           = $(container.border),
      horizontal_hints = $(container.horizontal_hints)
      title            = $(container.title),
      title_alignment  = $(container.title_alignment),
      vertical_hints   = $(container.vertical_hints)"""

    # Return the created container.
    return container
end

function process_keystroke!(container::WidgetContainer, k::Keystroke)
    focused_widget = get_focused_widget(container)

    # If we do not have a focused widget, try to focus one first.
    if isnothing(focused_widget)
        cmd = check_global_command(k)

        if isnothing(cmd)
            focus_next_widget!(container) || return :next_widget
        else
            if _process_command!(container, cmd) == :keystroke_processed
                return :keystroke_processed
            end
        end

        focused_widget = get_focused_widget(container)
    end

    if !isnothing(focused_widget)
        r = process_keystroke!(focused_widget, k)
        return _process_command!(container, r)
    end

    return :keystroke_not_processed
end

function redraw!(container::WidgetContainer)
    @unpack border, buffer, update_needed, widgets, theme = container

    wclear(buffer)

    if border
        @ncolor theme.border buffer begin
            wborder(buffer)
        end

        @ncolor theme.title buffer begin
            _draw_title!(container)
        end
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
            redraw!(widget)
        end
    end

    return nothing
end

################################################################################
#                               Public functions
################################################################################

"""
    add_widget!(container::WidgetContainer, widget::Widget)

Add the `widget` to the `container`.
"""
function add_widget!(container::WidgetContainer, widget::Widget)
    # If the widget already has a container, remove it before adding to this
    # container.
    !isnothing(widget.container) && remove_widget!(widget.container, widget)

    # Add the widget to the container.
    widget.container = container
    widget.window = container.window
    create_widget_buffer!(widget)
    push!(container.widgets, widget)

    # Since adding a widget into a container can change its size, we need to
    # update the layout.
    update_layout!(widget; force = true)

    request_update!(container)

    @log INFO "add_widget!" """
    Add widget $(obj_desc(widget)) => $(obj_desc(container)):
        Top    = $(widget.top)
        Left   = $(widget.left)
        Height = $(widget.height)
        Width  = $(widget.width)"""

    return nothing
end

function focus_next_widget!(container::WidgetContainer; cyclic::Bool = false)
    num_widgets = length(container.widgets)
    num_widgets == 0 && return nothing

    # Number of tries to request the focus.
    num_tries = 0

    if container.focused_widget_id == 0
        focus_candidate = 1
    else
        focus_candidate = container.focused_widget_id + 1
    end

    while true
        if !cyclic
            if (focus_candidate > num_widgets) && (container.focused_widget_id == num_widgets)
                container.focused_widget_id = 0
                return false
            end
        else
            if focus_candidate > num_widgets
                focus_candidate = 1
            elseif focus_candidate <= 0
                focus_candidate = num_widgets
            end
        end

        if container.widgets[focus_candidate] isa WidgetContainer
            if request_focus!(container.widgets[focus_candidate]; direction = :next)
                container.focused_widget_id = focus_candidate
                return true
            end
        else
            if request_focus!(container.widgets[focus_candidate])
                container.focused_widget_id = focus_candidate
                return true
            end
        end

        num_tries += 1

        # If the number of tries is equal the number of widgets, no widget can
        # accept the focus.
        if num_tries == num_widgets
            container.focused_widget_id = 0
            return false
        end

        focus_candidate = focus_candidate + 1
    end

    return false
end

function focus_previous_widget!(container::WidgetContainer; cyclic::Bool = false)
    num_widgets = length(container.widgets)
    num_widgets == 0 && return nothing

    # Number of tries to request the focus.
    num_tries = 0

    if container.focused_widget_id == 0
        focus_candidate = num_widgets
    else
        focus_candidate = container.focused_widget_id - 1
    end

    while true
        if !cyclic
            if (focus_candidate <= 0) && (container.focused_widget_id == 1)
                container.focused_widget_id = 0
                return false
            end
        else
            if focus_candidate > num_widgets
                focus_candidate = 1
            elseif focus_candidate <= 0
                focus_candidate = num_widgets
            end
        end

        if container.focused_widget_id == 0
            focus_candidate = num_widgets
        else
            if focus_candidate <= 0
                focus_candidate = num_widgets
            end
        end

        if container.widgets[focus_candidate] isa WidgetContainer
            if request_focus!(container.widgets[focus_candidate]; direction = :previous)
                container.focused_widget_id = focus_candidate
                return true
            end
        else
            if request_focus!(container.widgets[focus_candidate])
                container.focused_widget_id = focus_candidate
                return true
            end
        end

        num_tries += 1

        # If the number of tries is equal the number of widgets, no widget can
        # accept the focus.
        if num_tries == num_widgets
            container.focused_widget_id = 0
            return false
        end

        focus_candidate = focus_candidate - 1
    end

    return false
end

"""
    get_focused_widget(container::WidgetContainer)

Return the current widget in focus. If no widget is in focus, return `nothing`.
"""
function get_focused_widget(container::WidgetContainer)
    @unpack focused_widget_id, widgets = container

    @inbounds if focused_widget_id == 0
        return nothing
    else
        if focused_widget_id > length(widgets)
            @log CRITICAL "get_focused_widget" """
            The focused widget ID is outside the allowed range."""
            return nothing
        end

        return widgets[focused_widget_id]
    end
end

"""
    remove_widget!(container::WidgetContainer, widget::Widget)

Remove the `widget` from the `container`.
"""
function remove_widget!(container::WidgetContainer, widget::Widget)
    idx = findfirst(x -> x === widget, container.widgets)

    if isnothing(idx)
        # TODO: Write to the log.
        return nothing
    end

    # Delete the widget from the list.
    deleteat!(container.widgets, idx)

    widget.container = nothing
    widget.window = nothing
    destroy_widget_buffer!(widget)

    request_update!(container)

    return nothing
end

################################################################################
#                              Private functions
################################################################################

"""
    _draw_title!(container::WidgetContainer)

Draw the title in the container `container`.
"""
function _draw_title!(container::WidgetContainer)
    @unpack buffer, title, title_alignment = container

    # Get the width of the container.
    width = get_width(container)

    # If the width is too small, then do nothing.
    if width ≤ 4
        return nothing
    end

    # Check if the entire title cannot be written. In this case, the title will
    # be shrunk.
    if length(title) ≥ width - 4
        title = title[1:width - 4]
    end

    # Compute the padding to print the title based on the alignment.
    if title_alignment == :r
        pad = width - 2 - length(title)
    elseif title_alignment == :c
        pad = div(width - length(title), 2)
    else
        pad = 2
    end

    mvwprintw(buffer, 0, pad, title)

    return nothing
end

function _process_command!(container::WidgetContainer, cmd::Symbol)
    # If this container does not have a parent, it means it is a top-most
    # container. Thus, we need to change the widgets in a cyclic manner.
    cyclic = isnothing(container.container)

    if cmd === :keystroke_processed
        return cmd

    elseif cmd === :next_object
        focus_next_widget!(container; cyclic) || return :next_object
        return :keystroke_processed

    elseif cmd === :previous_object
        focus_previous_widget!(container; cyclic) || return :previous_object
        return :keystroke_processed
    end

    return cmd
end

################################################################################
#                                   Helpers
################################################################################

@create_widget_helper container
