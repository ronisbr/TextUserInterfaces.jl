## Description #############################################################################
#
# Widget container.
#
############################################################################################

export add_widget!, remove_widget!
export content_dimension_limits
export move_focus_to_next_widget!, move_focus_to_previous_widget!

############################################################################################
#                                        Constants                                         #
############################################################################################

# Hints for the widget container layout.
const _WIDGET_CONTAINER_HORIZONTAL_LAYOUT_HINTS = Dict(
    :left_anchor  => Anchor(:parent, :left,   0),
    :right_anchor => Anchor(:parent, :right,  0),
)

const _WIDGET_CONTAINER_VERTICAL_LAYOUT_HINTS = Dict(
    :bottom_anchor => Anchor(:parent, :bottom, 0),
    :top_anchor    => Anchor(:parent, :top,    0),
)

############################################################################################
#                                        Object API                                        #
############################################################################################

function can_accept_focus(container::WidgetContainer)
    # We need to see if there is at least one widget that can receive the focus.
    widget_id = _widget_container__search_next_widget_to_focus(container; cyclic = true)
    return !isnothing(widget_id)
end

function destroy!(container::WidgetContainer)
    while !isempty(container.widgets)
        destroy!(container.widgets |> first)
    end

    destroy_widget!(container)

    return nothing
end

get_inner_height(c::WidgetContainer) = c.height + (c.border ? -2 : 0)
get_inner_left(c::WidgetContainer)   = c.border ?  1 : 0
get_inner_top(c::WidgetContainer)    = c.border ?  1 : 0
get_inner_width(c::WidgetContainer)  = c.width  + (c.border ? -2 : 0)

function release_focus!(container::WidgetContainer)
    # First, check if we have an object in focus.
    focused_widget = get_focused_widget(container)

    if !isnothing(focused_widget)
        release_focus!(focused_widget)
    end

    return nothing
end

function request_focus!(container::WidgetContainer; direction::Symbol = :next)
    # First, check if we have an object in focus.
    focused_widget = get_focused_widget(container)

    if !isnothing(focused_widget) && request_focus!(focused_widget)
        sync_cursor(container)
        return true
    end

    # If no object is in focus or if the current one did not accept the focus, search for
    # another widget to receive the focus.
    if direction == :next
        move_focus_to_next_widget!(container)
    else
        move_focus_to_previous_widget!(container)
    end

    isnothing(get_focused_widget(container)) && return false

    sync_cursor(container)
    return true
end

function sync_cursor(container::WidgetContainer)
    focused_widget = get_focused_widget(container)

    # If the container has a focused widget, move the cursor in the container buffer
    # according the position of the widget.
    if !isnothing(focused_widget)
        # Get the cursor position on the `buffer` of the widget.
        cy, cx = _get_window_cursor_position(get_buffer(focused_widget))
        by, bx = _get_window_coordinates(get_buffer(focused_widget))

        # Get the position of the container window.
        #
        # This algorithm assumes that the cursor position after `wmove` is relative to the
        # beginning of the container window. However, since everything is a `subpad`, the
        # window coordinate (by,bx) is relative to the pad. Thus, we must subtract the
        # `subpad` position so that the algorithm is consistent.
        wy, wx = _get_window_coordinates(get_buffer(container))

        # Compute the coordinates of the cursor with respect to the window.
        y = by + cy - wy
        x = bx + cx - wx

        # Move the cursor.
        NCurses.wmove(get_buffer(container), y, x)
    end

    # We must sync the cursor in the parent as well.
    parent = get_parent(container)
    !isnothing(parent) && sync_cursor(parent)

    return nothing
end

function update_layout!(container::WidgetContainer; force::Bool = false)
    # Update the layout of the container as if it is a generic widget.
    if update_widget_layout!(container; force = force)
        for widget in container.widgets
            # In this case, we must force all the children to update their layout because
            # the container buffer has been recreated.
            update_layout!(widget; force = true)
        end

        return true
    end

    return false
end

############################################################################################
#                                        Widget API                                        #
############################################################################################

