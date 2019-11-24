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

    w,c = create_window_with_container(10,56,2,2; border = true, title = " WINDOW ")
    ~   = create_widget(Val{:label}, c;
                        anchor_top = (c, :top, 0),   height = 1,
                        anchor_left = (c, :left, 0), width  = 40,
                        text = "This is a label", color = p0)
    bt  = create_widget(Val{:button}, c;
                        anchor_middle = (c, :middle, 0),
                        anchor_left = (c, :left, 0), width = 12,
                        label = "Button 1", color = p0, color_highlight = p1)
    pb  = create_widget(Val{:progress_bar}, c;
                         anchor_bottom = (c, :bottom, 0), width = 40,
                         anchor_left = (c, :left, 0), value = 100)

    # Focus manager.
    tui.focus_chain = [w]
    init_focus_manager()

    # Initial painting.
    refresh_all_windows()
    NCurses.update_panels()
    NCurses.doupdate()
    destroy_tui()
end
