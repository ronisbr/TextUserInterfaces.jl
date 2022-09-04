
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file defines the implementation of the functions required by the Object
#   API for the windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

get_left(win::Window)   = win.view != C_NULL ? Int(getbegx(win.view)) : -1
get_height(win::Window) = win.view != C_NULL ? Int(getmaxy(win.view)) : -1
get_width(win::Window)  = win.view != C_NULL ? Int(getmaxx(win.view)) : -1
get_top(win::Window)    = win.view != C_NULL ? Int(getbegy(win.view)) : -1

get_inner_left(win::Window)   = win.buffer != C_NULL ? Int(getbegx(win.buffer)) : -1
get_inner_height(win::Window) = win.buffer != C_NULL ? Int(getmaxy(win.buffer)) : -1
get_inner_width(win::Window)  = win.buffer != C_NULL ? Int(getmaxx(win.buffer)) : -1
get_inner_top(win::Window)    = win.buffer != C_NULL ? Int(getbegy(win.buffer)) : -1
