# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file defines the root window. This object is currently only used for
#   anchoring windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export rootwin

get_left(rw::RootWin)   = 0
get_height(rw::RootWin) = LINES()
get_width(rw::RootWin)  = COLS()
get_top(rw::RootWin)    = 0

get_left_for_child(rw::RootWin)   = 0
get_height_for_child(rw::RootWin) = LINES()
get_width_for_child(rw::RootWin)  = COLS()
get_top_for_child(rw::RootWin)    = 0
