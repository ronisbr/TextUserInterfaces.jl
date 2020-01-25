# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file defines the implementation of the functions required by the Object
#   API for the windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

get_left(win::T)   where T<:Window = win.view   != C_NULL ? Int(getbegx(win.view)) : -1
get_height(win::T) where T<:Window = win.buffer != C_NULL ? Int(getmaxy(win.buffer)) : -1
get_width(win::T)  where T<:Window = win.buffer != C_NULL ? Int(getmaxx(win.buffer)) : -1
get_top(win::T)    where T<:Window = win.view   != C_NULL ? Int(getbegy(win.view)) : -1

get_visible_height(win::T) where T<:Window = win.view != C_NULL ? Int(getmaxy(win.view)) : -1
get_visible_width(win::T)  where T<:Window = win.view != C_NULL ? Int(getmaxx(win.view)) : -1
