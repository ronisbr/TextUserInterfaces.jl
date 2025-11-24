using TextUserInterfaces

# Initialize TUI, create the widgets, and start the application main loop.
function all_widgets()
    initialize_tui()

    logger.enabled = true
    logger.level = DEBUG

    w = create_window(
        border = true,
        theme  = create_theme(border = ncurses_color(243, :black)),
        title  = " All Widgets ",
        layout = ObjectLayout(
            bottom_anchor = Anchor(ROOT_WINDOW, :bottom, -3),
            left_anchor   = Anchor(ROOT_WINDOW, :left),
            right_anchor  = Anchor(ROOT_WINDOW, :right),
            top_anchor    = Anchor(ROOT_WINDOW, :top)
        ),
    )

    c = w.widget_container

    @tui_builder begin

        # == Label =========================================================================

        @tui_label(
            parent      = c,
            label       = "This is a label.",
            left_anchor = (:parent, :left),
            top_anchor  = (:parent, :top)
        )

        @tui_label(
            parent       = c,
            label        = "This is a label with color but using `fill = false`.",
            fill         = false,
            theme        = create_theme(default = ncurses_color(:black, :blue)),
            left_anchor  = (:parent, :left),
            right_anchor = (:parent, :right),
            top_anchor   = (__LAST__, :bottom)
        )

        @tui_label(
            parent       = c,
            label        = "This is a label with color but using `fill = true`.",
            fill         = true,
            theme        = create_theme(default = ncurses_color(:black, :magenta)),
            left_anchor  = (:parent, :left),
            right_anchor = (:parent, :right),
            top_anchor   = (__LAST__, :bottom)
        )

        # == Text ==========================================================================

        @tui_text(
            parent       = c,
            text         = "This is a text\nthat can have\nmultiple lines.",
            left_anchor  = (:parent, :left),
            right_anchor = (:parent, :right),
            top_anchor   = (__LAST__, :bottom)
        )

        @tui_text(
            parent       = c,
            alignment    = :c,
            fill         = true,
            text         = "This is a text\nthat can have\nmultiple lines.",
            theme        = create_theme(default = ncurses_color(:black, :blue)),
            left_anchor  = (:parent, :left),
            right_anchor = (:parent, :right),
            top_anchor   = (__LAST__, :bottom)
        )

        @tui_text(
            parent       = c,
            alignment    = :r,
            fill         = true,
            theme        = create_theme(default = ncurses_color(:black, :magenta)),
            text         = "This is a text\nthat can have\nmultiple lines.",
            left_anchor  = (:parent, :left),
            right_anchor = (:parent, :right),
            top_anchor   = (__LAST__, :bottom),
        )

        # == ANSI Label ====================================================================

        @tui_ansi_label(
            parent      = c,
            text        = "\e[1mThis \e[34mis a\ncolor \e[47mlabel with\nmul\e[0mtiple lines.",
            left_anchor = (:parent, :left),
            top_anchor  = (__LAST__, :bottom)
        )

        # == Button ========================================================================

        function button_return_pressed(w; new_label, label_widget)
            change_label!(label_widget, new_label)
            return nothing
        end

        button_1 = @tui_button(
            parent      = c,
            style       = :simple,
            left_anchor = (:parent, :left),
            top_anchor  = (__LAST__, :bottom, 1),
        )

        button_2 = @tui_button(
            parent        = c,
            style         = :boxed,
            left_anchor   = (__LAST__, :right),
            middle_anchor = (__LAST__, :middle),
        )

        button_3 = @tui_button(
            parent        = c,
            style         = :none,
            left_anchor   = (__LAST__, :right),
            middle_anchor = (__LAST__, :middle),
        )

        button_information = @tui_label(
            parent        = c,
            label         = "",
            left_anchor   = (__LAST__, :right, 2),
            right_anchor  = (:parent, :right),
            middle_anchor = (__LAST__, :middle),
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

        # == Input Fields ==================================================================

        @tui_input_field(
            parent      = c,
            style       = :simple,
            left_anchor = (:parent, :left),
            top_anchor  = (__LAST2__, :bottom)
        )

        @tui_input_field(
            parent      = c,
            style       = :boxed,
            left_anchor = (:parent, :left),
            top_anchor  = (__LAST__, :bottom)
        )

        @tui_input_field(
            parent      = c,
            style       = :none,
            left_anchor = (:parent, :left),
            top_anchor  = (__LAST__, :bottom)
        )

        # == List Box ======================================================================

        function list_box_return_pressed(w; label_widget)
            current_item   = get_current_item(w)
            selected_items = get_selected_items(w)
            str = "Current item: $(current_item), Selected items: $(selected_items)."
            change_label!(label_widget, str)
            return nothing
        end

        clb = @tui_container(
            parent       = c,
            border       = true,
            border_style = :rounded,
            title        = " List Box ",
            left_anchor  = (:parent, :left),
            top_anchor   = (__LAST__, :bottom),
            height       = 7,
            width        = 15,
        )

        @tui_list_box(
            parent           = clb,
            data             = ["Item #$i" for i in 1:10],
            show_cursor_icon = false,
            bottom_anchor    = (:parent, :bottom),
            left_anchor      = (:parent, :left),
            right_anchor     = (:parent, :right),
            top_anchor       = (:parent, :top),
        )

        @tui_label(
            parent        = c,
            label         = "",
            left_anchor   = (__LAST1__, :right, 2),
            right_anchor  = (:parent, :right),
            middle_anchor = (__LAST1__, :middle)
        )

        @connect(
            __LAST1__,
            return_pressed,
            list_box_return_pressed,
            (; label_widget = __LAST__)
        )

        @tui_list_box(
            parent             = c,
            data               = ["Item #$i" for i in 1:10],
            multiple_selection = true,
            number_of_lines    = 5,
            show_icon          = true,
            left_anchor        = (__LAST2__, :left),
            top_anchor         = (__LAST2__, :bottom),
        )

        @tui_label(
            parent        = c,
            label         = "",
            left_anchor   = (__LAST__, :right, 2),
            right_anchor  = (:parent, :right),
            middle_anchor = (__LAST__, :middle)
        )

        @connect(
            __LAST1__,
            return_pressed,
            list_box_return_pressed,
            (; label_widget = __LAST__)
        )

        # == Combo Box =====================================================================

        function combo_box_item_changed(w; label_widget)
            current_item = get_item(w)
            str = "Current item: $(current_item)."
            change_label!(label_widget, str)
            return nothing
        end

        list_box_theme = create_theme(;
            default   = ncurses_color(:white, 240),
            highlight = ncurses_color(:white, 240; reversed = true),
            selected  = ncurses_color(:yellow, 240),
        )

        @tui_combo_box(
            parent         = c,
            data           = ["Item #$i" for i in 1:10],
            list_box_theme = list_box_theme,
            left_anchor    = (__LAST1__, :left),
            top_anchor     = (__LAST1__, :bottom),
        )

        @tui_label(
            parent        = c,
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

        # == Horizontal Line ===============================================================

        @tui_horizontal_line(
            parent       = c,
            left_anchor  = (:parent, :left),
            right_anchor = (:parent, :right),
            top_anchor   = (__LAST1__, :bottom),
        )

        @tui_horizontal_line(
            parent       = c,
            pattern      = "+-",
            left_anchor  = (:parent, :left),
            right_anchor = (:parent, :right),
            top_anchor   = (__LAST__, :bottom),
        )

        # == Progress Bar ==================================================================

        cpb = @tui_container(
            parent       = c,
            border       = true,
            border_style = :rounded,
            title        = " Progress Bar ",
            left_anchor  = (:parent, :left),
            right_anchor = (:parent, :right),
            top_anchor   = (__LAST__, :bottom),
            height       = 6,
        )

        @tui_progress_bar(
            parent          = cpb,
            left_anchor     = (:parent, :left),
            right_anchor    = (:parent, :right),
            top_anchor      = (:parent, :top),
        )

        @tui_progress_bar(
            parent          = cpb,
            show_value      = true,
            style           = :line,
            left_anchor     = (:parent, :left),
            right_anchor    = (:parent, :right),
            top_anchor      = (__LAST__, :bottom),
        )

        @tui_progress_bar(
            parent          = cpb,
            show_value      = true,
            left_anchor     = (:parent, :left),
            right_anchor    = (:parent, :right),
            top_anchor      = (__LAST__, :bottom),
        )

        @tui_progress_bar(
            parent          = cpb,
            show_value      = false,
            style           = :line,
            left_anchor     = (:parent, :left),
            right_anchor    = (:parent, :right),
            top_anchor      = (__LAST__, :bottom),
        )

        # Function to handle keystrokes related to the progress bar.
        function handle_keystroke(tui; keystroke, kwargs...)
            if keystroke.value == "+"
                set_value!(__LAST3__, __LAST3__.value + 1)
                set_value!(__LAST2__, __LAST2__.value + 1)
                set_value!(__LAST1__, __LAST1__.value + 1)
                set_value!(__LAST__,  __LAST__.value  + 1)
            elseif keystroke.value == "-"
                set_value!(__LAST3__, __LAST3__.value - 1)
                set_value!(__LAST2__, __LAST2__.value - 1)
                set_value!(__LAST1__, __LAST1__.value - 1)
                set_value!(__LAST__,  __LAST__.value  - 1)
            end
        end

        @connect tui keypressed handle_keystroke

        # == Display Matrix ================================================================

        @tui_display_matrix(
            parent       = c,
            matrix       = rand(10, 10) * 1e4,
            left_anchor  = (:parent, :left),
            right_anchor = (:parent, :right),
            top_anchor   = (__LAST4__, :bottom),
        )

        @connect(
            tui,
            keypressed,
            (tui; keystroke) -> begin
                if keystroke.value == "j"
                    change_matrix!(__LAST__, rand(Int, 10, 10))
                end
            end
        )

        # == Raw Buffer ====================================================================

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

        @tui_raw_buffer(
            parent       = c,
            draw!        = raw_buffer_draw!,
            height       = 3,
            left_anchor  = (:parent, :left),
            right_anchor = (:parent, :right),
            top_anchor   = (__LAST__, :bottom),
        )
    end

    # == Bottom Window =================================================================

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
        text          = cy * "[F1 | Alt + q]" * cr * " : Quit"
    )

    # == Signals ===========================================================================

    app_main_loop(; exit_keys = [:F1, "\eq"])
end

all_widgets()
