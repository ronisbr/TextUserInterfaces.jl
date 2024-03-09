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

    function button_return_pressed(w; new_label, label_widget)
        change_text!(label_widget, new_label)
        return nothing
    end

    button_1 = @tui_button(
        parent      = c,
        style       = :simple,
        left_anchor = (:parent, :left),
        top_anchor  = (ansi_label, :bottom, 1),
    )

    button_2 = @tui_button(
        parent        = c,
        style         = :boxed,
        left_anchor   = (button_1, :right),
        middle_anchor = (button_1, :middle),
    )

    button_3 = @tui_button(
        parent        = c,
        style         = :none,
        left_anchor   = (button_2, :right),
        middle_anchor = (button_2, :middle),
    )

    button_information = @tui_label(
        parent        = c,
        text          = "",
        left_anchor   = (button_3, :right, 2),
        right_anchor  = (:parent, :right),
        middle_anchor = (button_3, :middle),
    )

    @connect(
        button_1,
        return_pressed,
        button_return_pressed,
        (new_label = "Button #1 was pressed.", label_widget = button_information)
    )

    @connect(
        button_2,
        return_pressed,
        button_return_pressed,
        (new_label = "Button #2 was pressed.", label_widget = button_information)
    )

    @connect(
        button_3,
        return_pressed,
        button_return_pressed,
        (new_label = "Button #3 was pressed.", label_widget = button_information)
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

    function list_box_return_pressed(w; label_widget)
        current_item   = get_current_item(w)
        selected_items = get_selected_items(w)
        str = "Current item: $(current_item), Selected items: $(selected_items)."
        change_text!(label_widget, str)
        return nothing
    end

    list_box_1 = @tui_list_box(
        parent          = c,
        data            = ["Item #$i" for i in 1:10],
        number_of_lines = 5,
        left_anchor     = (:parent, :left),
        top_anchor      = (input_field_3, :bottom),
    )

    list_box_1_information = @tui_label(
        parent        = c,
        text          = "",
        left_anchor   = (list_box_1, :right, 2),
        right_anchor  = (:parent, :right),
        middle_anchor = (list_box_1, :middle)
    )

    @connect(
        list_box_1,
        return_pressed,
        list_box_return_pressed,
        (; label_widget = list_box_1_information)
    )

    list_box_2 = @tui_list_box(
        parent             = c,
        border = true,
        data               = ["Item #$i" for i in 1:10],
        multiple_selection = true,
        number_of_lines    = 5,
        show_icon          = true,
        left_anchor        = (list_box_1, :left),
        top_anchor         = (list_box_1, :bottom),
    )

    list_box_2_information = @tui_label(
        parent        = c,
        text          = "",
        left_anchor   = (list_box_2, :right, 2),
        right_anchor  = (:parent, :right),
        middle_anchor = (list_box_2, :middle)
    )

    @connect(
        list_box_2,
        return_pressed,
        list_box_return_pressed,
        (; label_widget = list_box_2_information)
    )

    # Combo Box
    # ======================================================================================

    function combo_box_item_changed(w; label_widget)
        current_item = get_item(w)
        str = "Current item: $(current_item)."
        change_text!(label_widget, str)
        return nothing
    end

    combo_box_1 = @tui_combo_box(
        parent             = c,
        data               = ["Item #$i" for i in 1:10],
        left_anchor        = (list_box_2, :left),
        top_anchor         = (list_box_2, :bottom),
    )

    combo_box_1_information = @tui_label(
        parent        = c,
        text          = "",
        left_anchor   = (combo_box_1, :right, 2),
        right_anchor  = (:parent, :right),
        middle_anchor = (combo_box_1, :middle)
    )

    @connect(
        combo_box_1,
        item_changed,
        combo_box_item_changed,
        (; label_widget = combo_box_1_information)
    )

    # Horizontal Line
    # ======================================================================================

    hl1 = @tui_horizontal_line(
        parent = c,
        top_anchor = (combo_box_1, :bottom),
        left_anchor = (:parent, :left),
        right_anchor = (:parent, :right)
    )

    hl2 = @tui_horizontal_line(
        parent = c,
        pattern = "+-",
        top_anchor = (hl1, :bottom),
        left_anchor = (:parent, :left),
        right_anchor = (:parent, :right)
    )

    # Progress Bar
    # ======================================================================================

    pb = @tui_progress_bar(
        parent = c,
        top_anchor = (hl2, :bottom),
        left_anchor = (:parent, :left),
        right_anchor = (:parent, :right),
        value = 0,
        show_value = true,
        theme = Theme(default = ncurses_color(:green, 246))
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

    # == Signals ===========================================================================

    # Function to handle keystrokes.
    function handle_keystroke(tui; keystroke, kwargs...)
        if keystroke.value == "+"
            set_value!(pb, pb.value + 1)
        elseif keystroke.value == "-"
            set_value!(pb, pb.value - 1)
        end
    end

    @connect tui keypressed handle_keystroke

    app_main_loop()
end

all_widgets()
