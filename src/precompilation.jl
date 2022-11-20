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

    new_stdout = IOContext(IOBuffer(), IOContext(stdout))

    old_stdout = stdout
    in, out = redirect_stdout()

    SnoopPrecompile.@precompile_all_calls begin
        initialize_tui()

        logger.enabled = false

        win = create_window(title = "Window")

        con = @tui_container(
            parent = win.widget_container,
            border = true,
            anchor_top = (:parent, :top),
            anchor_bottom = (:parent, :bottom),
            anchor_left = (:parent, :left),
            anchor_right = (:parent, :center)
        )

        label = @tui_label(
            text = "This is a label",
            anchor_top = (:parent, :top),
            anchor_left = (:parent, :left),
            parent = con
        )

        button = @tui_button(
            label = "Button",
            anchor_top = (label, :bottom),
            anchor_left = (:parent, :left),
            parent = con
        )

        input = @tui_input_field(
            anchor_top = (button, :bottom),
            anchor_left = (:parent, :left),
            anchor_right = (:parent, :right),
            parent = con
        )

        # Create the keycodes to process the information.
        k_tab = Keystroke(9, string(Char(9)), :tab, false, false, false)
        k_a   = Keystroke(0x61, "a", :char, false, false, false)

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
        destroy_tui()
    end
end
