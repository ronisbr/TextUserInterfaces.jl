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

    button_key_pressed(w,k,l,t) = k.ktype == :enter && change_text(l,t)

    for title in (" WINDOW 1 ", " WINDOW 2 ", " WINDOW 3 ")
        w,c  = create_window_with_container(newopc(top = x,
                                                   left = y,
                                                   height = 10,
                                                   width = 56),
                                            border = true,
                                            title = title)

        l = create_widget(Val(:label),
                          newopc(top = 2,
                                 left = 2,
                                 height = 1),
                          text = "The last pressed button was:", color = p0)
        add_widget!(c, l)

        text = create_widget(Val(:label),
                             newopc(anchor_middle = Anchor(l, :middle, 0),
                                    anchor_left   = Anchor(l, :right,  1),
                                    width         = 10);
                             text = "", color = p2)
        add_widget!(c, text)

        bt1  = create_widget(Val(:button),
                             newopc(top = 5,
                                    anchor_left = Anchor(c, :left, 0));
                             label = "Button 1", color = p1,
                             color_highlight = p3, style = :simple)
        add_widget!(c, bt1)

        bt2  = create_widget(Val(:button),
                             newopc(anchor_middle = Anchor(bt1, :middle, 0),
                                    anchor_center = Anchor(c, :center, 0));
                             label = "Button 2", color = p1,
                             color_highlight = p3, style = :boxed)
        add_widget!(c, bt2)

        bt3  = create_widget(Val(:button),
                             newopc(anchor_middle = Anchor(bt2, :middle, 0),
                                    anchor_right =  Anchor(c, :right, 0)),
                             label = "Button 3", color = p1,
                             color_highlight = p3, style = :none)
        add_widget!(c, bt3)

        @connect_signal bt1 key_pressed button_key_pressed text "Button 1"
        @connect_signal bt2 key_pressed button_key_pressed text "Button 2"
        @connect_signal bt3 key_pressed button_key_pressed text "Button 3"

        push!(wins, w)

        x += Δx
        y += Δy
    end

    app_main_loop()
end

windows_and_widgets()