function create_widget(
    ::Val{:container},
    layout::ObjectLayout;
    border::Bool = false,
    border_style::Symbol = :default,
    theme::Theme = Theme(),
    title::String = "",
    title_alignment::Symbol = :l,
)
    # Create the widget.
    container = WidgetContainer(;
        layout           = layout,
        border           = border,
        border_style     = border_style,
        horizontal_hints = _WIDGET_CONTAINER_HORIZONTAL_LAYOUT_HINTS,
        id               = reserve_object_id(),
        theme            = theme,
        title            = title,
        title_alignment  = title_alignment,
        vertical_hints   = _WIDGET_CONTAINER_VERTICAL_LAYOUT_HINTS
    )

    @log DEBUG "create_widget" """
    WidgetContainer created:
      ID               = $(container.id)
      Border           = $(container.border)
      Border style     = $(container.border_style)
      Title            = $(container.title)
      Title alignment  = $(container.title_alignment)"""

    # Return the created container.
    return container
end

function process_keystroke!(container::WidgetContainer, k::Keystroke)
    # If the user pressed tab, they want to change the widget.
    if k.ktype == :tab
        # If the container has a focused widget, give it the chance to process the
        # keystroke first.
        fw = get_focused_widget(container)

        !isnothing(fw) && process_keystroke!(fw, k) == :keystroke_processed &&
            return :keystroke_processed

        # Otherwise, we need to change the focused widget in this container.

        # If this container does not have a parent, it means it is a top container. Thus, we
        # need to change the widgets in a cyclic manner.
        cyclic = isnothing(container.container)

        if !k.shift
            !move_focus_to_next_widget!(container; cyclic = cyclic) && return :next_object
            return :keystroke_processed
        end

        !move_focus_to_previous_widget!(container; cyclic = cyclic) && return :previous_object

        return :keystroke_processed
    end

    focused_widget = get_focused_widget(container)

    if !isnothing(focused_widget)
        r = process_keystroke!(focused_widget, k)

        if r == :keystroke_processed
            sync_cursor(container)
            return :keystroke_processed
        end
    end

    return :keystroke_not_processed
end

function redraw!(container::WidgetContainer)
    @unpack border, border_style, buffer, update_needed, widgets, theme = container
    @unpack height, width = container

    set_background_style!(buffer, get_style(theme, :default))
    NCurses.wclear(buffer)

    if border
        @nstyle get_style(theme, :border) buffer begin
            draw_border!(buffer; style = border_style)
        end

        @nstyle get_style(theme, :title) buffer begin
            _widget_container__draw_title!(container)
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
            wheight = get_height(widget)
            wwidth  = get_width(widget)
            wtop    = get_top(widget)
            wleft   = get_left(widget)

            # If we cannot draw the entire widget, skip it.
            if ((wtop + wheight) > height) || ((wleft + wwidth) > width)
                continue
            end

            widget.hidden || redraw!(widget)
        end
    end

    return nothing
end

function request_cursor(container::WidgetContainer)
    focused_widget = get_focused_widget(container)

    if !isnothing(focused_widget)
        return request_cursor(focused_widget)
    else
        return false
    end
end

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    add_widget!(container::WidgetContainer, widget::Widget) -> Nothing

Add the `widget` to the `container`.
"""
function add_widget!(container::WidgetContainer, widget::Widget)
    # If the widget already has a container, remove it before adding to this
    # container.
    wcontainer = container
    !isnothing(wcontainer) && remove_widget!(wcontainer, widget)

    # Add the widget to the container.
    widget.container = container
    widget.window = container.window
    create_widget_buffer!(widget)

    # TODO: This line is generating a lot of allocations.
    push!(container.widgets, widget)

    # Since adding a widget into a container can change its size, we need to
    # update the layout.
    update_layout!(widget; force = true)

    request_update!(container)

    @log DEBUG "add_widget!" """
    Add widget $(obj_desc(widget)) => $(obj_desc(container)):
        Top    = $(widget.top)
        Left   = $(widget.left)
        Height = $(widget.height)
        Width  = $(widget.width)"""

    return nothing
end

"""
    content_dimension_limits(widget::Widget) -> Int, Int

Return the content dimension limits (height, width) of the `widget`.
"""
function content_dimension_limits(container::WidgetContainer)
    max_height = 0
    max_width  = 0

    for widget in container.widgets
        wh, ww = content_dimension_limits(widget)

        max_height = max(max_height, wh)
        max_width  = max(max_width,  ww)
    end

    return max_height, max_width
end

function content_dimension_limits(widget::Widget)
    vertical   = get_top(widget) + get_height(widget)
    horizontal = get_left(widget) + get_width(widget)

    return vertical, horizontal
end

"""
    move_focus_to_next_widget!(container::WidgetContainer; cyclic::Bool = false) -> Bool

