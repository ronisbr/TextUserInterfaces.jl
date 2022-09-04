
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file defines the root window. This object is currently only used for
#   anchoring windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

get_left(rw::RootWindow)   = 0
get_height(rw::RootWindow) = LINES()
get_width(rw::RootWindow)  = COLS()
get_top(rw::RootWindow)    = 0

get_inner_left(rw::RootWindow)   = 0
get_inner_height(rw::RootWindow) = LINES()
get_inner_width(rw::RootWindow)  = COLS()
get_inner_top(rw::RootWindow)    = 0
