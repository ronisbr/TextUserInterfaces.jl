# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file defines the implementation of the functions required by the Object
#   API for the widgets.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

get_left(widget::T)   where T<:Widget = widget.common.left
get_width(widget::T)  where T<:Widget = widget.common.width
get_height(widget::T) where T<:Widget = widget.common.height
get_top(widget::T)    where T<:Widget = widget.common.top

get_visible_width(widget::T)  where T<:Widget = widget.common.width
get_visible_height(widget::T) where T<:Widget = widget.common.height

function reposition!(widget::T; force::Bool = false) where T<:Widget
    @unpack common = widget
    @unpack opc, parent, height, width, top, left = common

    # Compute the widget true position based on the configuration.
    height, width, top, left = compute_object_positioning(opc, parent)

    # Check if resize or move is required.
    widget_resize = false
    widget_move   = false

    ( (height != common.height) || (width != common.width) ) && (widget_resize = true)
    ( (top    != common.top)    || (left  != common.left)  ) && (widget_move   = true)

    # Repack values.
    @pack! common = height, width, top, left

    # Check if we need to recreate the widget.
    repos = widget_resize || widget_move || force

    # TODO: Calling `mvwin` on subpad does not work. Hence, we destroy and
    # recreate the subpad. We must check if there is a better way.
    if repos
        delwin(common.buffer)
        common.buffer = Ptr{WINDOW}(0)
        common.buffer = subpad(get_buffer(parent), height, width, top, left)
        request_update(widget)
    end

    return repos
end

