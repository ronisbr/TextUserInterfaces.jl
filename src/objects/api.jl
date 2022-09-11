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
    process_keystroke(object, keystroke)::Symbol

Process the `keystroke` in the `object`. This function must return a `Symbol`
according to the following description:

- `:keystroke_processed`: The object processed the focus and nothing more should
    be done.
- `:next_object`: Pass the focus to the next object in the chain.
- `:previous_object`: Pass the focus to the previous object in the chain.
"""
process_keystroke(object, keystroke)

"""
    request_focus(object)

Return `true` if the object can accept the focus. `false` otherwise.
"""
request_focus(object)

"""
    update_layout!(object)

Update the layout of the object based on the stored configuration.
"""
update_layout!
