using TextUserInterfaces

function windows_and_widgets()

    init_tui()
    noecho()

    init_color(:light_blue, 700, 700, 1000)
    p0 = ncurses_color(bold = false)
    p1 = ncurses_color(bold = true, underline = true)
    p2 = ncurses_color(:yellow, :black)
    p3 = ncurses_color(:black, :white)

    # Create windows.
    wins = Window[]

    x  = 2
    y  = 2
    Δx = 5
    Δy = 15

    for title in (" WINDOW 1 ", " WINDOW 2 ", " WINDOW 3 ")
        win  = create_window(10,56,x,y; border = true, title = title)
        ~    = create_widget(Val{:label},  win,  1,  1,  1, 40, "The last pressed button was:"; color = p0)
        text = create_widget(Val{:label},  win,  1, 30,  1, 10, ""; color = p2)
        bt1  = create_widget(Val{:button}, win,  4,  1, 12, "Button 1", p1, p3)
        bt2  = create_widget(Val{:button}, win,  4, 14, 12, "Button 2", p1, p3)
        bt3  = create_widget(Val{:button}, win,  4, 27, 12, "Button 3", p1, p3)
        bt4  = create_widget(Val{:button}, win,  4, 41, 12, "Button 4", p1, p3)

        bt1.on_return_pressed = (text)->change_text(text,"Button 1")
        bt1.vargs_on_return_pressed = (text,)
        bt2.on_return_pressed = (text)->change_text(text,"Button 2")
        bt2.vargs_on_return_pressed = (text,)
        bt3.on_return_pressed = (text)->change_text(text,"Button 3")
        bt3.vargs_on_return_pressed = (text,)
        bt4.on_return_pressed = (text)->change_text(text,"Button 4")
        bt4.vargs_on_return_pressed = (text,)

        push!(wins, win)

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
    update_panels()
    doupdate()

    k = jlgetch()

    while k.ktype != :F1
        process_focus(k)
        k = jlgetch()
    end

    destroy_tui()
end

windows_and_widgets()
