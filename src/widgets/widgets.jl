# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file defines the widget API.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export create_widget, destroy_widget_buffer!, get_buffer, get_parent, request_update!

"""
    create_widget_buffer!(widget::Widget)

Create the buffer of `widget`. The variables `layout`, `container`, and `window`
must be set before calling this function. If the buffer is already created, then
it will be deleted first.
"""
function create_widget_buffer!(widget::Widget)
    destroy_widget_buffer!(widget)

    # Get the widget parent.
    parent = get_parent(widget)

    # Compute the widget true position based on the configuration.
    height, width, top, left = process_object_layout(
        widget.layout,
        parent;
        horizontal_hints = widget.horizontal_hints,
        vertical_hints = widget.vertical_hints
    )

    # Create the buffer that will hold the contents.
    buffer = subpad(get_buffer(parent), height, width, top, left)

    # Update the variables in the widget.
    widget.buffer = buffer
    widget.height = height
    widget.width  = width
    widget.left   = left
    widget.top    = top

    return nothing

end

"""
    destroy_widget_buffer!(widget::Widget)

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
    get_buffer(widget::Widget)

Return the buffer of the `widget`.
"""
get_buffer(widget::Widget) = widget.buffer

"""
    get_parent(widget::Widget)

Return the parent of the `widget`.
"""
function get_parent(widget::Widget)
    if isnothing(widget.container)
        return widget.window
    else
        return widget.container
    end
end

function has_focus(widget::Widget)
    container = widget.container
    if !isnothing(container)
        widget_has_focus = widget == get_focused_widget(container)
        container_has_focus = has_focus(container)
        return widget_has_focus && container_has_focus
    else
        # If the widget does not have a container, then it is added to a window.
        # In this case, we need to check if the window has the focus.
        window = widget.window

        if !isnothing(window)
            return window == get_focused_window()
        else
            return false
        end
    end
end

"""
    request_update!(widget::Widget)

Request update of the widget `widget`.
"""
function request_update!(widget::Widget)
    widget.update_needed = true
    request_update!(get_parent(widget))
    return nothing
end

"""
    update(widget::Widget; force::Bool = false)

Update the `widget` by calling the function `redraw!`. This function returns
`true` if the widget was updates, and `false` otherwise.

If `force` is `true`, then the widget will be updated even if it is not needed.
"""
function update!(widget::Widget; force::Bool = false)
    if widget.update_needed || force
        redraw!(widget)
        widget.update_needed = false
        return true
    else
        return false
    end
end
