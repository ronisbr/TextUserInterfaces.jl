## Description #############################################################################
#
# Precompilation.
#
############################################################################################

import PrecompileTools

PrecompileTools.@setup_workload begin
    get(ENV, "TERM", "unknown") == "unknown" && return nothing

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

        @tui_builder begin
            con = @tui_container(
                parent        = win.widget_container,
                border        = true,
                bottom_anchor = (:parent, :bottom),
                left_anchor   = (:parent, :left),
                right_anchor  = (:parent, :center),
                top_anchor    = (:parent, :top),
            )

            ansi_label = @tui_ansi_label(
                parent      = con,
                text        = "\e[35mThis is an ANSI label.",
                left_anchor = (:parent, :left),
                top_anchor  = (:parent, :top)
            )

            button = @tui_button(
                parent      = con,
                label       = "Button",
                left_anchor = (:parent, :left),
                top_anchor  = (__LAST__, :bottom),
            )

            dm = @tui_display_matrix(
                parent       = con,
                matrix       = randn(3, 3),
                left_anchor  = (:parent, :left),
                right_anchor = (:parent, :right),
                top_anchor   = (__LAST__, :bottom),
            )
            change_matrix!(dm, randn(3, 3))

            combo_box = @tui_combo_box(
                parent       = con,
                data         = ["Option 1", "Option 2", "Option 3"],
                left_anchor  = (:parent, :left),
                right_anchor = (:parent, :right),
                top_anchor   = (__LAST__, :bottom),
            )

            hline = @tui_horizontal_line(
                parent       = con,
                top_anchor   = (__LAST__, :bottom),
                left_anchor  = (:parent, :left),
                right_anchor = (:parent, :right)
            )

            input = @tui_input_field(
                parent       = con,
                left_anchor  = (:parent, :left),
                right_anchor = (:parent, :right),
                top_anchor   = (__LAST__, :bottom),
            )

            label = @tui_label(
                parent      = con,
                label       = "This is a label",
                left_anchor = (:parent, :left),
                top_anchor  = (__LAST__, :bottom)
            )

            lbox = @tui_list_box(
                parent      = con,
                data        = ["Item 1", "Item 2", "Item 3"],
                left_anchor = (:parent, :left),
                top_anchor  = (__LAST__, :bottom),
            )

            pbar = @tui_progress_bar(
                parent       = con,
                left_anchor  = (:parent, :left),
                right_anchor = (:parent, :right),
                top_anchor   = (__LAST__, :bottom),
            )
            set_value!(pbar, 50)

            raw = @tui_raw_buffer(
                parent       = con,
                left_anchor  = (:parent, :left),
                right_anchor = (:parent, :right),
                top_anchor   = (__LAST__, :bottom),
                height       = 5
            )

            text = @tui_text(
                parent       = con,
                text         = "This is a text widget.\nIt can handle multiple lines of text.",
                left_anchor  = (:parent, :left),
                right_anchor = (:parent, :right),
                top_anchor   = (__LAST__, :bottom),
            )
        end

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

        # == Precompile All Functions Related to TUI Destruction ===========================

        destroy_tui()
    end

    # Restore the default log configurations.
    logger.logfile = "./tui.log"
    logger.level   = CRITICAL

    # redirect_stdout(old_stdout)
end
