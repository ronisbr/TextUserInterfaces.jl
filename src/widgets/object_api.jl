# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file defines the implementation of the functions required by the Object
#   API for the widgets.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

get_left(widget::Widget)   = widget.left
get_width(widget::Widget)  = widget.width
get_height(widget::Widget) = widget.height
get_top(widget::Widget)    = widget.top

function reposition!(widget::Widget; force::Bool = false)
    @unpack layout, parent = widget

    # Compute the widget true position based on the configuration given the new
    # size of the parent.
    height, width, top, left = compute_object_layout(layout, parent)

    # Check if resize or move is required.
    widget_resize = false
    widget_move   = false

    if (height != widget.height) || (width != widget.width)
        widget_resize = true
    end

    if (top != widget.top) || (left != widget.left)
        widget_move = true
    end

    # Repack values.
    @pack! widget = height, width, top, left

    # Check if we need to recreate the widget.
    repos = widget_resize || widget_move || force

    # TODO: Calling `mvwin` on subpad does not work. Hence, we destroy and
    # recreate the subpad. We must check if there is a better way.
    if repos
        delwin(widget.buffer)
        widget.buffer = Ptr{WINDOW}(0)
        widget.buffer = subpad(get_buffer(parent), height, width, top, left)
        request_update!(widget)
    end

    return repos
end

