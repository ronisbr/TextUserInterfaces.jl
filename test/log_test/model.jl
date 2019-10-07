using TextUserInterfaces

function log_test()
    init_tui()
    noecho()

    TextUserInterfaces._test_hide_address[1] = true
    logger.enabled = true
    logger.level = 3
    logger.timestamp = false

    p0 = ncurses_color(bold = false)
    p1 = ncurses_color(:black, :white)

    win  = create_window(10,56,2,2; border = true, title = " WINDOW ")
    ~    = create_widget(Val{:label},  win,  1,  1,  1, 40, "This is a label"; color = p0)
    bt   = create_widget(Val{:button}, win,  2,  1, 12, "Button 1", p0, p1)
    pb   = create_widget(Val{:progress_bar}, win, 3, 1, 40, 30)

    # Focus manager.
    tui.focus_chain = [win]
    init_focus_manager()

    # Initial painting.
    refresh_all_windows()
    update_panels()
    doupdate()
    destroy_tui()
end
