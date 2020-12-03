# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file defines the widget API.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

################################################################################
#                                API functions
################################################################################

export accept_focus, create_widget, destroy_widget!, init_widget_buffer!,
       request_update, request_focus, redraw, release_focus, set_widget_color,
       update

"""
    accept_focus(widget)

Return `true` is the widget `widget` accepts focus or `false` otherwise.

"""
accept_focus(widget) = return true

"""
    create_widget(T, opc::ObjectPositioningConfiguration, args...; kwargs...)
    create_widget(T, parent::WidgetParent, opc::ObjectPositioningConfiguration, args...; kwargs)

Create the widget of type `T` using the positioning configuration [`opc`](@ref).

Additional arguments and keywords related to each widget can be passed using
`args` and `kwargs`, respectively.

If the second signature is called, then the created widget is added to the
parent `parent`.

"""
create_widget

function create_widget(T,
                       parent::WidgetParent,
                       opc::ObjectPositioningConfiguration,
                       args...;
                       kwargs...)
    widget = create_widget(T, opc, args...; kwargs...)
    add_widget!(parent, widget)
    return widget
end

"""
    destroy_widget!(widget; refresh::Bool = true)

Destroy the widget `widget`.

If `refresh` is `true` (**default**), then a full refresh will be performed on
the parent window. Otherwise, no refresh will be performed.

"""
destroy_widget!(widget; refresh::Bool = true) =
    _destroy_widget!(widget; refresh = refresh)

"""
    destroy_widget_buffer!(widget::Widget)

Destroy the buffer of the widget `widget`.

"""
function destroy_widget_buffer!(widget::Widget)
    if widget.buffer != Ptr{WINDOW}(0)
        delwin(widget.buffer)
        widget.buffer = Ptr{WINDOW}(0)
    end

    return nothing
end

"""
    get_buffer(widget)

Return the buffer of the widget `widget`.

"""
get_buffer(widget) = widget.buffer

"""
    get_parent(widget)

Return the parent of the widget `widget`.

"""
get_parent(widget) = widget.parent

"""
    init_widget_buffer!(widget::Widget)

Initialize the buffer of widget `widget`. The variables `opc` and `parent` must
be set before calling this function. If the buffer is already initialized, then
it will be deleted first.

"""
function init_widget_buffer!(widget::Widget)
    destroy_widget_buffer!(widget)

    # Compute the widget true position based on the configuration.
    height, width, top, left = compute_object_positioning(widget.opc,
                                                          widget.parent)

    # Create the buffer that will hold the contents.
    buffer = subpad(get_buffer(widget.parent), height, width, top, left)

    # Update the variables in the widget.
    widget.buffer = buffer
    widget.height = height
    widget.width  = width
    widget.left   = left
    widget.top    = top

    return nothing
end

"""
    process_focus(widget, k::Keystroke)

Process the actions when widget `widget` is in focus and the keystroke `k` is
pressed. If it returns `false`, then it is means that the widget was not capable
to process the focus. Otherwise, it must return `true`.

"""
process_focus(widget,k::Keystroke) = return false

"""
    request_focus(widget)

Request to focus to the widget `widget`.

"""
function request_focus(widget)
    @unpack parent = widget

    # Only request focus if the widget can accept the focus.
    request_focus(parent, widget)

    return nothing
end

"""
    request_update(widget)

Request update of the widget `widget`.

"""
function request_update(widget)
    widget.update_needed = true
    request_update(widget.parent)
    return nothing
end

request_update(::Nothing) = return nothing

"""
    redraw(widget)

Redraw the widget inside its content window `cwin`.

"""
redraw

"""
    release_focus(widget)

Request focus to be released. It should return `true` if the focus can be
released or `false` otherwise.

"""
release_focus(widget) = return true

"""
    set_widget_color(widget, color::Int)

Set the background color of `widget` to `color`.

"""
function set_widget_color(widget, color::Int)
    color >= 0 && (wbkgd(get_buffer(widget), color))
    return nothing
end

"""
    update(widget; force_redraw = false)

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

"""
    require_cursor()

If `true`, then the physical cursor will be shown and the position will be
updated according to its position in the widget window. Otherwise, the physical
cursor will be hidden.

"""
require_cursor(widget) = false

################################################################################
#                                Containers API
################################################################################

# If a widget is not a container, then the functions related to the request of a
# another widget must be treated by the `accept_focus`.
request_next_widget(widget) = accept_focus(widget)
request_prev_widget(widget) = accept_focus(widget)

################################################################################
#                              Private functions
################################################################################

"""
    _destroy_widget!(widget; refresh::Bool = true)

Private function that destroys a widget. This can be used if a new widget needs
to reimplement the destroy function.

"""
function _destroy_widget!(widget; refresh::Bool = true)
    @unpack buffer, parent = widget

    widget_desc = obj_desc(widget)

    # Destroy the widget buffer.
    destroy_widget_buffer!(widget)

    # Remove the widget from the parent.
    remove_widget!(parent, widget)

    @log info "destroy_widget" "Widget destroyed: $widget_desc"

    # If required, perform a full refresh of the parent window.
    refresh && refresh_window(parent; force_redraw = true)

    return nothing
end
