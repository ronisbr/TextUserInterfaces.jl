## Description #############################################################################
#
# Precompilation.
#
############################################################################################

import PrecompileTools

PrecompileTools.@setup_workload begin
    # We must load the NCurses libraries first.
    __init__()

    logger.enabled = true
    logger.level = DEBUG
    logger.logfile = mktemp() |> first

    old_stdout = stdout
    old_stdin  = stdin
    new_stdout = redirect_stdout()
    new_stdin  = redirect_stdin()

    PrecompileTools.@compile_workload begin

        # == Precompile Initializaion Functions ============================================

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

        ansi_label = @tui_ansi_label(
            text = "\e[35mThis is an ANSI label.",
            left_anchor = (:parent, :left),
            top_anchor = (label, :bottom),
            parent = con
        )

        button = @tui_button(
            label = "Button",
            left_anchor = (:parent, :left),
            top_anchor = (ansi_label, :bottom),
            parent = con
        )

        hline = @tui_horizontal_line(
            top_anchor = (button, :bottom),
            left_anchor = (:parent, :left),
            right_anchor = (:parent, :right),
            parent = con
        )

        input = @tui_input_field(
            top_anchor = (hline, :bottom),
            left_anchor = (:parent, :left),
            right_anchor = (:parent, :right),
            parent = con
        )

        lbox = @tui_list_box(
            data = ["Item 1", "Item 2", "Item 3"],
            top_anchor = (input, :bottom),
            left_anchor = (:parent, :left),
            parent = con
        )

        pbar = @tui_progress_bar(
            top_anchor = (lbox, :bottom),
            left_anchor = (:parent, :left),
            right_anchor = (:parent, :right),
            parent = con
        )
        set_value!(pbar, 50)

        # == Precompile Functions Related to TUI Update ====================================

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

        # == Precompile Input Related to Functions =========================================

        write(new_stdin, 'A')
        getkey()
        write(new_stdin, 'A')
        getkey(tui.stdscr)

        # == Precompile All Functions Related to TUI Desctruction ==========================

        destroy_tui()
    end

    # Restore the default log file.
    logger.logfile = "./tui.log"

    # redirect_stdout(old_stdout)
end
