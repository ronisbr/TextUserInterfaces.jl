# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Main application loop.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export app_main_loop

"""
    app_main_loop(fprev::Function = (k)->true, fpost::Function = (k)->true; destroy_on_exit::Bool = true, manage_window_switch::Bool = true)

Initialize the application main loop.

The function `fprev` is called after every pressed key and before the focus is
processed. It must have the following signature:

    fprev(k::Keystroke)::Bool

If it returns `true`, then the keystroke is processed. Otherwise, the software
waits for another keystroke.

The function `fpost` is called after the keystroke is processed. It must have
the following signature:

    fpost(k::Keystroke)::Bool

If it return `true`, then the loop continues and a next keysotrke is requested.
Otherwise, the loop is terminated.

# Keywords

* `destroy_on_exit`: If `true`, then `destroy_tui()` is called when we exit from
                     the loop.
* `manage_window_switch`: If `true`, then `F2` and `F3` move to next and
                          previous windows.

"""
function app_main_loop(fprev::Function = (k)->true,
                       fpost::Function = (k)->true;
                       destroy_on_exit::Bool = true,
                       manage_window_switch::Bool = true)

    # If the user did not defined a focus chain, then set it with all available
    # windows.
    isempty(tui.focus_chain) && (tui.focus_chain = copy(tui.wins))

    # Initialize focus manager.
    init_focus_manager()

    # Update everything before starting the loop.
    tui_update()

    # Main application loop.
    while true
        k = jlgetch()

        !fprev(k) && continue

        if k.ktype == :F1
            break
        elseif manage_window_switch && (k.ktype == :F2)
            next_window()
        elseif manage_window_switch && (k.ktype == :F3)
            previous_window()
        else
            process_focus(k)
        end

        !fpost(k) && break
    end

    # If the user wants, destroys everything.
    destroy_on_exit && destroy_tui()

    return nothing
end
