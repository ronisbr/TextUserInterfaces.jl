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
    function create_widget_common(parent::WidgetParent, posconf::WidgetPositioningConfiguration)

Create all the variables in the common structure of the widget API.

# Args

* `parent`: Parent widget.
* `posconf`: Widget positioning configuration
             (see `WidgetPositioningConfiguration`).

"""
function create_widget_common(parent::WidgetParent,
                              posconf::WidgetPositioningConfiguration)

    # Process the positioning.
    _process_vertical_info!(posconf)
    _process_horizontal_info!(posconf)

    @unpack_WidgetPositioningConfiguration posconf

    # Vertical
    # ==========================================================================

    if vertical == :abottom_atop
        bottom = _get_anchor(anchor_bottom, parent)
        top    = _get_anchor(anchor_top, parent)
        height = bottom - top

    elseif vertical == :abottom_height
        bottom = _get_anchor(anchor_bottom, parent)
        top    = bottom - height

    elseif vertical == :atop_height
        top = _get_anchor(anchor_top, parent)

    elseif vertical == :amiddle_height
        middle = _get_anchor(anchor_middle, parent)
        top    = middle - div(height,2)

    elseif vertical == :unknown
        @log critical "create_widget_common" """
        It was not possible to guess the vertical positioning of the widget.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        posconf:
        @log_pad 4
        $(_str(posconf))"""

        error("It was not possible to guess the vertical positioning of the widget.")
    end

    if top < 0
        @log critical "create_widget_common" """
        Wrong vertical size configuration leading to negative top position.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        posconf:
        @log_pad 4
        $(_str(posconf))"""

        error("Wrong vertical size configuration leading to negative top position.")
    end

    if height <= 0
        @log critical "create_widget_common" """
        Wrong vertical size configuration leading to negative top position.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        posconf:
        @log_pad 4
        $(_str(posconf))"""

        error("Wrong vertical size configuration leading to negative top position.")
    end

    # Horizontal
    # ==========================================================================

    if horizontal == :aleft_aright
        left  = _get_anchor(anchor_left, parent)
        right = _get_anchor(anchor_right, parent)
        width = right - left

    elseif horizontal == :aleft_width
        left = _get_anchor(anchor_left, parent)

    elseif horizontal == :aright_width
        right = _get_anchor(anchor_right, parent)
        left  = right - width

    elseif horizontal == :acenter_width
        center = _get_anchor(anchor_center, parent)
        left   = center - div(width,2)

    elseif horizontal == :unknown
        @log critical "create_widget_common" """
        It was not possible to guess the horizontal positioning of the widget.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        posconf:
        @log_pad 4
        $(_str(posconf))"""

        error("It was not possible to guess the horizontal positioning of the widget.")
    end

    if left < 0
        @log critical "create_widget_common" """
        Wrong vertical size configuration leading to negative left position.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        posconf:
        @log_pad 4
        $(_str(posconf))"""

        error("Wrong vertical size configuration leading to negative left position.")
    end

    if width <= 0
        @log critical "create_widget_common" """
        Wrong vertical size configuration leading to non-positive width position.

        parent:
        @log_pad 4
        $parent
        @log_pad 0
        posconf:
        @log_pad 4
        $(_str(posconf))"""

        error("Wrong vertical size configuration leading to non-positive width position.")
    end

    # Create the buffer that will hold the contents.
    buffer = subpad(get_buffer(parent), height, width, top, left)

    # Create the common parameters of the widget.
    common = WidgetCommon(parent  = parent,
                          buffer  = buffer,
                          posconf = posconf,
                          height  = height,
                          width   = width,
                          top     = top,
                          left    = left)

    return common
end
