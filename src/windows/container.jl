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
    function request_focus(win::Window, widget)

Request the focus to the widget `widget` of the window `win`. This function is
only necessary to make `Window` comply to the containers API. Since a window can
contain only one widget, then a function to change the focus is not meaningful.

"""
function request_focus(win::Window, widget)
    if win.widget == widget
        return true
    else
        @log warning "request_focus" "The widget $(obj_desc(widget)) does not belong to $(obj_desc(container))."
        return false
    end
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
