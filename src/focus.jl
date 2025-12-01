## Description #############################################################################
#
# Functions related to the global focus manager.
#
############################################################################################

export move_focus_to_next_window, move_focus_to_previous_window, move_focus_to_window
export process_keystroke

"""
    get_focused_window() -> Union{Nothing, Window}

Return the current window in focus. If no window is in focus, return `nothing`.
"""
function get_focused_window()
    focused_window_id = tui.focused_window_id
    windows = tui.windows

    focused_window_id == 0 && return nothing

    if focused_window_id > length(windows)
        @log CRITICAL "get_focused_window" """
        The focused window ID is outside the allowed range."""
        return nothing
    end

    return windows[focused_window_id]
end

"""
    move_focus_to_next_window() -> Nothing

Move the focus to the next window.
"""
function move_focus_to_next_window()
    focus_candidate = _search_next_window_to_focus()
    !isnothing(focus_candidate) && _change_focused_window(focus_candidate)
    return nothing
end

"""
    move_focus_to_previous_window() -> Nothing

Move the focus to the previous window.
"""
function move_focus_to_previous_window()
    focus_candidate = _search_previous_window_to_focus()
    !isnothing(focus_candidate) && _change_focused_window(focus_candidate)
    return nothing
end

"""
    move_focus_to_window(window::Window)

Move the focus to the `window`.
"""
function move_focus_to_window(window::Window)
    id = findfirst(w -> w === window, tui.windows)

    if isnothing(id)
        @log CRITICAL "move_focus_to_window" """
        The window was not found in the window list of the current TUI."""
        return nothing
    end

    # Only change the focus if the window can accept focus.
    can_accept_focus(window) && _change_focused_window(id)

    return nothing
end

"""
    process_keystroke(k::Keystroke) -> Nothing

Process the keystroke `k` in the application level. This function finds the current window
in focus and send the keystroke to it.
"""
function process_keystroke(k::Keystroke)
    # The only activity we need to perform in the global focus manager is to
    # check for resizing events and pass the keystroke to the windows in focus.
    if k.ktype == :resize
        NCurses.clear()

        for win in tui.windows
            # Here, we need to force the layout update. For some reason, if a window
            # occupies the entire screen, then NCurses automatically change the value
            # returned by `getmaxx` and `getmaxy`. Thus, the repositioning algorithm thinks
            # we do not need to resize the window and then the buffers are not resized. This
            # is not the fastest algorithm, but since resize events tends to be sparse,
            # there will not be noticeable impact.
            update_layout!(win; force = true)
        end
    else
        focused_window = get_focused_window()

        # If we do not have a focused window, try to find one.
        if isnothing(focused_window)
            move_focus_to_next_window()
            focused_window = get_focused_window()
        end

        !isnothing(focused_window) && process_keystroke!(focused_window, k)
    end

    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _change_focused_window(window_id::Int) -> Nothing

Change the focused window to the window with ID `window_id`.
"""
function _change_focused_window(window_id::Int)
    focused_window = get_focused_window()

    if !isnothing(focused_window)
        release_focus!(focused_window)
        @emit focused_window focus_lost
    end

    tui.focused_window_id = window_id

    if window_id > 0
        new_focused_window = get_focused_window()

        # We need to update the container because the focus has changed.
        request_update!(new_focused_window.widget_container)

        # Hide the cursor until a widget request it.
        NCurses.curs_set(0)

        # Move the window to the top.
        NCurses.top_panel(new_focused_window.panel)

        @emit new_focused_window focus_acquired
    end

    return nothing
end

"""
    _search_next_window_to_focus() -> Nothing

Search the next window that can accept focus in the list. It returns the window ID of
`nothing` if no window can accept the focus.
"""
function _search_next_window_to_focus()
    @unpack windows, focused_window_id = tui

    num_windows = length(windows)
    num_windows == 0 && return nothing

    # Number of tries to request the focus.
    num_tries = 0

    focus_candidate_id = focused_window_id == 0 ? 1 : focused_window_id + 1

    while num_tries < num_windows
        if focus_candidate_id > num_windows
            focus_candidate_id = 1
        end

        candidate_window = windows[focus_candidate_id]

        # Check if the candidate can accept the focus.
        can_accept_focus(candidate_window) && return focus_candidate_id

        focus_candidate_id = focus_candidate_id + 1
        num_tries += 1
    end

    return nothing
end

"""
    _search_previous_window_to_focus() -> Nothing

Search the previous window that can accept focus in the list. It returns the window ID of
`nothing` if no window can accept the focus.
"""
function _search_previous_window_to_focus()
    @unpack windows, focused_window_id = tui

    num_windows = length(windows)
    num_windows == 0 && return nothing

    # Number of tries to request the focus.
    num_tries = 0

    focus_candidate_id = focused_window_id == 0 ? num_windows : focused_window_id - 1

    while num_tries < num_windows
        if focus_candidate_id <= 0
            focus_candidate_id = num_windows
        end

        candidate_window = windows[focus_candidate_id]

        # Check if the candidate can accept the focus.
        can_accept_focus(candidate_window) && return focus_candidate_id

        focus_candidate_id = focus_candidate_id - 1
        num_tries += 1
    end

    return nothing
end
