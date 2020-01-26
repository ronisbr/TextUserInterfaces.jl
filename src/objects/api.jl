# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file defines the functions required by the Object API.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export get_left, get_height, get_width, get_top, get_visible_height,
       get_visible_width, reposition!

"""
    function get_bottom(object)

Return the left of the object w.r.t. its parent.

"""
get_left

"""
    function get_height(object)

Return the usable height of object `object`.

"""
get_height

"""
    function get_width(object)

Return the usable width of object `object`.

"""
get_width

"""
    function get_top(object)

Return the top of the object w.r.t. its parent.

"""
get_top

"""
    function get_visible_height(object)

Return the visible height of object `object`.

"""
get_visible_height

"""
    function get_visible_width(object)

Return the visible width of object `object`.

"""
get_visible_width

"""
    function reposition!(object)

Reposition the object baesd on the stored configuration.

"""
reposition!
