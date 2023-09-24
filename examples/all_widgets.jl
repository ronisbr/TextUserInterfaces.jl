using TextUserInterfaces

# Initialize TUI, create the widgets, and start the application main loop.
function all_widgets()
    initialize_tui()

    logger.enabled = true
    logger.level = DEBUG

    w = create_window(
        border = true,
        theme  = Theme(border = ncurses_color(243, :black)),
        title  = " All Widgets ",
        layout = ObjectLayout(
            bottom_anchor = Anchor(ROOT_WINDOW, :bottom, -3),
            left_anchor   = Anchor(ROOT_WINDOW, :left),
            right_anchor  = Anchor(ROOT_WINDOW, :right),
            top_anchor    = Anchor(ROOT_WINDOW, :top)
        ),
    )

    c = w.widget_container

    # Label
    # ======================================================================================

    label = @tui_label(
        parent      = c,
        left_anchor = (:parent, :left),
        top_anchor  = (:parent, :top),
        text        = "This is a label."
    )

    # ANSI Label
    # ======================================================================================

    ansi_label = @tui_ansi_label(
        parent      = c,
        left_anchor = (:parent, :left),
        top_anchor  = (label, :bottom),
        text        = "\e[1mThis \e[34mis a color \e[47mlabel."
    )

    # Button
    # ======================================================================================

    button_1 = @tui_button(
        parent      = c,
        left_anchor = (:parent, :left),
        top_anchor  = (ansi_label, :bottom, 1),
        style       = :simple
    )

    button_2 = @tui_button(
        parent        = c,
        left_anchor   = (button_1, :right),
        middle_anchor = (button_1, :middle),
        style         = :boxed
    )

    button_3 = @tui_button(
        parent        = c,
        left_anchor   = (button_2, :right),
        middle_anchor = (button_2, :middle),
        style         = :none
    )

    # Input Fields
    # ======================================================================================

    input_field_1 = @tui_input_field(
        parent      = c,
        left_anchor = (:parent, :left),
        top_anchor  = (button_2, :bottom),
        style       = :simple
    )

    input_field_2 = @tui_input_field(
        parent      = c,
        left_anchor = (:parent, :left),
        top_anchor  = (input_field_1, :bottom),
        style       = :boxed
    )

    input_field_3 = @tui_input_field(
        parent      = c,
        left_anchor = (:parent, :left),
        top_anchor  = (input_field_2, :bottom),
        style       = :none
    )

    # Bottom Window
    # ======================================================================================

    # Bottom window to show information.
    bw = create_window(;
        border    = true,
        theme     = Theme(border = ncurses_color(243, :black)),
        focusable = false,
        layout    = ObjectLayout(
            bottom_anchor = Anchor(ROOT_WINDOW, :bottom),
            left_anchor   = Anchor(ROOT_WINDOW, :left),
            right_anchor  = Anchor(ROOT_WINDOW, :right),
            height        = 3
        ),
    )

    # Create a bottom window for the information.
    cy  = "\e[33;1m"
    cg  = "\e[38;5;243m"
    cr  = "\e[0m"
    sep = cg * " | " * cr

    @tui_ansi_label(
        parent        = bw.widget_container,
        alignment     = :r,
        bottom_anchor = (:parent, :bottom),
        left_anchor   = (:parent, :left),
        right_anchor  = (:parent, :right),
        top_anchor    = (:parent, :top),
        text          = cy * "F1" * cr * " : Quit"
    )

    app_main_loop()
end

all_widgets()
