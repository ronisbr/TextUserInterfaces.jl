## Description #############################################################################
#
# Main application loop.
#
############################################################################################

export app_main_loop, app_main_loop_iteration

"""
    app_main_loop() -> Nothing

Start the application main loop.

# Keywords

- `exitkey::Symbol`: A symbol that defines the key that leads to the application
    termination.
    (**Default**: `:F1`)
"""
function app_main_loop(; exitkey = :F1)
    # If there is no window in focus, try to acquire it.
    isnothing(get_focused_window()) && move_focus_to_next_window()

    # Update everything before starting the loop.
    tui_update()

    # Main application loop.
    while true
        app_main_loop_iteration(; block = true, exitkey) || break
    end

    destroy_tui()

    return nothing
end

"""
    app_main_loop_iteration(; kwargs...) -> Bool

Execute one iteration of the application main loop. If this funciton returns `true`, it
means that the should continue the iterations. Otherwise, we must quit the application.

# Keywords

- `block::Bool`: If `true`, the function will block waiting for a keystroke.
    (**Default**: `true`)
- `exitkey::Symbol`: A symbol that defines the key that leads to the application
    termination.
    (**Default**: `:F1`)
"""
function app_main_loop_iteration(; block::Bool = true, exitkey::Symbol = :F1)
    k = getkey(; block)
    @emit tui keypressed (; keystroke = k)

    # If the signal destroyed the TUI, we should just exit.
    !tui.initialized && return false

    # Check if the keystroke must be passed or if the signal hijacked it.
    if !@get_signal_property(tui, keypressed, block, false)
        if _check_keystroke(k, exitkey)
            return false
        else
            process_keystroke(k)
        end
    end

    @delete_signal_property tui keypressed block

    tui_update()

    return true
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _check_keystroke(k1::Keystroke, k2::Keystroke) -> Bool
    _check_keystroke(k1::Symbol, k2::Symbol) -> Bool
    _check_keystroke(k1::Symbol, k2::Keystroke) -> Bool
    _check_keystroke(k1::Keystroke, k2::Symbol) -> Bool

Evaluate if either `keystroke.ktype` or `keystroke` `k1` and `k2` match.
"""
_check_keystroke(k1::Keystroke, k2::Keystroke) = k1 == k2
_check_keystroke(k1::Symbol, k2::Symbol) = k1 == k2
_check_keystroke(k1::Keystroke, k2::Symbol) = k1.ktype == k2
_check_keystroke(k1::Symbol, k2::Keystroke) = k1 == k2.ktype

