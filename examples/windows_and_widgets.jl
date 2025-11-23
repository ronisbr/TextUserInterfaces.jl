using TextUserInterfaces

# Function to handle a return presse when a button is in focus.
function button_return_pressed(w; new_label, label_widget)
    change_label!(label_widget, new_label)
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
    for (title, title_alignment, border_style) in (
        (" WINDOW 1 ", :l, :default),
        (" WINDOW 2 ", :c, :rounded),
        (" WINDOW 3 ", :r, :heavy)
    )
        @tui_builder begin
            w = create_window(
                layout          = ObjectLayout(top = x, left = y, height = 10, width = 56),
                border          = true,
                border_style    = border_style,
                title           = title,
                title_alignment = title_alignment
            )

            c = w.widget_container

            @tui_label(
                parent = c,
                label  = "The last pressed button was:",
                height = 1,
                left   = 2,
                top    = 2
            )

            @tui_label(
                parent        = c,
                label         = "",
                theme         = create_theme(default = ncurses_color(:yellow, :black)),
                middle_anchor = (__LAST__, :middle),
                left_anchor   = (__LAST__, :right, 1),
                width         = 10
            )

            @tui_button(
                parent      = c,
                label       = "Button 1",
                style       = :simple,
                top         = 5,
                left_anchor = (:parent, :left),
                signal      = (
                    return_pressed,
                    button_return_pressed,
                    (label_widget = __ID2__, new_label = "Button 1")
                )
            )

            @tui_button(
                parent        = c,
                label         = "Button 2",
                style         = :boxed,
                middle_anchor = (__LAST__, :middle),
                center_anchor = (:parent, :center),
                signal        = (
                    return_pressed,
                    button_return_pressed,
                    (label_widget = __ID2__, new_label = "Button 2")
                )
            )

            @tui_button(
                parent        = c,
                label         = "Button 3",
                style         = :none,
                middle_anchor = (__LAST__, :middle),
                right_anchor  = (:parent,  :right),
                signal        = (
                    return_pressed,
                    button_return_pressed,
                    (label_widget = __ID2__, new_label = "Button 3")
                )
            )
        end

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
        text          = cy * "[F1 | Alt + q]" * cr * " : Quit" * sep *
                        cy * "F2" * cr * " : Move to the next window" * sep *
                        cy * "F3" * cr * " : Move to the previous window"
    )

    app_main_loop(; exit_keys = [:F1, "\eq"])
end

windows_and_widgets()
