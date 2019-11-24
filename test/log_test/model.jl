using TextUserInterfaces

function log_test()
    TextUserInterfaces._test_hide_address[1] = true
    logger.enabled = true
    logger.level = 3
    logger.timestamp = false

    init_tui()
    NCurses.noecho()

    p0 = ncurses_color(bold = false)
    p1 = ncurses_color(:black, :white)

    win  = create_window(10,56,2,2; border = true, title = " WINDOW ")
    con  = create_widget(Val{:container}, win)
    ~    = create_widget(Val{:label}, con;
                         anchor_top = (con, :top, 0),   height = 1,
                         anchor_left = (con, :left, 0), width  = 40,
                         text = "This is a label", color = p0)
    bt   = create_widget(Val{:button}, con;
                         anchor_middle = (con, :middle, 0),
                         anchor_left = (con, :left, 0), width = 12,
                         label = "Button 1", color = p0, color_highlight = p1)
    pb   = create_widget(Val{:progress_bar}, con;
                         anchor_bottom = (con, :bottom, 0), width = 40,
                         anchor_left = (con, :left, 0), value = 100)

    # Focus manager.
    tui.focus_chain = [w]
    init_focus_manager()

    # Initial painting.
    refresh_all_windows()
    NCurses.update_panels()
    NCurses.doupdate()
    destroy_tui()
end
