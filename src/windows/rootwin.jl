# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file defines the root window. This object is currently only used for
#   anchoring windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export rootwin

struct RootWin <: Object end

const rootwin = RootWin()

get_left(rw::RootWin)           = 0
get_height(rw::RootWin)         = LINES()
get_width(rw::RootWin)          = COLS()
get_visible_height(rw::RootWin) = LINES()
get_visible_width(rw::RootWin)  = COLS()
