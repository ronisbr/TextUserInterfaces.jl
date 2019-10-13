#==# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains functions to handle focus in windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #==#

export accept_focus, has_focus, focus_on_widget, next_widget, process_focus,
       previous_widget, sync_cursor

"""
    function accept_focus(window::Window)

Check if the window `window` can accept focus and, if it can, then perform the
actions to change the focus.

 """
function accept_focus(window::Window)
    # Check if the window can have focus.
    if window.focusable
        # Move the window to the top and search for a widget that can hold the
        # focus.
        move_window_to_top(window)

        # Hide the cursor until the a widget request it.
        curs_set(0)

        return true
    else
        @log verbose "accept_focus" "Window $(window.id): Cannot accept focus."
        return false
    end
end

"""
    function has_focus(window::Window, widget)

Return `true` if the widget `widget` is in focus on window `window`, or `false`
otherwise.

"""
function has_focus(window::Window, widget)
    @unpack widgets, focus_id = window

    focus_id <= 0 && return false
    return widgets[focus_id] === widget
end

"""
    function focus_on_widget(widget::Widget)

Move focus to the widget `widget`.

"""
function focus_on_widget(widget::Widget)
    @unpack parent = widget.common

    # Find the widget on parent list.
    id = findfirst(x->x == widget, parent.widgets)

    if id == nothing
        @log error "focus_on_widget" "The widget $(obj_desc(widget)) does not belong to the widgets on window $(parent.id)!"
        return nothing
    end

    return focus_on_widget(parent, id)
end

"""
    function focus_on_widget(window::Window, id::Integer)

Move focus to the widget ID `id` on window `window`.

"""
function focus_on_widget(window::Window, id::Integer)
    @unpack widgets, focus_id = window

    @log verbose "focus_on_widget" "Window $(window.id): Move focus to widget #$id."

    # Release the focus from previous widget.
    focus_id > 0 && release_focus(widgets[focus_id])

    if (id > 0) && accept_focus(widgets[id])
        window.focus_id = id
        sync_cursor(window)

        @log verbose "focus_on_widget" "Window $(window.id): Focus was handled to widget #$id -> $(obj_desc(widgets[id]))."

        return true
    else
        window.focus_id = 0
        sync_cursor(window)

        @log verbose "focus_on_widget" "Window $(window.id): Widget #$id cannot receive focus -> $(obj_desc(widgets[id]))."

        return false
    end
end

"""
    function next_widget(window::Window)

Move the focus of window `window` to the next widget.

"""
function next_widget(window::Window)
    @unpack widgets, focus_id = window

    @log verbose "next_widget" "Window $(window.id): Change the focused widget."

    # Release the focus from previous widget.
    focus_id > 0 && release_focus(widgets[focus_id])

    # Search for the next widget that can handle the focus.
    for i = focus_id+1:length(widgets)
        if accept_focus(widgets[i])
            window.focus_id = i
            sync_cursor(window)

            @log verbose "next_widget" "Window $(window.id): Focus was handled to widget #$i -> $(obj_desc(widgets[i]))."

            return true
        end
    end

    # No more element could accept the focus.
    window.focus_id = 0
    sync_cursor(window)

    @log verbose "next_widget" "Window $(window.id): There are no more widgets to receive the focus."

    return false
end

"""
    function process_focus(window::Window, k::Keystroke)

Process the focus on window `window` due to keystroke `k`.

"""
function process_focus(window::Window, k::Keystroke)
    @unpack widgets, focus_id = window

    # If there is any element in focus, ask to process the keystroke.
    if focus_id > 0
        # If `process_focus` returns `false`, it means that the widget wants to
        # release the focus.
        if process_focus(widgets[focus_id],k)
            sync_cursor(window)
            return true
        end
    end

    # Otherwise, we must search another widget that can accept the focus.
    return next_widget(window)
end

"""
    function previous_widget(window::Window)

Move the focus of window `window` to the previous widget.

"""
function previous_widget(window::Window)
    @unpack widgets, focus_id = window

    @log verbose "previous_widget" "Window $(window.id): Change the focused widget."

    # Release the focus from previous widget.
    focus_id > 0  && release_focus(widgets[focus_id])
    focus_id == 0 && (focus_id = length(widgets))

    # Search for the next widget that can handle the focus.
    for i = focus_id-1:-1:1
        if accept_focus(widgets[i])
            window.focus_id = i
            sync_cursor(window)

            @log verbose "previous_widget" "Window $(window.id): Focus was handled to widget #$i of type $(typeof(widgets[i]))."

            return true
        end
    end

    # No more element could accept the focus.
    window.focus_id = 0
    sync_cursor(window)

    @log verbose "previous_widget" "Window $(window.id): There are no more widgets to receive the focus."

    return false
end

"""
    function sync_cursor(window::Window)

Synchronize the cursor to the position of the focused widget in window `window`.
This is necessary because all the operations are done in the buffer and then
copied to the view.

"""
function sync_cursor(window::Window)
    @unpack widgets, focus_id = window

    # If no widget is in focus or if the widget does not request cursor, then
    # just hide it.
    if (focus_id <= 0) || !require_cursor(widgets[focus_id])
        curs_set(0)
        return nothing
    else
        # Show the cursor.
        curs_set(1)

        # Get the focused widget.
        widget = widgets[focus_id]

        # Get the cursor position on the `cwin` of the widget.
        cy,cx = _get_window_cur_pos(widget.cwin)
        by,bx = _get_window_coord(widget.cwin)

        # Compute the coordinates of the cursor with respect to the window.
        y = by + cy
        x = bx + cx

        # If the window has a border, then we must take this into account when
        # updating the cursor coordinates.
        if window.has_border
            y += 1
            x += 1
        end

        # Move the cursor.
        wmove(window.view, y, x)

        # TODO: Limit the cursor position to the edge of the screen.

        return nothing
    end
end
