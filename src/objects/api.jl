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
    get_left_for_child

Return the left of the object for a child object.

"""
get_left_for_child

"""
    function get_height(object)

Return the usable height of object `object`.

"""
get_height

"""
    get_height_for_child

Return the usable height of the object for a child object.

"""
get_height_for_child

"""
    function get_width(object)

Return the usable width of object `object`.

"""
get_width

"""
    get_width_for_child

Return the usable width of object `object` for a child object.

"""
get_width_for_child

"""
    function get_top(object)

Return the top of the object w.r.t. its parent.

"""
get_top

"""
    get_top_for_child

Return the top of the object for a child object.

"""
get_top_for_child

"""
    function reposition!(object)

Reposition the object baesd on the stored configuration.

"""
reposition!
