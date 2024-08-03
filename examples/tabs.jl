using TextUserInterfaces

# Create a set of tabs.
function tabs()
    initialize_tui()

    logger.enabled = true
    logger.level = DEBUG

    w = create_window(
        border = true,
        theme  = create_theme(border = ncurses_color(243, :black)),
        title  = " Tabs ",
        layout = ObjectLayout(
            bottom_anchor = Anchor(ROOT_WINDOW, :bottom, -3),
            left_anchor   = Anchor(ROOT_WINDOW, :left),
            right_anchor  = Anchor(ROOT_WINDOW, :right),
            top_anchor    = Anchor(ROOT_WINDOW, :top)
        ),
    )

    c = w.widget_container

    # == Create Tabs =======================================================================

    t = create_tabs!(
        c;
        border = true,
        num_tabs = 3,
        theme  = create_theme(border = ncurses_color(243, :black))
    )

    # -- Tab 1 -----------------------------------------------------------------------------

    function button_return_pressed(w; new_label, label_widget)
        change_text!(label_widget, new_label)
        return nothing
    end

    button_1 = @tui_button(
        parent      = t.tabs[1],
        style       = :simple,
        left_anchor = (:parent, :left),
        top_anchor  = (:parent, :top, 1),
    )

    button_2 = @tui_button(
        parent      = t.tabs[1],
        style         = :boxed,
        left_anchor   = (button_1, :right),
        middle_anchor = (button_1, :middle),
    )

    button_3 = @tui_button(
        parent        = t.tabs[1],
        style         = :none,
        left_anchor   = (button_2, :right),
        middle_anchor = (button_2, :middle),
    )

    button_information = @tui_label(
        parent       = t.tabs[1],
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

    # -- Tab 2 -----------------------------------------------------------------------------

    ansi_label = @tui_ansi_label(
        parent      = t.tabs[2],
        text        = "\e[1mThis \e[34mis a color \e[47mlabel\e[0m in Tab 2.",
        left_anchor = (:parent, :left),
        top_anchor  = (:parent, :top)
    )

    # -- Tab 3 -----------------------------------------------------------------------------

    function combo_box_item_changed(w; label_widget)
        current_item = get_item(w)
        str = "Current item: $(current_item)."
        change_text!(label_widget, str)
        return nothing
    end

    combo_box_1 = @tui_combo_box(
        parent      = t.tabs[3],
        data        = ["Item #$i" for i in 1:10],
        left_anchor = (:parent, :left),
        top_anchor  = (:parent, :top),
    )

    combo_box_1_information = @tui_label(
        parent        = t.tabs[3],
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

    # == Bottom Window =====================================================================

    # Bottom window to show information.
    bw = create_window(;
        border    = true,
        theme     = create_theme(border = ncurses_color(243, :black)),
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
        text          = cy * "ALT + 1" * cr * " : Tab 1  " * cg * "|" * cr * " " *
                        cy * "ALT + 2" * cr * " : Tab 2  " * cg * "|" * cr * " " *
                        cy * "ALT + 3" * cr * " : Tab 3  " * cg * "|" * cr * " " *
                        cy * "F1" * cr * " : Quit"
    )

    # == Signals ===========================================================================

    # Function to handle keystrokes.
    function handle_keystroke(tui; keystroke, kwargs...)
        if keystroke.alt
            @set_signal_property(tui, keypressed, block, true)
        else
            @delete_signal_property(tui, keypressed, block)
        end

        if keystroke.value == "\e1"
            change_tab!(t, 1)
        elseif keystroke.value == "\e2"
            change_tab!(t, 2)
        elseif keystroke.value == "\e3"
            change_tab!(t, 3)
        end
    end

    @connect tui keypressed handle_keystroke

    app_main_loop()
end

tabs()
