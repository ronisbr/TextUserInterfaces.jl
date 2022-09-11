# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the global focus manager.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export focus_next_window, focus_previous_window, process_keystroke

"""
    process_keystroke(k::Keystroke)

Process the keystroke `k` in the application level. This function finds the
current window in focus and send the keystroke to it.
"""
function process_keystroke(k::Keystroke)
    # The only activity we need to perform in the global focus manager is to
    # check for resizing events and pass the keystroke to the windows in focus.
    if k.ktype == :resize
        for win in tui.windows
            # Here, we need to force the layout update. For some reason, if
            # a window occupies the entire screen, then NCurses
            # automatically change the value returned by `getmaxx` and
            # `getmaxy`. Thus, the repositioning algorithm thinks we do not
            # need to resize the window and then the buffers are not
            # resized. This is not the fastest algorithm, but since resize
            # events tends to be sparse, there will not be noticeable
            # impact.
            update_layout!(win; force=true)
        end
    else
        while true
            focused_window = get_focused_window()

            if !isnothing(focused_window)
                r = process_keystroke(focused_window, k)

                if r === :keystroke_processed
                    break

                elseif r === :next_window
                    focus_next_window()
                    new_focused_window = get_focused_window()

                    # If the current window request to change the focus, but the
                    # only focusable window is it, do nothing.
                    new_focused_window === focused_window && break

                elseif r === :previous_window
                    focus_previous_window()
                    new_focused_window = get_focused_window()

                    # If the current window request to change the focus, but the
                    # only focusable window is it, do nothing.
                    new_focused_window === focused_window && break

                else
                    @log CRITICAL "process_keystroke" """
                    The function `process_keystroke` for the object $(obj_desc(focused_window)) returned a invalid value: $(r)."""
                    break
                end
            else
                focus_next_window()

                # If no window can be focused, do nothing.
                new_focused_window = get_focused_window()
                isnothing(new_focused_window) && break
            end
        end
    end
end

"""
    focus_next_window()

Move the focus to the next window.
"""
function focus_next_window()
    _change_focused_window(i -> i + 1)
    return nothing
end

"""
    focus_previous_window()

Move the focus to the previous window.
"""
function focus_previous_window()
    _change_focused_window(i -> i - 1)
    return nothing
end

"""
    get_focused_window()

Return the current window in focus. If no window is in focus, return `nothing`.
"""
function get_focused_window()
    focused_window_id = tui.focused_window_id
    windows = tui.windows

    @inbounds if focused_window_id == 0
        return nothing
    else
        if focused_window_id > length(windows)
            @log CRITICAL "get_focused_window" """
            The focused window ID is outside the allowed range."""
            return nothing
        end

        return windows[focused_window_id]
    end
end

#                              Private functions
# ==============================================================================

# Change the focus window to the next in the list. The next is obtained by the
# `advance` function, which must change the current focus candidate index to the
# desired one.
function _change_focused_window(advance::Function)
    num_windows = length(tui.windows)
    num_windows == 0 && return nothing

    focus_candidate = (tui.focused_window_id |> advance) % (num_windows + 1)

    # Number of tries to request the focus.
    num_tries = 0

    while true
        if focus_candidate <= 0
            # We need to know in which direction we are heading to check the
            # next candidate.
            aux = focus_candidate |> advance
            focus_candidate = aux >= 0 ? 1 : num_windows
        end

        num_tries += 1

        if request_focus(tui.windows[focus_candidate])
            tui.focused_window_id = focus_candidate
            return nothing
        end

        # If the number of tries is equal the number of windows, no window can
        # accept the focus.
        if num_tries == num_windows
            tui.focused_window_id = 0
            return nothing
        end

        focus_candidate = (focus_candidate |> advance) % (num_windows + 1)
    end

    return nothing
end
