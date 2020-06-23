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

    for title in (" WINDOW 1 ", " WINDOW 2 ", " WINDOW 3 ")
        w,c  = create_window_with_container(newopc(top = x,
                                                   left = y,
                                                   height = 10,
                                                   width = 56),
                                            border = true,
                                            title = title)
        l    = create_widget(Val(:label), c,
                             newopc(top = 2,
                                    left = 2,
                                    height = 1),
                             text = "The last pressed button was:", color = p0)
        text = create_widget(Val(:label), c,
                             newopc(anchor_middle = Anchor(l, :middle, 0),
                                    anchor_left   = Anchor(l, :right,  1),
                                    width         = 10);
                             text = "", color = p2)
        bt1  = create_widget(Val(:button), c,
                             newopc(top = 5,
                                    anchor_left = Anchor(c, :left, 0));
                             label = "Button 1", color = p1,
                             color_highlight = p3, style = :simple)
        bt2  = create_widget(Val(:button), c,
                             newopc(anchor_middle = Anchor(bt1, :middle, 0),
                                    anchor_center = Anchor(c, :center, 0));
                             label = "Button 2", color = p1,
                             color_highlight = p3, style = :boxed)
        bt3  = create_widget(Val(:button), c,
                             newopc(anchor_middle = Anchor(bt2, :middle, 0),
                                    anchor_right =  Anchor(c, :right, 0)),
                             label = "Button 3", color = p1,
                             color_highlight = p3, style = :none)

        @connect_signal bt1 return_pressed change_text(text,"Button 1")
        @connect_signal bt2 return_pressed change_text(text,"Button 2")
        @connect_signal bt3 return_pressed change_text(text,"Button 3")

        push!(wins, w)

        x += Δx
        y += Δy
    end

    # Keys to change windows.
    set_next_window_func((k)->k.ktype == :F2)
    set_previous_window_func((k)->k.ktype == :F3)

    # Focus manager.
    tui.focus_chain = wins
    init_focus_manager()

    # Initial painting.
    refresh_all_windows()
    NCurses.update_panels()
    NCurses.doupdate()

    k = jlgetch()

    while k.ktype != :F1
        process_focus(k)
        k = jlgetch()
    end

    destroy_tui()
end

windows_and_widgets()
