# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Widget: Container.
#   This file contains the API functions required by widget containers.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export add_widget, remove_widget

"""
    function add_widget(container::WidgetContainer, widget::Widget)

Add the widget `widget` to the container `container.

"""
function add_widget(container::WidgetContainer, widget::Widget)
    push!(container.widgets, widget)
    return nothing
end

"""
    function remove_widget(container::WidgetContainer, widget::Widget)

Remove the widget `widget` from the container `container`.

"""
function remove_widget(container::WidgetContainer, widget::Widget)
    idx = findall(x->x == widget, parent.widgets)
    deleteat!(parent.widgets, idx)
    return nothing
end

"""
    function has_focus(container::WidgetContainer, widget)

Return `true` if the widget `widget` is in focus on container `container`, or
`false` otherwise.

"""
function has_focus(container::WidgetContainer, widget)
    @unpack widgets, focus_id = container

    focus_id <= 0 && return false
    return widgets[focus_id] === widget
end

"""
    function sync_cursor(widget::WidgetContainer)

Synchronize the cursor to the position of the focused widget in container
`container`. This is necessary because all the operations are done in the
buffer and then copied to the view.

"""
function sync_cursor(container::WidgetContainer)
    @unpack widgets, focus_id = container

    # If the window has no widget, then just hide the cursor.
    if focus_id > 0
        # Get the cursor position on the `buffer` of the widget.
        cy,cx = _get_window_cur_pos(get_buffer(widgets[focus_id]))
        by,bx = _get_window_coord(get_buffer(widgets[focus_id]))

        # Compute the coordinates of the cursor with respect to the window.
        y = by + cy
        x = bx + cx

        # Move the cursor.
        wmove(get_buffer(container), y, x)
    end

    return nothing
end
