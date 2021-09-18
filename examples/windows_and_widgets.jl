using TextUserInterfaces

logger.enabled = true
logger.level = 3

function windows_and_widgets()
    init_tui()
    NCurses.noecho()

    p0 = ncurses_color(bold = false)
    p1 = ncurses_color(bold = true)
    p2 = ncurses_color(:yellow, :black)
    p3 = ncurses_color(:black, :white)

    # Create windows.
    wins = Window[]

    x  = 2
    y  = 2
    Δx = 5
    Δy = 15

    function button_key_pressed(w, k, l, t)
        if k.ktype == :enter
            change_text(l,t)
            return true
        else
            process_keystroke(w, k)
        end
    end

    for title in (" WINDOW 1 ", " WINDOW 2 ", " WINDOW 3 ")
        w,c  = create_window_with_container(
            ObjectLayout(top = x, left = y, height = 10, width = 56),
            border = true,
            title = title
        )

        l = @tui_label(
            parent = c,
            height = 1,
            left = 2,
            top = 2,
            text = "The last pressed button was:",
            color = p0
        )

        text = @tui_label(
            parent = c,
            anchor_middle = (l, :middle, 0),
            anchor_left = (l, :right,  1),
            width = 10,
            color = p2,
            text = ""
        )

        bt1  = @tui_button(
            parent = c,
            top = 5,
            anchor_left = (c, :left, 0),
            color = p1,
            color_highlight = p3,
            label = "Button 1",
            style = :simple,
            signal = (key_pressed, button_key_pressed, text, "Button 1")
        )

        bt2  = @tui_button(
            parent = c,
            anchor_middle = (bt1, :middle, 0),
            anchor_center = (c, :center, 0),
            color = p1,
            color_highlight = p3,
            label = "Button 2",
            style = :boxed,
            signal = (key_pressed, button_key_pressed, text, "Button 2")
        )

        bt3  = @tui_button(
            parent = c,
            anchor_middle = (bt2, :middle, 0),
            anchor_right =  (c, :right, 0),
            color = p1,
            color_highlight = p3,
            label = "Button 3",
            style = :none,
            signal = (key_pressed, button_key_pressed, text, "Button 3")
        )

        push!(wins, w)

        x += Δx
        y += Δy
    end

    app_main_loop()
end

windows_and_widgets()
