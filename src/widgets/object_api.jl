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
