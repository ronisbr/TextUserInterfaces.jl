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
        text        = "This is a label.",
        left_anchor = (:parent, :left),
        top_anchor  = (:parent, :top)
    )

    # ANSI Label
    # ======================================================================================

    ansi_label = @tui_ansi_label(
        parent      = c,
        text        = "\e[1mThis \e[34mis a color \e[47mlabel.",
        left_anchor = (:parent, :left),
        top_anchor  = (label, :bottom)
    )

    # Button
    # ======================================================================================

    button_1 = @tui_button(
        parent      = c,
        style       = :simple,
        left_anchor = (:parent, :left),
        top_anchor  = (ansi_label, :bottom, 1)
    )

    button_2 = @tui_button(
        parent        = c,
        style         = :boxed,
        left_anchor   = (button_1, :right),
        middle_anchor = (button_1, :middle)
    )

    button_3 = @tui_button(
        parent        = c,
        style         = :none,
        left_anchor   = (button_2, :right),
        middle_anchor = (button_2, :middle)
    )

    # Input Fields
    # ======================================================================================

    input_field_1 = @tui_input_field(
        parent      = c,
        style       = :simple,
        left_anchor = (:parent, :left),
        top_anchor  = (button_2, :bottom)
    )

    input_field_2 = @tui_input_field(
        parent      = c,
        style       = :boxed,
        left_anchor = (:parent, :left),
        top_anchor  = (input_field_1, :bottom)
    )

    input_field_3 = @tui_input_field(
        parent      = c,
        style       = :none,
        left_anchor = (:parent, :left),
        top_anchor  = (input_field_2, :bottom)
    )

    # List Box
    # ======================================================================================

    list_box_1 = @tui_list_box(
        parent          = c,
        data            = ["Item #$i" for i in 1:10],
        number_of_lines = 5,
        left_anchor     = (:parent, :left),
        top_anchor      = (input_field_3, :bottom),
    )

    list_box_2 = @tui_list_box(
        parent             = c,
        data               = ["Item #$i" for i in 1:10],
        multiple_selection = true,
        number_of_lines    = 5,
        show_icon          = true,
        left_anchor        = (list_box_1, :right),
        top_anchor         = (list_box_1, :top),
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
