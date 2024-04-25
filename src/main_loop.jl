## Description #############################################################################
#
# Main application loop.
#
############################################################################################

export app_main_loop

"""
    check_keystroke(k1::Keystroke, k2::Keystroke) -> Bool
    check_keystroke(k1::Symbol, k2::Symbol) -> Bool
    check_keystroke(k1::Symbol, k2::Keystroke) -> Bool
    check_keystroke(k1::Keystroke, k2::Symbol) -> Bool

Evaluate if either keystroke.type or keystroke k1 and k2 match
"""
check_keystroke(k1::Keystroke, k2::Keystroke) = k1 == k2
check_keystroke(k1::Symbol, k2::Symbol) = k1 == k2
check_keystroke(k1::Keystroke, k2::Symbol) = k1.ktype == k2
check_keystroke(k1::Symbol, k2::Keystroke) = k1 == k2.ktype


"""
    app_main_loop() -> Nothing

Start the application main loop.
"""
function app_main_loop(; exitkey = :F1)
    # If there is no window in focus, try to acquire it.
    isnothing(get_focused_window()) && move_focus_to_next_window()

    # Update everything before starting the loop.
    tui_update()

    # Main application loop.
    while true
        k = getkey()
        @emit tui keypressed (; keystroke = k)

        # If the signal destroyed the TUI, we should just exit.
        !tui.initialized && break

        # Check if the keystroke must be passed or if the signal hijacked it.
        if !@get_signal_property(tui, keypressed, block, false)
            if check_keystroke(k, exitkey)
                break
            else
                process_keystroke(k)
            end
        end

        @delete_signal_property tui keypressed block

        tui_update()
    end

    destroy_tui()

    return nothing
end
