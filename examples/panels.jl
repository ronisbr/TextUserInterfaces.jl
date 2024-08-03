using TextUserInterfaces

# Create a set of panels.
function panels()
    initialize_tui()

    logger.enabled = true
    logger.level = DEBUG

    w = create_window(
        border = true,
        theme  = Theme(border = ncurses_color(243, :black)),
        title  = " Panels ",
        layout = ObjectLayout(
            bottom_anchor = Anchor(ROOT_WINDOW, :bottom, -3),
            left_anchor   = Anchor(ROOT_WINDOW, :left),
            right_anchor  = Anchor(ROOT_WINDOW, :right),
            top_anchor    = Anchor(ROOT_WINDOW, :top)
        ),
    )

    c = w.widget_container

    p = create_panels!(
        c;
        columns = 3,
        lines = 3
    )

    # Label
    # ======================================================================================

    label = @tui_label(
        parent      = p.panels[1, 1],
        text        = "This is a label.",
        left_anchor = (:parent, :left),
        top_anchor  = (:parent, :top)
    )

    # ANSI Label
    # ======================================================================================

    ansi_label = @tui_ansi_label(
        parent      = p.panels[1, 2],
        text        = "\e[1mThis \e[34mis a color \e[47mlabel.",
        left_anchor = (:parent, :left),
        top_anchor  = (:parent, :top)
    )

    # Button
    # ======================================================================================

    function button_return_pressed(w; new_label, label_widget)
        change_text!(label_widget, new_label)
        return nothing
    end

    button_1 = @tui_button(
        parent      = p.panels[1, 3],
        style       = :simple,
        left_anchor = (:parent, :left),
        top_anchor  = (:parent, :top, 1),
    )

    button_2 = @tui_button(
        parent        = p.panels[1, 3],
        style         = :boxed,
        left_anchor   = (button_1, :right),
        middle_anchor = (button_1, :middle),
    )

    button_3 = @tui_button(
        parent        = p.panels[1, 3],
        style         = :none,
        left_anchor   = (button_2, :right),
        middle_anchor = (button_2, :middle),
    )

    button_information = @tui_label(
        parent       = p.panels[1, 3],
        text         = "",
        left_anchor  = (:parent, :left),
        right_anchor = (:parent, :right),
        top_anchor   = (button_1, :bottom, 3),
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
        parent      = p.panels[2, 1],
        style       = :simple,
        left_anchor = (:parent, :left),
        top_anchor  = (:parent, :top),
    )

    input_field_2 = @tui_input_field(
        parent      = p.panels[2, 1],
        style       = :boxed,
        left_anchor = (:parent, :left),
        top_anchor  = (input_field_1, :bottom)
    )

    input_field_3 = @tui_input_field(
        parent      = p.panels[2, 1],
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
        parent          = p.panels[2, 2],
        data            = ["Item #$i" for i in 1:10],
        number_of_lines = 5,
        left_anchor     = (:parent, :left),
        top_anchor      = (:parent, :top),
    )

    list_box_1_information = @tui_label(
        parent       = p.panels[2, 2],
        text         = "",
        left_anchor  = (:parent, :left),
        right_anchor = (:parent, :right),
        top_anchor   = (list_box_1, :bottom)
    )

    @connect(
        list_box_1,
        return_pressed,
        list_box_return_pressed,
        (; label_widget = list_box_1_information)
    )

    list_box_2 = @tui_list_box(
        parent             = p.panels[2, 2],
        border = true,
        data               = ["Item #$i" for i in 1:10],
        multiple_selection = true,
        number_of_lines    = 5,
        show_icon          = true,
        left_anchor        = (:parent, :left),
        top_anchor         = (list_box_1_information, :bottom),
    )

    list_box_2_information = @tui_label(
        parent       = p.panels[2, 2],
        text         = "",
        left_anchor  = (:parent, :left),
        right_anchor = (:parent, :right),
        top_anchor   = (list_box_2, :bottom)
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
        parent      = p.panels[2, 3],
        data        = ["Item #$i" for i in 1:10],
        left_anchor = (list_box_2, :left),
        top_anchor  = (:parent, :top),
    )

    combo_box_1_information = @tui_label(
        parent        = p.panels[2, 3],
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
        parent       = p.panels[3, 1],
        top_anchor   = (:parent, :top),
        left_anchor  = (:parent, :left),
        right_anchor = (:parent, :right)
    )

    hl2 = @tui_horizontal_line(
        parent       = p.panels[3, 1],
        pattern      = "+-",
        top_anchor   = (hl1, :bottom),
        left_anchor  = (:parent, :left),
        right_anchor = (:parent, :right)
    )

    # Progress Bar
    # ======================================================================================

    pb = @tui_progress_bar(
        parent       = p.panels[3, 2],
        left_anchor  = (:parent, :left),
        right_anchor = (:parent, :right),
        top_anchor   = (:parent, :top),
        value        = 0,
        show_value   = true,
        theme        = Theme(default = ncurses_color(:green, 246))
    )

    # Raw Buffer
    # ======================================================================================

    function raw_buffer_draw!(rb::WidgetRawBuffer, buffer)
        height = rb.height
        width  = rb.width

        # Top line.
        NCurses.waddch(buffer, NCurses.ACS_(:ULCORNER))

        for j in 2:(width - 1)
            NCurses.waddch(buffer, NCurses.ACS_(:HLINE))
        end

        NCurses.waddch(buffer, NCurses.ACS_(:URCORNER))

        # Intermidiate borders.
        for i in 2:(height - 1)
            NCurses.mvwaddch(buffer, i - 1, 0,         NCurses.ACS_(:VLINE))
            NCurses.mvwaddch(buffer, i - 1, width - 1, NCurses.ACS_(:VLINE))
        end

        # Bottom line.
        NCurses.waddch(buffer, NCurses.ACS_(:LLCORNER))

        for j in 2:(width - 1)
            NCurses.waddch(buffer, NCurses.ACS_(:HLINE))
        end

        NCurses.waddch(buffer, NCurses.ACS_(:LRCORNER))
    end

    rb = @tui_raw_buffer(
        parent       = p.panels[3, 3],
        draw!        = raw_buffer_draw!,
        top_anchor   = (:parent, :top),
        left_anchor  = (:parent, :left),
        right_anchor = (:parent, :right),
        height       = 3
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

panels()
