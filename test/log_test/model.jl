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

    opc = ObjectLayout(top = 2, left = 2, width = 56, height = 10)
    w,c = create_window_with_container(opc; border = true, title = " WINDOW ")

    opc = ObjectLayout(
        anchor_top  = Anchor(c, :top, 0),
        anchor_left = Anchor(c, :left, 0),
        height = 1,
        width  = 40
    )
    ~   = create_widget(Val(:label), c, opc; text = "This is a label", color = p0)

    opc = ObjectLayout(
        anchor_middle = Anchor(c, :middle, 0),
        anchor_left   = Anchor(c, :left, 0),
        width = 12
    )

    bt = create_widget(
        Val(:button),
        c,
        opc;
        label = "Button 1",
        color = p0,
        color_highlight = p1
    )

    opc = ObjectLayout(
        anchor_bottom = Anchor(c, :bottom, 0),
        anchor_left   = Anchor(c, :left, 0),
        width = 40
    )

    pb = create_widget(Val(:progress_bar), c, opc; value = 100)

    # Focus manager.
    tui.focus_chain = [w]
    init_focus_manager()

    # Initial painting.
    refresh_all_windows()
    NCurses.update_panels()
    NCurses.doupdate()
    destroy_tui()
end
