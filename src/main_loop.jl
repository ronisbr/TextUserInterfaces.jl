# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Main application loop.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export app_main_loop

function app_main_loop()
    # Update everything before starting the loop.
    tui_update()

    # Main application loop.
    while true
        k = getkey()
        @emit tui keypressed (; keystroke = k)

        if k.ktype == :F1
            break
        else
            process_keystroke(k)
        end

        tui_update()
    end

    destroy_tui()

    return nothing
end
