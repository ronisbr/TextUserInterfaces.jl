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
    ~    = create_widget(Val{:label}, win;
                         top = :top, left = :left, height = 1, width = 40,
                         text = "This is a label", color = p0)
    bt   = create_widget(Val{:button}, win;
                         top = :center, left = :center, width = 12,
                         label = "Button 1", color = p0, color_highlight = p1)
    pb   = create_widget(Val{:progress_bar}, win;
                         top = :bottom, left = :right, width = 40, value = 100)

    # Focus manager.
    tui.focus_chain = [win]
    init_focus_manager()

    # Initial painting.
    refresh_all_windows()
    update_panels()
    doupdate()
    destroy_tui()
end
