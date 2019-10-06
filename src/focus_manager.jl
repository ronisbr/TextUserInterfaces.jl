# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Description
#
#   Focus manager.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export get_focused_window, init_focus_manager, process_focus,
       request_focus_change, set_focus_chain, set_next_window_func,
       set_previous_window_func

"""
    function get_focused_window()

Return the focused window.

"""
get_focused_window() = tui.focus_chain[tui.focus_id]

"""
    function init_focus_manager()

Initialization of the focus manager. The elements in `focus_chain` are iterated
to find the first one that can accept the focus.

"""
function init_focus_manager()
    next_window()
end

"""
    function process_focus(k::Keystroke)

Process the focus considering the user's keystorke `k`.

"""
function process_focus(k::Keystroke)
    @unpack focus_chain, focus_id = tui

    # With no windows, there is nothing to process.
    num_wins = length(focus_chain)
    num_wins == 0 && return nothing

    # Check if the user wants the another window.
    if tui.wants_next_window(k)
        next_window()
    elseif tui.wants_previous_window(k)
        previous_window()
    else
        process_focus(focus_chain[focus_id], k)
    end

    refresh_all_windows()
    update_panels()
    doupdate()

    return nothing
end

"""
    function next_window()

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
    for i = focus_id+1:num_wins
        if accept_focus(focus_chain[i])
            tui.focus_id = i

            @log verbose "next_window" "Focus: Switched to window $(focus_chain[i].id)."

            refresh_all_windows()
            update_panels()
            doupdate()

            return nothing
        end
    end

    # Loop from the beginning of the chain until the current position.
    for i = 1:tui.focus_id
        if accept_focus(focus_chain[i])
            tui.focus_id = i

            @log verbose "next_window" "Focus: Switched to window $(focus_chain[i].id)."

            refresh_all_windows()
            update_panels()
            doupdate()

            return nothing
        end
    end

    # If no window can accept focus, then just return.
    return nothing
end

"""
    function previous_window()

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
    for i = focus_id-1:-1:1
        if accept_focus(focus_chain[i])
            tui.focus_id = i

            @log verbose "previous_window" "Focus: Switched to window $(focus_chain[i].id)."

            refresh_all_windows()
            update_panels()
            doupdate()

            return nothing
        end
    end

    # Loop from the end of the chain until the current position.
    for i = num_wins:-1:tui.focus_id
        if accept_focus(focus_chain[i])
            tui.focus_id = i

            @log verbose "previous_window" "Focus: Switched to window $(focus_chain[i].id)."

            refresh_all_windows()
            update_panels()
            doupdate()

            return nothing
        end
    end

    # If no window can accept focus, then just return.
    return nothing
end

"""
    function set_focus_chain(wins::Window...; new_focus_id::Integer = 1)

Set the focus chain, *i.e.* the ordered list of windows that can receive the
focus. The keyword `new_focus_id` can be set to specify which element is
currently focused in the new chain.

"""
function set_focus_chain(wins::Window...; new_focus_id::Integer = 1)
    tui.focus_ptr != nothing && release_focus(tui.focus_ptr)
    tui.focus_ptr = nothing
    tui.focus_chain = [wins...]
    force_focus_change(new_focus_id)
    return nothing
end

"""
    function set_next_window_func(f)

Set the function `f` to be the one that will be called to check whether the user
wants the next window. The signature must be:

    f(k::Keystroke)::Bool

It must return `true` if the next window is required of `false` otherwise.

"""
function set_next_window_func(f)
    tui.wants_next_window = f
    return nothing
end

"""
    function set_previous_window_func(f)

Set the function `f` to be the one that will be called to check whether the user
wants the previous window. The signature must be:

    f(k::Keystroke)::Bool

It must return `true` if the previous window is required of `false` otherwise.

"""
function set_previous_window_func(f)
    tui.wants_previous_window = f
    return nothing
end
