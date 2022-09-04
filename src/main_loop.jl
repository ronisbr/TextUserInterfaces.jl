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

        elseif k.ktype == :F1
            break
        end

        tui_update()
    end

    destroy_tui()

    return nothing
end
