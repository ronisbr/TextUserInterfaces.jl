## Description #############################################################################
#
# This file defines the widget API.
#
############################################################################################

export create_widget, destroy_widget_buffer!, get_buffer, get_parent, hide!
export move_focus_to_widget, request_update!, unhide!

"""
    create_widget_buffer!(widget::Widget) -> Nothing

Create the buffer of `widget`. The variables `layout`, `container`, and `window` must be set
before calling this function. If the buffer is already created, then it will be deleted
first.
"""
function create_widget_buffer!(widget::Widget)
    destroy_widget_buffer!(widget)

    # This function is only called for objects that must be inside containers.
    # Hence, it is safe to assume that the parent is the container instead of
    # the window.
    parent = widget.container

    # Compute the widget true position based on the configuration.
    if !isnothing(parent)
        height, width, top, left = process_object_layout(
            widget.layout,
            parent;
            horizontal_hints = widget.horizontal_hints,
            vertical_hints = widget.vertical_hints
        )

        # Create the buffer that will hold the contents.
        parent_buffer = get_buffer(parent)
        buffer = subpad(parent_buffer, height, width, top, left)
    else
        # TODO: Should this be an error?
        buffer = Ptr{WINDOW}(0)
    end

    # Update the variables in the widget.
    widget.buffer = buffer
    widget.height = height
    widget.width  = width
    widget.left   = left
    widget.top    = top

    return nothing

end

"""
    destroy_widget!(widget::Widget) -> Nothing

Default function to destroy `widget`.
"""
function destroy_widget!(widget::Widget)
    @unpack buffer, container = widget

    # Before destroying the object, get its parent.
    parent = get_parent(widget)

    # Get the object description for logging purposes.
    widget_desc = obj_desc(widget)

    # Destroy the widget buffer.
    destroy_widget_buffer!(widget)

    # If the widget is added to a container, remove it.
    !isnothing(container) && remove_widget!(container, widget)

    @log DEBUG "destroy_widget!" "Widget destroyed: $widget_desc"

    # Now request to update the parent, which can be a container or a window.
    !isnothing(parent) && request_update!(parent)

    return nothing
end

"""
    destroy_widget_buffer!(widget::Widget) -> Nothing

Destroy the buffer of the `widget`.
"""
function destroy_widget_buffer!(widget::Widget)
    if widget.buffer != Ptr{WINDOW}(0)
        delwin(widget.buffer)
        widget.buffer = Ptr{WINDOW}(0)
    end

    return nothing
end

"""
    get_buffer(widget::Widget) -> Ptr{WINDOW}

Return the buffer of the `widget`.
"""
get_buffer(widget::Widget) = widget.buffer

"""
    get_parent(widget::Widget) -> Union{Window, WidgetContainer}

Return the parent of the `widget`.
"""
function get_parent(widget::Widget)
    if isnothing(widget.container)
        return widget.window
    else
        return widget.container
    end
end

"""
    has_focus(widget::Widget) -> Bool

Return `true` if `widget` has the focus, or `false` otherwise.
"""
function has_focus(widget::Widget)
    container = widget.container
    if !isnothing(container)
        widget_has_focus = widget === get_focused_widget(container)
        container_has_focus = has_focus(container)
        return widget_has_focus && container_has_focus
    else
        # If the widget does not have a container, then it is added to a window.
        # In this case, we need to check if the window has the focus.
        window = widget.window

        if !isnothing(window)
            return window === get_focused_window()
        else
            return false
        end
    end
end

"""
    hide!(widget::Widget) -> Nothing

Hide `widget`, meaning that it will still be in the parent container but it will not be
drawn or receive focus.
"""
function hide!(widget::Widget)
    widget.hidden = true
    request_update!(widget)
    return nothing
end

"""
    move_focus_to_widget(widget::Widget) -> Nothing

Move the focus to the `widget`, meaning that all parent chain will get focused up to the
window.
"""
function move_focus_to_widget(widget::Widget)
    container = widget.container
    !isnothing(container) && move_focus_to_widget!(container, widget)
    return nothing
end

"""
    request_update!(widget::Widget) -> Nothing

Request update of the widget `widget`.
"""
function request_update!(widget::Widget)
    widget.update_needed = true
    parent = get_parent(widget)
    !isnothing(parent) && request_update!(parent)
    return nothing
end

"""
    update(widget::Widget; force::Bool = false) -> Bool

Update the `widget` by calling the function `redraw!`. This function returns `true` if the
widget was updates, and `false` otherwise.

If `force` is `true`, then the widget will be updated even if it is not needed.
"""
function update!(widget::Widget; force::Bool = false)
    if widget.update_needed || force
        widget.hidden || redraw!(widget)
        widget.update_needed = false
        return true
    else
        return false
    end
end

"""
    unhide!(widget::Widget) -> Nothing

Unhide `widget`, meaning that it will be drawn in its parent buffer.
"""
function unhide!(widget::Widget)
    widget.hidden = false
    request_update!(widget)
    return nothing
end

"""
    update_widget_layout!(widget::Widget; force::Bool = true) -> Nothing

Default function to update the `widget` layout. If `force` is set to true, the widget will
be refreshed even if it is not needed.
"""
function update_widget_layout!(widget::Widget; force::Bool=true)
    @unpack layout, horizontal_hints, vertical_hints = widget

    parent = get_parent(widget)

    if !isnothing(parent)
        # # Get the layout information of the window.
        height, width, top, left = process_object_layout(
            layout,
            parent;
            horizontal_hints = horizontal_hints,
            vertical_hints = vertical_hints
        )

        # Check if resize or move is required.
        widget_resize = false
        widget_move = false

        if (height != widget.height) || (width != widget.width)
            widget_resize = true
        end

        if (top != widget.top) || (left != widget.left)
            widget_move = true
        end

        # Repack values.
        @pack! widget = height, width, top, left

        # Check if we need to recreate the widget.
        update_needed = widget_resize || widget_move || force

        # TODO: Calling `mvwin` on subpad does not work. Hence, we destroy and
        # recreate the subpad. We must check if there is a better way.
        if update_needed
            delwin(widget.buffer)
            widget.buffer = Ptr{WINDOW}(0)
            widget.buffer = subpad(get_buffer(parent), height, width, top, left)
            request_update!(widget)
        end

        # Emit the signal related to the layout update.
        @emit widget layout_updated

        return update_needed
    else
        return false
    end
end
