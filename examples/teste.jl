using TextUserInterfaces

function teste()
    init_tui()
    noecho()

    win1  = create_window(20,60,5,5; border = false, title = " WIN 1 ")
    text1 = create_widget(Val{:label}, win1, 2,2, 3, 40, " Initial: ")
    win2  = create_window(20,60,5,5; border = true, title = " WIN 2 ")
    text2 = create_widget(Val{:label}, win2, 2,2, 10, 40, "Esse é fixo")
    pb1   = create_widget(Val{:progress_bar}, win2, 10, 2, 40, 0; style = :complete)

    init_color(:light_blue, 700, 700, 1000)
    p0 = ncurses_color(bold = false)
    p1 = ncurses_color(bold = true, underline = true)
    p2 = ncurses_color(:yellow, :black)
    p3 = ncurses_color(:red, :black)

    p = [p0,p1,p2,p3]

    refresh_all_windows()
    update_panels()
    doupdate()

    ch, k = jlgetch()

    i = 1
    v = 0

    while k.ktype != :F1
        if k.ktype == :F2
            move_window_to_top(win1)
        elseif k.ktype == :F3
            move_window_to_top(win2)
        elseif k.ktype == :F4
            destroy_window(win2)
        else
            change_text(text1, "Teste", color = p[i])
            i += 1
            i > 4 && (i = 1)
            change_value(pb1, v)
            v += 1
        end

        refresh_all_windows()
        update_panels()
        doupdate()
        ch, k = jlgetch()
    end

    destroy_tui()
end

teste()
