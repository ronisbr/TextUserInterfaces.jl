#==# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains functions related to the API of widget containers. Notice
#   that a window is a container of one object.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #==#

"""
    function add_widget(win::Window, widget::Widget)

Add widget `widget` to the window `win`. If the `win` already have a widget,
then it will be replaced.

"""
function add_widget(win::Window, widget::Widget)
    win.widget = widget
    return nothing
end

"""
    function remove_widget(win::Window, widget::Widget)

Remove the widget `widget` from the window `win`. If `widget` does not belong to
`win`, then nothing is done.

"""
function remove_widget(win::Window, widget::Widget)
    if win.widget === widget
        win.widget = nothing
    end

    # TODO: Log error if the widget is not in the window.
    return nothing
end
