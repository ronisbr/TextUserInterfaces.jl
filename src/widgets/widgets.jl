# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file defines the widget API.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export accept_focus, create_widget, destroy_widget, request_update, redraw,
       release_focus, update

abstract type Widget end

"""
    function accept_focus(widget)

Return `true` is the widget `widget` accepts focus or `false` otherwise.

"""
accept_focus(widget) = return true

"""
    function create_widget(T, parent::Window, begin_y::Integer, begin_x::Integer, vargs...; kwargs...)

Create the widget of type `T` in the parent window `parent`. The widget will be
positioned on the coordinate `(begin_y, begin_x)` of the parent window.

Additional variables and keywords related to each widget can be passed using
`vargs` and `kwargs` respectively.

"""
create_widget

"""
    function destroy_widget(widget; refresh::Bool = true)

Destroy the widget `widget`.

If `refresh` is `true` (**default**), then a full refresh will be performed on
the parent window.

"""
function destroy_widget(widget; refresh::Bool = true)
    @unpack parent, cwin = widget

    delwin(cwin)
    cwin = Ptr{WINDOW}(0)

    # Remove the widget from the parent window.
    idx = findall(x->x == widget, parent.widgets)
    deleteat!(parent.widgets, idx)

    # In this case, we need a full refresh of the parent window.
    refresh_window(parent; full_refresh = true)
end

"""
    function process_focus(widget, k::Keystroke)

Process the actions when widget `widget` is in focus and the keystroke `k` is
pressed. If it returns `false`, then it is means that the widget was not capable
to process the focus. Otherwise, it must return `true`.

"""
process_focus(widget,k::Keystroke) = return false

"""
    function request_update(widget)

Request update of the widget `widget`.

"""
request_update(widget) = widget.update_needed = true

"""
    function redraw(widget)

Redraw the widget inside its content window `cwin`.

"""
redraw


"""
    function release_focus(widget)

Request focus to be released. It should return `true` if the focus can be
released or `false` otherwise.

"""
release_focus(widget) = return true

"""
    function update(widget; force_redraw = false)

Update the widget by calling the function `redraw`. This function returns `true`
if the widget needed to be updated of `false` otherwise.

If `force_redraw` is `true`, then the widget will be updated even if it is not
needed.

"""
function update(widget; force_redraw = false)
    if widget.update_needed || force_redraw
        redraw(widget)
        widget.update_needed = false
        return true
    else
        return false
    end
end
