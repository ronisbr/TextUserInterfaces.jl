# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Focus manager.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export get_focused_window, init_focus_manager, process_focus, request_focus
export set_focus_chain, next_window, previous_window

"""
    get_focused_window()

Return the focused window.
"""
get_focused_window() = tui.focus_win

"""
    init_focus_manager()

Initialization of the focus manager. The elements in `focus_chain` are iterated
to find the first one that can accept the focus.
"""
init_focus_manager() = next_window()

"""
    process_focus(k::Keystroke)

Process the focus considering the user's keystorke `k`.
"""
function process_focus(k::Keystroke)
    @unpack focus_win, focus_chain = tui

    # If we receive a resize event, we must repositioning all the windows.
    if k.ktype == :resize
        for win in tui.wins
            # Here, we need to force the repositioning. For some reason, if a
            # window occupies the entire screen, then NCurses automatically
            # change the value returned by `getmaxx` and `getmaxy`. Thus, the
            # repositioning algorithm thinks we do not need to resize the window
            # and then the buffers are not resized. This is not the fastest
            # algorithm, but since resize events tends to be sparse, there will
            # not be noticeable impact.
            reposition!(win; force = true)
        end
    else
        if focus_win == nothing
            length(focus_chain) == 0 && return nothing
            next_window()
        end

        process_focus(focus_win, k)
    end

    tui_update()

    return nothing
end

"""
    next_window()

Move the focus to the next window.
"""
function next_window()
    @unpack focus_chain, focus_id = tui

    @log verbose "next_window" "Focus: Change the focused window."

    num_wins = length(focus_chain)

    # If there is no window, then just return.
    if num_wins == 0
        @log verbose "next_window" "Focus: There is no window in the focus chain."
        return nothing
    end

    # Loop from the current position until the end of the focus chain.
    for i in focus_id+1:num_wins
        if request_focus(focus_chain[i])
            tui.focus_id = i
            tui_update()

            return nothing
        end
    end

    # Loop from the beginning of the chain until the current position.
    for i in 1:tui.focus_id
        if request_focus(focus_chain[i])
            tui.focus_id = i
            tui_update()

            return nothing
        end
    end

    # If no window can accept focus, then just return.
    return nothing
end

"""
    previous_window()

Move the focus to the previous window.
"""
function previous_window()
    @unpack focus_chain, focus_id = tui

    @log verbose "previous_window" "Focus: Change the focused window."

    num_wins = length(focus_chain)

    # If there is no window, then just return.
    if num_wins == 0
        @log verbose "previous_window" "Focus: There is no window in the focus chain."
        return nothing
    end

    # Loop from the current position until the beginning of the focus chain.
    for i in focus_id-1:-1:1
        if request_focus(focus_chain[i])
            tui.focus_id = i
            tui_update()

            return nothing
        end
    end

    # Loop from the end of the chain until the current position.
    for i in num_wins:-1:tui.focus_id
        if request_focus(focus_chain[i])
            tui.focus_id = i
            tui_update()

            return nothing
        end
    end

    # If no window can accept focus, then just return.
    return nothing
end

"""
    request_focus(win::Window)

Request the focus to the window `win`. If `win` cannot get the focus, then
nothing happens and it returns `false`. If `win`can get the focus, then the
focus is passed to it and the function returns `true`.

# Remarks

Even if `win` is in the focus chain, the `focus_id` will not change by
requesting focus to `win`. This means that the window focus order is not altered
by this function.
"""
function request_focus(win::Window)
    if accept_focus(win)
        @log verbose "request_focus" "Focus: Switched to window $(obj_desc(win))."
        tui.focus_win = win
        tui_update()

        return true
    else
        @log verbose "request_focus" "Focus: The window $(obj_desc(win)) cannot get the focus."

        return false
    end
end

"""
    set_focus_chain(wins::Window...; new_focus_id::Int = 1)

Set the focus chain, *i.e.* the ordered list of windows that can receive the
focus. The keyword `new_focus_id` can be set to specify which element is
currently focused in the new chain.
"""
function set_focus_chain(wins::Window...; new_focus_id::Int = 1)
    tui.focus_ptr != nothing && release_focus(tui.focus_ptr)
    tui.focus_ptr = nothing
    tui.focus_chain = [wins...]
    force_focus_change(new_focus_id)
    return nothing
end