Move the focus in `container` to the next widget. This function returns `true` if it was
possible to acquire focus or `false` otherwise.

If `cyclic` is `false`, the widget list is not cycled when searching for the next widget.
"""
function move_focus_to_next_widget!(container::WidgetContainer; cyclic::Bool = false)
    # Try to find a new candidate to focus.
    widget_id = _widget_container__search_next_widget_to_focus(container; cyclic = cyclic)

    # If we found a new candidate, request the focus.
    if !isnothing(widget_id)
        _widget_container__change_focused_widget!(container, widget_id; direction = :next)
        return true
    end

    _widget_container__change_focused_widget!(container, 0; direction = :next)
    return false
end

"""
    move_focus_to_previous_widget!(container::WidgetContainer; cyclic::Bool = false) -> Bool

Move the focus in `container` to the previous widget. This function returns `true` if it was
possible to acquire focus or `false` otherwise.

If `cyclic` is `false`, the widget list is not cycled when searching for the next widget.
"""
function move_focus_to_previous_widget!(container::WidgetContainer; cyclic::Bool = false)
    # Try to find a new candidate to focus.
    widget_id = _widget_container__search_previous_widget_to_focus(container; cyclic = cyclic)

    # If we found a new candidate, request the focus.
    if !isnothing(widget_id)
        _widget_container__change_focused_widget!(container, widget_id; direction = :previous)
        return true
    end

    _widget_container__change_focused_widget!(container, 0; direction = :previous)
    return false
end

"""
    move_focus_to_widget!(container::WidgetContainer, widget::Widget) -> Nothing

Move the focus of the `container` to the `widget`.
"""
function move_focus_to_widget!(container::WidgetContainer, widget::Widget)
    # Find the widget ID in the container list.
    id = findfirst(w -> w === widget, container.widgets)

    if !isnothing(id) && request_focus!(widget) && !widget.hidden
        _widget_container__change_focused_widget!(container, id)

        # We also need to make this container in focus if it is inside another container.
        parent_container = container.container

        !isnothing(parent_container) && move_focus_to_widget!(parent_container, container)
    end

    return nothing
end

"""
    get_focused_widget(container::WidgetContainer) -> Union{Nothing, Widget}

Return the current widget in focus. If no widget is in focus, return `nothing`.
"""
function get_focused_widget(container::WidgetContainer)
    @unpack focused_widget_id, widgets = container

    focused_widget_id == 0 && return nothing

    if focused_widget_id > length(widgets)
        @log CRITICAL "get_focused_widget" """
        The focused widget ID is outside the allowed range."""
        return nothing
    end

    focused_widget = @inbounds widgets[focused_widget_id]

    # If the widget is hidden, we must report that we have no focus.
    focused_widget.hidden && return nothing

    return focused_widget
end

"""
    remove_widget!(container::WidgetContainer, widget::Widget) -> Nothing

Remove the `widget` from the `container`.
"""
function remove_widget!(container::WidgetContainer, widget::Widget)
    idx = findfirst(x -> x === widget, container.widgets)

    # TODO: Write to the log.
    isnothing(idx) && return nothing

    # Delete the widget from the list.
    deleteat!(container.widgets, idx)

    widget.container = nothing
    widget.window    = nothing

    destroy_widget_buffer!(widget)
    request_update!(container)

    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _widget_container__change_focused_widget!(container::WidgetContainer, widget_id::Int; kwargs...) -> Nothing

Change the focused widget in `container` to `widget_id`, emitting the required signals.

# Keywords

- `direction::Symbol`: Direction to move the focus. It can be `:next` or `:previous`.
    (**Default**: `:next`)
"""
function _widget_container__change_focused_widget!(
    container::WidgetContainer,
    widget_id::Int;
    direction::Symbol = :next
)
    focused_widget = get_focused_widget(container)

    !isnothing(focused_widget) && @emit focused_widget focus_lost

    container.focused_widget_id = widget_id

    if widget_id > 0
        new_focused_widget = container.widgets[widget_id]

        if new_focused_widget isa WidgetContainer
            request_focus!(new_focused_widget; direction = direction)
        else
            request_focus!(new_focused_widget)
        end

        sync_cursor(container)

        @emit new_focused_widget focus_acquired
    end

    return nothing
