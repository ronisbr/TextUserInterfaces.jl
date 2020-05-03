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
    add_widget(container::WidgetContainer, widget::Widget)

Add the widget `widget` to the container `container.

"""
function add_widget(container::WidgetContainer, widget::Widget)
    push!(container.widgets, widget)
    return nothing
end

"""
    remove_widget(container::WidgetContainer, widget::Widget)

Remove the widget `widget` from the container `container`.

"""
function remove_widget(container::WidgetContainer, widget::Widget)
    idx = findfirst(x->x == widget, container.widgets)

    if idx == nothing
        # TODO: Write to the log.
        return nothing
    end

    # If the widget that will be deleted has the focus, then we must pass the
    # focus.
    if (container.focus_id == idx) && (length(container.widgets) > 1)
        _next_widget(container)
    end

    # Adjust the `focus_id` since the widget vector will be changed.
    container.focus_id > idx && (container.focus_id -= 1)

    # Delete the widget from the list.
    deleteat!(container.widgets, idx)

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
    id = findfirst(x->x == widget, widgets)

    # If `id` is `nothing`, then the `widget` does not belong to the
    # `container`.
    if id == nothing
        @log warning "request_focus" "$(obj_desc(widget)) does not belong to $(obj_desc(container))."
        return false
    else
        # If an element is in focus, then it must release it before moving to
        # the next one. If the element cannot release the focus, then this
        # function will not change the focus.
        if (focus_id > 0) && !release_focus(widgets[focus_id])
            @log verbose "request_focus" "$(obj_desc(container)): $(obj_desc(widgets[focus_id])) could not handle the focus to $(obj_desc(widget))."
            return false
        else
            container.focus_id = id
            request_next_widget(widgets[container.focus_id])
            @log verbose "request_focus" "$(obj_desc(container)): Focus was handled to widget #$id -> $(obj_desc(widgets[id]))."

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
refresh_window(container::WidgetContainer; force_redraw::Bool = false) =
    refresh_window(container.parent; force_redraw = force_redraw)

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

        # We must sync the cursor in the parent as well.
        sync_cursor(get_parent(container))
    end

    return nothing
end
