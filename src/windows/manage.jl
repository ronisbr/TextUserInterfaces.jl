# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains functions to manage windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export hide_window, move_window, move_window_to_top, show_window

################################################################################
#                                    Window
################################################################################

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

################################################################################
#                                 Child widget
################################################################################

"""
    add_widget!(win::Window, widget::Widget)

Add widget `widget` to the window `win`. If the `win` already have a widget,
then it will be replaced.

"""
function add_widget!(win::Window, widget::Widget)
    !isnothing(widget.parent) && remove_widget!(widget.parent, widget)

    widget.parent = win
    init_widget_buffer!(widget)
    win.widget = widget

    return nothing
end

"""
    remove_widget!(win::Window, widget::Widget)

Remove the widget `widget` from the window `win`. If `widget` does not belong to
`win`, then nothing is done.

"""
function remove_widget!(win::Window, widget::Widget)
    if win.widget === widget
        destroy_widget_buffer!(widget)
        win.widget = nothing
    end

    # TODO: Log error if the widget is not in the window.
    return nothing
end
