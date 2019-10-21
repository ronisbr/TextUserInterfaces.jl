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
    @unpack widget = window

    # Check if the window can have focus.
    if window.focusable
        # Move the window to the top and search for a widget that can hold the
        # focus.
        move_window_to_top(window)

        # Hide the cursor until the a widget request it.
        curs_set(0)

        # Pass the focus to the widget.
        accept_focus(widget)

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
    return window.widget === widget
end

"""
    function process_focus(window::Window, k::Keystroke)

Process the focus on window `window` due to keystroke `k`.

"""
function process_focus(window::Window, k::Keystroke)
    @unpack widget = window

    # If there is any element in the window, then it must be the one with active
    # focus.
    if widget != nothing
        if process_focus(widget,k)
            if require_cursor(widget)
                curs_set(1)
            else
                curs_set(0)
            end

            return true
        end
    end

    return false
end

"""
    function sync_cursor(window::Window)

Synchronize the cursor to the position of the focused widget in window `window`.
This is necessary because all the operations are done in the buffer and then
copied to the view.

"""
function sync_cursor(window::Window)
    @unpack widget = window

    if widget != nothing
        # Get the cursor position on the `buffer` of the widget.
        cy,cx = _get_window_cur_pos(get_buffer(widget))
        by,bx = _get_window_coord(get_buffer(widget))

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
    end

    return nothing
end
