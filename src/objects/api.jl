# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file defines the functions required by the Object API.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export get_left, get_height, get_width, get_top, reposition!

"""
    get_left(object)

Return the left of the `object` with respect to its parent.
"""
get_left

"""
    get_height(object)

Return the height of `object`.
"""
get_height

"""
    get_width(object)

Return the width of `object`.
"""
get_width

"""
    get_top(object)

Return the top of the `object` with respect to its parent.
"""
get_top

"""
    get_inner_left(object)

Return the left position in the inner container of the `object`.
"""
get_inner_left

"""
    get_inner_height(object)

Return the height in the inner container of the `object`.
"""
get_inner_height

"""
    get_inner_width(object)

Return the width in the inner container of the `object`.
"""
get_inner_width

"""
    get_inner_top(object)

Return the top position in the inner container of the `object`.
"""
get_inner_top

"""
    update_layout!(object)

Update the layout of the object based on the stored configuration.
"""
update_layout!
