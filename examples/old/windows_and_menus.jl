using TextUserInterfaces

# Initialize the Text User Interface.
tui = init_tui()

# Do not echo the typed characters and do no show the cursor.
noecho()
curs_set(0)

# Initialize the colors that will be used.
init_color(:light_blue, 700, 700, 1000)
p0 = ncurses_color(bold = true)
p1 = ncurses_color(:yellow,     :black)
p2 = ncurses_color(:green,      :black)
p3 = ncurses_color(:blue,       :black)
p4 = ncurses_color(:light_blue, :black)

# Create the side window that will contain the menu.
win_menu = create_window(LINES()-4, 20, 0, 0; border = true, title = " Menu ",
                         title_color = p0)

# Create the bottom window with the instructions.
win_inst = create_window(4, COLS(), LINES()-4, 0; border = false)

# Write the instructions in `bold`.
set_color(win_inst,ncurses_color(bold = true))
window_println(win_inst, """
Press ENTER to move the panel to top.
Press X to hide/show the panel.
Press F1 to exit.
""")
unset_color(win_inst,ncurses_color(bold = true))

# Create the windows and panels.
win1 = create_window(10, 40, 0, 22; has_buffer = true, border = true,
                     title = " Panel 1 ", title_color = p2, border_color = p1)
win2 = create_window(10, 40, 3, 32; border = true, title = " Panel 2 ",
                     title_color = p2, border_color = p1)
win3 = create_window(10, 40, 6, 42; border = true, title = " Panel 3 ",
                     title_color = p2, border_color = p1)
win4 = create_window(10, 40, 9, 52; has_buffer = true, border = true,
                     title = " Panel 4 ", title_color = p2, border_color = p1)

# Add text to the windows.
set_color(win1, p4)
window_println(win1, 0, "Text with multiple lines\nwith center alignment";
               alignment = :c, pad = 0)
unset_color(win1,p4)

set_color(win2, p4)
window_println(win2, 0, "Text with multiple lines\nwith left alignment";
               alignment = :l, pad = 1)
unset_color(win2,p4)

set_color(win3, p4)
window_println(win3, 0, "Text with multiple lines\nwith right alignment";
               alignment = :r, pad = 1)
unset_color(win3,p4)

set_color(win4, p4)
window_println(win4, 0, "Line with right alignment";  alignment = :r, pad = 1)
window_println(win4,    "Line with center alignment"; alignment = :c, pad = 0)
window_println(win4,    "Line with left alignment";   alignment = :l, pad = 1)
unset_color(win4,p4)

# Create the menu.
menu = create_menu(["Panel 1", "Panel 2", "Panel 3", "Panel 4"])
set_menu_win(menu,win_menu)

menu.on_return_pressed = (menu)->begin
    item_name = current_item_name(menu)

    idx = 0
    if item_name == "Panel 1"
        idx = 1
    elseif item_name == "Panel 2"
        idx = 2
    elseif item_name == "Panel 3"
        idx = 3
    elseif item_name == "Panel 4"
        idx = 4
    end

    idx == 0 && return

    if ch == 10
        !hidden_wins[idx] && move_window_to_top(wins[idx])
    else
        if hidden_wins[idx]
            show_window(wins[idx])
            hidden_wins[idx] = false
        else
            hide_window(wins[idx])
            hidden_wins[idx] = true
        end
    end
end

# List of windows.
wins = [win1; win2; win3; win4]

# Refresh all the windows.
refresh_all_windows()
update_panels()
doupdate()

# Store which windows are hidden.
hidden_wins = [false; false; false; false]

# Wait for a key and process.
ch,k = jlgetch()

while k.ktype != :F1
    global ch,k

    if !menu_driver(menu, k)
        if k.value == "x"
            item_name = current_item_name(menu)

            idx = 0

            if item_name == "Panel 1"
                idx = 1
            elseif item_name == "Panel 2"
                idx = 2
            elseif item_name == "Panel 3"
                idx = 3
            elseif item_name == "Panel 4"
                idx = 4
            end

            idx == 0 && continue

            if hidden_wins[idx]
                show_window(wins[idx])
                hidden_wins[idx] = false
            else
                hide_window(wins[idx])
                hidden_wins[idx] = true
            end
        end
    end

    refresh_all_windows()
    update_panels()
    doupdate()

    ch,k = jlgetch()
end

destroy_menu(menu)
destroy_tui()
