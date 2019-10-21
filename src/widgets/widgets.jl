# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file defines the widget API.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

################################################################################
#                                API functions
################################################################################

export accept_focus, create_widget, destroy_widget, request_update,
       request_focus, redraw, release_focus, update

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
the parent window. Otherwise, no refresh will be performed.

"""
function destroy_widget(widget; refresh::Bool = true)
    @unpack common = widget
    @unpack parent, buffer = common

    widget_desc = obj_desc(widget)

    delwin(buffer)
    buffer = Ptr{WINDOW}(0)

    # Remove the widget from the parent.
    remove_widget(parent, widget)

    @log info "destroy_widget" "Widget $widget_desc destroyed."

    # If required, perform a full refresh of the parent window.
    refresh && refresh_window(parent; full_refresh = true)

    return nothing
end

"""
    function get_buffer(widget)

Return the buffer of the widget `widget`.

"""
get_buffer(widget) = widget.common.buffer

"""
    function get_height(widget)

Return the height of widget `widget`.

"""
get_height(widget) = widget.common.height

"""
    function get_width(widget)

Return the width of widget `widget`.

"""
get_width(widget) = widget.common.width

"""
    function process_focus(widget, k::Keystroke)

Process the actions when widget `widget` is in focus and the keystroke `k` is
pressed. If it returns `false`, then it is means that the widget was not capable
to process the focus. Otherwise, it must return `true`.

"""
process_focus(widget,k::Keystroke) = return false

"""
    function request_focus(widget)

Request to focus to the widget `widget`.

"""
function request_focus(widget)
    @unpack common = widget
    @unpack parent = common

    # Only request focus if the widget can accept the focus.
    request_focus(parent, widget)

    return nothing
end

"""
    function request_update(widget)

Request update of the widget `widget`.

"""
function request_update(widget)
    widget.common.update_needed = true
    request_update(widget.common.parent)
    return nothing
end

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
    if widget.common.update_needed || force_redraw
        redraw(widget)
        widget.common.update_needed = false
        return true
    else
        return false
    end
end

"""
    function require_cursor()

If `true`, then the physical cursor will be shown and the position will be
updated according to its position in the widget window. Otherwise, the physical
cursor will be hidden.

"""
require_cursor(widget) = false

################################################################################
#                              Helpers functions
################################################################################

export create_widget_common

"""
    function create_widget_common(parent::WidgetParent, top::Tt, left::Tl, height::Number, width::Number, vsize_policy::Symbol, hsize_policy::Symbol) where {Tt<:Union{Integer,Symbol},Tl<:Union{Integer,Symbol}}

Create all the variables in the common structure of the widget API.

# Args

* `parent`: Parent widget.
* `top`: Top position of the widget. It can be an integer, or a symbol. If it is
         a symbol, then the widget vertical alignment will be automatically
         computed. In this case, it can be used `:top`, `:center`, or `:bottom`.
* `left`: Left position of the widget. It can be an integer, or a symbol. If it
          is a symbol, then the widget horizontal alignment will be
          automatically computed. In this case, it can be used `:left`,
          `:center`, or `:right`.
* `height`: If `vsize_policy` is `:absolute`, then it must be an integer with
            the height of the widget. If `vsize_policy` is `:relative`, then it
            will be treated as a percentage of the parent height.
* `width`: If `hsize_policy` is `:absolute`, then it must be an integer with
            the width of the widget. If `hsize_policy` is `:relative`, then it
            will be treated as a percentage of the parent width.
* `vsize_policy`: Policy to be used when computing the height of the widget. It
                  can be `:absolute` or `:relative`.
* `hsize_policy`: Policy to be used when computing the width of the widget. It
                  can be `:absolute` or `:relative`.

"""
function create_widget_common(parent::WidgetParent, top::Tt, left::Tl,
                              height::Number, width::Number,
                              vsize_policy::Symbol, hsize_policy::Symbol) where
    {Tt<:Union{Integer,Symbol},Tl<:Union{Integer,Symbol}}

    # Get the parent height and size.
    parent_height = get_height(parent)
    parent_width  = get_width(parent)

    # Get the widget height and size.
    widget_height = _widget_height(parent, height, vsize_policy)
    widget_width  = _widget_width(parent, width, hsize_policy)

    # Compute the position in the parent.
    if parent_height < widget_height
        @log warning "create_widget_common" "Widget is too tall to fit in parent $(obj_desc(parent))."
        widget_top = 0
    elseif Tt <: Number
        widget_top = top
    else
        if top == :center
            widget_top = round(Int, (parent_height - widget_height) ÷ 2)
        elseif top == :bottom
            widget_top = parent_height - widget_height
        else
            widget_top = 0
        end
    end

    if parent_width < widget_width
        @log warning "create_widget_common" "Widget is too wide to fit in parent $(obj_desc(parent))."
        widget_left = 0
    elseif Tl <: Number
        widget_left = left
    else
        if left == :center
            widget_left = round(Int, (parent_width - widget_width) ÷ 2)
        elseif left == :right
            widget_left = parent_width - widget_width
        else
            widget_left = 0
        end
    end

    # Create the buffer that will hold the contents.
    buffer = subpad(get_buffer(parent), widget_height, widget_width, widget_top,
                    widget_left)

    # Create the common parameters of the widget.
    common = WidgetCommon(parent       = parent,
                          buffer       = buffer,
                          height       = widget_height,
                          width        = widget_width,
                          top          = widget_top,
                          left         = widget_left,
                          hsize_policy = hsize_policy,
                          vsize_policy = vsize_policy)

    return common
end

function _widget_height(parent::WidgetParent, height::Number, policy::Symbol)
    if policy == :relative
        # Get the size of the parent widget.
        parent_height = get_height(parent)

        # Compute the widget size.
        widget_height = round(Int,parent_height*height)

        return widget_height
    else
        return height
    end
end

function _widget_width(parent::WidgetParent, width::Number, policy::Symbol)
    if policy == :relative
        # Get the size of the parent widget.
        parent_width = get_width(parent)

        # Compute the widget size.
        widget_width = round(Int,parent_width*width)

        return widget_width
    else
        return width
    end
end

