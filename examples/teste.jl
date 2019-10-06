using TextUserInterfaces

function teste()
    init_tui()
    noecho()
    nodelay(tui.stdscr,true)

    init_color(:light_blue, 700, 700, 1000)
    p0 = ncurses_color(bold = false)
    p1 = ncurses_color(bold = true, underline = true)
    p2 = ncurses_color(:yellow, :black)
    p3 = ncurses_color(:black, :white)

    win1  = create_window(20,60,5,5; border = false, title = " WIN 1 ")
    text1 = create_widget(Val{:label}, win1, 2,2, 3, 40, " Initial: ")
    win2  = create_window(20,60,5,5; border = true, title = " WIN 2 ")
    text2 = create_widget(Val{:label}, win2, 2,2, 10, 40, "Esse é fixo")
    pb1   = create_widget(Val{:progress_bar}, win2, 10, 2, 40, 0; style = :complete)
    bt1   = create_widget(Val{:button}, win2, 8, 3, 40, "Button", p1, p3)

    p = [p0,p1,p2,p3]

    refresh_all_windows()
    update_panels()
    doupdate()

    k = jlgetch()

    i = 1
    quit = false

    x = 0

    @async begin
        k = jlgetch()

        while k.ktype != :F1
            if k.ktype == :F2
                move_window_to_top(win1)
            elseif k.ktype == :F3
                move_window_to_top(win2)
            elseif k.ktype == :F4
                destroy_window(win2)
            elseif k.ktype == :F5
                accept_focus(bt1)
            elseif k.ktype == :F6
                release_focus(bt1)
            elseif k.value == "l"
                x += 1
                move_window(win2, 5, 5+x)
            elseif k.value == "k"
                x -= 1
                move_window(win2, 5, 5+x)
            elseif k.value != "ERR"
                change_text(text1, "Teste", color = p[i])
                i += 1
                i > 4 && (i = 1)
            end

            if k.value != "ERR"
                refresh_all_windows()
                update_panels()
                doupdate()
            end

            k = jlgetch()
            yield()
        end

        quit = true
    end

    v = 0
    while !quit
        v += 1
        change_value(pb1, v)
        refresh_all_windows()
        update_panels()
        doupdate()
        yield()
        sleep(1)
    end

    destroy_tui()
end

teste()
