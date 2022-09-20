
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file defines the implementation of the functions required by the Object
#   API for the widgets.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

can_accept_focus(widget::Widget) = false
can_release_focus(widget::Widget) = true

function destroy!(widget::Widget)
    @unpack buffer, container = widget

    # Before destroying the object, get its parent.
    parent = get_parent(widget)

    # Get the object description for logging purposes.
    widget_desc = obj_desc(widget)

    # Destroy the widget buffer.
    destroy_widget_buffer!(widget)

    # If the widget is added to a container, remove it.
    !isnothing(container) && remove_widget!(container, widget)

    @log INFO "destroy!" "Widget destroyed: $widget_desc"

    # Now update the parent, which can be a container or a window.
    update!(parent; force = true)

    return nothing
end

get_left(widget::Widget)   = widget.left
get_width(widget::Widget)  = widget.width
get_height(widget::Widget) = widget.height
get_top(widget::Widget)    = widget.top

function update_layout!(widget::Widget; force::Bool = false)
    @unpack layout, horizontal_hints, vertical_hints = widget

    parent = get_parent(widget)

    # Get the layout information of the window.
    height, width, top, left = process_object_layout(
        layout,
        parent;
        horizontal_hints,
        vertical_hints
    )

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
    update_needed = widget_resize || widget_move || force

    # TODO: Calling `mvwin` on subpad does not work. Hence, we destroy and
    # recreate the subpad. We must check if there is a better way.
    if update_needed
        delwin(widget.buffer)
        widget.buffer = Ptr{WINDOW}(0)
        widget.buffer = subpad(get_buffer(parent), height, width, top, left)
        request_update!(widget)
    end

    return update_needed
end
