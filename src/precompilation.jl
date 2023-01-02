# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Precompilation.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

import SnoopPrecompile

SnoopPrecompile.@precompile_setup begin
    # We must load the NCurses libraries first.
    __init__()

    logger.enabled = true
    logger.level = INFO
    logger.logfile = mktemp() |> first

    old_stdout = stdout
    old_stdin  = stdin
    new_stdout = redirect_stdout()
    new_stdin  = redirect_stdin()

    SnoopPrecompile.@precompile_all_calls begin
        # Precompile initializaion functions
        # ======================================================================

        initialize_tui()

        win = create_window(title = "Window")

        con = @tui_container(
            parent = win.widget_container,
            border = true,
            bottom_anchor = (:parent, :bottom),
            left_anchor = (:parent, :left),
            right_anchor = (:parent, :center),
            top_anchor = (:parent, :top),
        )

        label = @tui_label(
            text = "This is a label",
            left_anchor = (:parent, :left),
            top_anchor = (:parent, :top),
            parent = con
        )

        button = @tui_button(
            label = "Button",
            left_anchor = (:parent, :left),
            top_anchor = (label, :bottom),
            parent = con
        )

        input = @tui_input_field(
            top_anchor = (button, :bottom),
            left_anchor = (:parent, :left),
            right_anchor = (:parent, :right),
            parent = con
        )

        # Precompile functions related to TUI update
        # ======================================================================

        # Create the keycodes to process the information.
        k_tab = Keystroke(9, string(Char(9)), :tab, false, false, false)
        k_a = Keystroke(0x61, "a", :char, false, false, false)

        # Call the important functions in the main loop.
        isnothing(get_focused_window()) && move_focus_to_next_window()
        tui_update()

        process_keystroke(k_tab)
        tui_update()

        process_keystroke(k_tab)
        tui_update()

        process_keystroke(k_a)
        tui_update()

        process_keystroke(k_a)
        tui_update()

        # Precompile input related functions
        # ======================================================================

        write(new_stdin, 'A')
        getkey()
        write(new_stdin, 'A')
        getkey(tui.stdscr)

        # Precompile all functions related to TUI desctruction
        # ======================================================================

        destroy_tui()
    end

    # Restore the default log file.
    logger.logfile = "./tui.log"

    redirect_stdout(old_stdout)
end