end

"""
    _widget_container__draw_title!(container::WidgetContainer) -> Nothing

Draw the title in the container `container`.
"""
function _widget_container__draw_title!(container::WidgetContainer)
    @unpack buffer, title, title_alignment = container

    # Get the width of the container.
    width = get_width(container)

    # If the width is too small, do nothing.
    width ≤ 4 && return nothing

    # Check if the entire title cannot be written. In this case, the title will be shrunk.
    if length(title) ≥ width - 4
        # TODO: We must consider the printable size here!
        title = title[1:width - 4]
    end

    # Compute the padding to print the title based on the alignment.
    # TODO: We must consider the printable size here!
    if title_alignment == :r
        pad = width - 2 - length(title)
    elseif title_alignment == :c
        pad = (width - length(title)) ÷ 2
    else
        pad = 2
    end

    NCurses.mvwprintw(buffer, 0, pad, title)

    return nothing
end

"""
    _widget_container__search_next_widget_to_focus(container::WidgetContainer; kwargs...) -> Union{Nothing, Int}

Search the next widget that can accept the focus in the list. It returns the object ID or
`nothing` if no widget can accept the focus. 

# Keywords

- `cyclic::Bool`: If `true`, the list will be cycled to find a new widget. Otherwise, it
    will stop at the last widget.
    (**Default**: `false`)
"""
function _widget_container__search_next_widget_to_focus(
    container::WidgetContainer;
    cyclic::Bool = false
)
    @unpack widgets, focused_widget_id = container

    num_widgets = length(widgets)
    num_widgets == 0 && return nothing

    # Number of tries to request the focus.
    num_tries = 0

    focus_candidate_id = focused_widget_id == 0 ? 1 : focused_widget_id + 1

    while true
        if !cyclic
            # If the focus candidate is higher than the number of widgets, we have cycled
            # the list. In this case, since `cyclic = false`, we just return that we could
            # not find a suitable widget to focus.
            focus_candidate_id > num_widgets && return nothing
        else
            # If we have `cyclic`, we must go back to the first widget if the current
            # candidate is highger than the number of widgets.
            if focus_candidate_id > num_widgets
                focus_candidate_id = 1
            end
        end

        candidate_widget = widgets[focus_candidate_id]

        # Check if the candidate can accept the focus.
        can_accept_focus(candidate_widget) && !candidate_widget.hidden && return focus_candidate_id

        num_tries += 1

        # If the number of tries is equal the number of widgets, no widget can accept the
        # focus.
        num_tries == num_widgets && return nothing

        focus_candidate_id = focus_candidate_id + 1
    end

    return nothing
end

"""
    _widget_container__search_previous_widget_to_focus(container::WidgetContainer; kwargs...) -> Union{Int, Nothing}

Search the previous widget that can accept the focus in the list. It returns the object ID
or `nothing` if no widget can accept the focus. 

# Keywords

- `cyclic::Bool`: If `true`, the list will be cycled to find a new widget. Otherwise, it
    will stop at the first widget.
    (**Default**: `false`)
"""
function _widget_container__search_previous_widget_to_focus(
    container::WidgetContainer;
    cyclic::Bool = false
)
    @unpack widgets, focused_widget_id = container

    num_widgets = length(widgets)
    num_widgets == 0 && return nothing

    # Number of tries to request the focus.
    num_tries = 0

    focus_candidate_id = focused_widget_id == 0 ? num_widgets : focused_widget_id - 1

    while true
        if !cyclic
            # If the focus candidate is lower than 0, we have cycled the list.  In this
            # case, since `cyclic = false`, we just return that we could not find a suitable
            # widget to focus.
            focus_candidate_id <= 0 && return nothing
        else
            # If we have `cyclic`, we must go back to the last widget if the current
            # candidate is lower than 0.
            if focus_candidate_id <= 0
                focus_candidate_id = num_widgets
            end
        end

        candidate_widget = widgets[focus_candidate_id]

        # Check if the candidate can accept the focus.
        can_accept_focus(candidate_widget) && !candidate_widget.hidden && return focus_candidate_id

        num_tries += 1

        # If the number of tries is equal the number of widgets, no widget can
        # accept the focus.
        num_tries == num_widgets && return nothing

        focus_candidate_id = focus_candidate_id - 1
    end

    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper container