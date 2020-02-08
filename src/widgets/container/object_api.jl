# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file defines the implementation of the functions required by the Object
#   API for the containers.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

get_left_for_child(c::WidgetContainer)   = c.border ?  1 : 0
get_top_for_child(c::WidgetContainer)    = c.border ?  1 : 0

get_width_for_child(c::WidgetContainer)  = c.common.width  + (c.border ? -2 : 0)
get_height_for_child(c::WidgetContainer) = c.common.height + (c.border ? -2 : 0)
