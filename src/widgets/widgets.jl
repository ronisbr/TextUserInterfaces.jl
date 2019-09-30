# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file defines the widget API.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export create_widget, destroy_widget, request_update, redraw, update

abstract type Widget end

"""
    function create_widget(T, parent::TUI_WINDOW, begin_y::Integer, begin_x::Integer, vargs...; kwargs...)

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
    function request_update(widget)

Request update of the widget `widget`.

"""
function request_update(widget)
    widget.update_needed = true
end

"""
    function redraw(widget)

Redraw the widget inside its content window `cwin`.

"""
redraw

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
