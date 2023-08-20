using TextUserInterfaces

# Function to handle a return presse when a button is in focus.
function button_return_pressed(w; new_label, label_widget)
    change_text!(label_widget, new_label)
end

# Functions to management special keystrokes in the TUI.
function keystroke_management(tui; keystroke)
    if keystroke.ktype == :F2
        move_focus_to_next_window()
    elseif keystroke.ktype == :F3
        move_focus_to_previous_window()
    end
end

# Initialize TUI, create the widgets, and start the application main loop.
function windows_and_widgets()
    initialize_tui()

    logger.enabled = true
    logger.level = DEBUG

    # Create windows.
    wins = Window[]

    x  = 2
    y  = 2
    Δx = 5
    Δy = 15

    # Connect our keystroke management function to the keypress event in TUI.
    @connect(tui, keypressed, keystroke_management)

    # Create the three windows:
    for title in (" WINDOW 1 ", " WINDOW 2 ", " WINDOW 3 ")
        w = create_window(
            layout = ObjectLayout(top = x, left = y, height = 10, width = 56),
            border = true,
            title = title
        )

        c = w.widget_container

        l = @tui_label(
            parent = c,
            height = 1,
            left = 2,
            top = 2,
            text = "The last pressed button was:"
        )

        text = @tui_label(
            parent = c,
            middle_anchor = (l, :middle),
            left_anchor   = (l, :right, 1),
            width = 10,
            text = "",
            theme = Theme(default = ncurses_color(:yellow, :black))
        )

        bt1  = @tui_button(
            parent = c,
            top = 5,
            left_anchor = (c, :left),
            label = "Button 1",
            style = :simple,
            signal = (
                return_pressed,
                button_return_pressed,
                (label_widget = text, new_label = "Button 1")
            )
        )

        bt2  = @tui_button(
            parent = c,
            middle_anchor = (bt1, :middle),
            center_anchor = (c,   :center),
            label = "Button 2",
            style = :boxed,
            signal = (
                return_pressed,
                button_return_pressed,
                (label_widget = text, new_label = "Button 2")
            )
        )

        bt3  = @tui_button(
            parent = c,
            middle_anchor = (bt2, :middle),
            right_anchor  = (c,   :right),
            label = "Button 3",
            style = :none,
            signal = (
                return_pressed,
                button_return_pressed,
                (label_widget = text, new_label = "Button 3")
            )
        )

        push!(wins, w)

        x += Δx
        y += Δy
    end

    # Refocus the windows to organize them when the software is loaded.
    move_focus_to_window(wins[3])
    move_focus_to_window(wins[2])
    move_focus_to_window(wins[1])

    # Bottom window to show information.
    bw = create_window(;
        border    = true,
        theme     = Theme(border = ncurses_color(243, :black)),
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
        text          = cy * "F1" * cr * " : Quit" * sep *
                        cy * "F2" * cr * " : Move to the next window" * sep *
                        cy * "F3" * cr * " : Move to the previous window"
    )

    app_main_loop()
end

windows_and_widgets()
