#==# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains functions to manage windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #==#

export hide_window, move_window, move_window_to_top, show_window

"""
    hide_window(win::Window)

Hide the window `win`.

"""
hide_window(win::Window) = hide_panel(win.panel)

"""
    move_window(win::Window, starty::Int, startx::Int)

Move the window `win` to the position `(starty, startx`).

"""
move_window(win::Window, starty::Int, startx::Int) =
    move_panel(win.panel, starty, startx)

"""
    move_window_to_top(win::Window)

Move window `win` to the top.

"""
move_window_to_top(win::Window) = top_panel(win.panel)

"""
    show_window(win::Window)

Show the window `win`.

"""
show_window(win::Window) = show_panel(win.panel)
