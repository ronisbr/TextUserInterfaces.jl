using TextUserInterfaces

# Create a set of tabs.
function tabs()
    initialize_tui()

    logger.enabled = true
    logger.level = DEBUG

    w = create_window(
        border = true,
        theme  = Theme(:border => ncurses_style(:grey42, :transparent)),
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
        theme  = Theme(:border => ncurses_style(:grey42, :transparent))
    )

    # -- Tab 1 -----------------------------------------------------------------------------

    @tui_builder begin
        function button_return_pressed(w; new_label, label_widget)
            change_label!(label_widget, new_label)
            return nothing
        end

        @tui_button(
            parent      = t.tabs[1],
            style       = :simple,
            left_anchor = (:parent, :left),
            top_anchor  = (:parent, :top, 1),
        )

        @tui_button(
            parent        = t.tabs[1],
            style         = :boxed,
            left_anchor   = (__LAST__, :right),
            middle_anchor = (__LAST__, :middle),
        )

        @tui_button(
            parent        = t.tabs[1],
            style         = :none,
            left_anchor   = (__LAST__, :right),
            middle_anchor = (__LAST__, :middle),
        )

        @tui_label(
            parent       = t.tabs[1],
            label        = "",
            left_anchor  = (:parent, :left),
            right_anchor = (:parent, :right),
            top_anchor   = (__LAST__, :bottom, 3),
        )

        @connect(
            __ID1__,
            return_pressed,
            button_return_pressed,
            (new_label = "Button #1 was pressed.", label_widget = __LAST__)
        )

        @connect(
            __ID2__,
            return_pressed,
            button_return_pressed,
            (new_label = "Button #2 was pressed.", label_widget = __LAST__)
        )

        @connect(
            __ID3__,
            return_pressed,
            button_return_pressed,
            (new_label = "Button #3 was pressed.", label_widget = __LAST__)
        )
    end

    # -- Tab 2 -----------------------------------------------------------------------------

    @tui_ansi_label(
        parent      = t.tabs[2],
        text        = "\e[1mThis \e[34mis a color \e[47mlabel\e[0m in Tab 2.",
        left_anchor = (:parent, :left),
        top_anchor  = (:parent, :top)
    )

    # -- Tab 3 -----------------------------------------------------------------------------

    @tui_builder begin
        function combo_box_item_changed(w; label_widget)
            current_item = get_item(w)
            str = "Current item: $(current_item)."
            change_label!(label_widget, str)
            return nothing
        end

        @tui_combo_box(
            parent      = t.tabs[3],
            data        = ["Item #$i" for i in 1:10],
            left_anchor = (:parent, :left),
            top_anchor  = (:parent, :top),
        )

        @tui_label(
            parent        = t.tabs[3],
            label         = "",
            left_anchor   = (__LAST__, :right, 2),
            right_anchor  = (:parent, :right),
            middle_anchor = (__LAST__, :middle)
        )

        @connect(
            __LAST1__,
            item_changed,
            combo_box_item_changed,
            (; label_widget = __LAST__)
        )
    end

    # == Bottom Window =====================================================================

    # Bottom window to show information.
    bw = create_window(;
        border    = true,
        theme     = Theme(:border => ncurses_style(:grey42, :transparent)),
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
        text          = cy * "Alt + 1" * cr * " : Tab 1  " * cg * "|" * cr * " " *
                        cy * "Alt + 2" * cr * " : Tab 2  " * cg * "|" * cr * " " *
                        cy * "Alt + 3" * cr * " : Tab 3  " * cg * "|" * cr * " " *
                        cy * "[F1 | Alt + q]" * cr * " : Quit"
    )

    # == Signals ===========================================================================

    # Function to handle keystrokes.
    function handle_keystroke(tui; keystroke, kwargs...)
        tab_changed = false

        if keystroke.value == "\e1"
            change_tab!(t, 1)
            tab_changed = true
        elseif keystroke.value == "\e2"
            change_tab!(t, 2)
            tab_changed = true
        elseif keystroke.value == "\e3"
            change_tab!(t, 3)
            tab_changed = true
        end

        if tab_changed
            @set_signal_property(tui, keypressed, block, true)
        else
            @delete_signal_property(tui, keypressed, block)
        end
    end

    @connect tui keypressed handle_keystroke

    app_main_loop(; exit_keys = [:F1, "\eq"])
end

tabs()
