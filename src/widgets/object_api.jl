## Description #############################################################################
#
# This file defines the implementation of the functions required by the Object API for the
# widgets.
#
############################################################################################

can_accept_focus(widget::Widget) = false
can_release_focus(widget::Widget) = true

function destroy!(widget::Widget)
    return destroy_widget!(widget)
end

get_left(widget::Widget)   = widget.left
get_width(widget::Widget)  = widget.width
get_height(widget::Widget) = widget.height
get_top(widget::Widget)    = widget.top

function update_layout!(widget::Widget; force::Bool = false)
    return update_widget_layout!(widget; force = force)
end
