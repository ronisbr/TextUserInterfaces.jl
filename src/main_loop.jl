# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Main application loop.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export app_main_loop

"""
    app_main_loop() -> Nothing

Start the application main loop.
"""
function app_main_loop()
    # If there is no window in focus, try to acquire it.
    isnothing(get_focused_window()) && move_focus_to_next_window()

    # Update everything before starting the loop.
    tui_update()

    # Main application loop.
    while true
        k = getkey()
        @emit tui keypressed (; keystroke = k)

        # Check if the keystroke must be passed or if the signal hijacked it.
        if !@get_signal_property(tui, keypressed, block, false)
            if k.ktype === :F1
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
