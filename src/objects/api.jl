# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file defines the functions required by the Object API.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export get_left, get_height, get_width, get_top, get_id, reserve_object_id
export update_layout!

"""
    destroy!(object::Object)

Destroy the `object`.
"""
destroy!

"""
    get_left(object::Object::Object)

Return the left of the `object` with respect to its parent.
"""
get_left

"""
    get_height(object::Object)

Return the height of `object`.
"""
get_height

"""
    get_width(object::Object)

Return the width of `object`.
"""
get_width

"""
    get_top(object::Object)

Return the top of the `object` with respect to its parent.
"""
get_top

"""
    get_inner_left(object::Object)

Return the left position in the inner container of the `object`.
"""
get_inner_left

"""
    get_inner_height(object::Object)

Return the height in the inner container of the `object`.
"""
get_inner_height

"""
    get_inner_width(object::Object)

Return the width in the inner container of the `object`.
"""
get_inner_width

"""
    get_inner_top(object::Object)

Return the top position in the inner container of the `object`.
"""
get_inner_top

"""
    get_id(object::Object)

Return the global ID of `object`.
"""
get_id(object::Object) = object.id

"""
    process_keystroke!(object::Object, keystroke)::Symbol

Process the `keystroke` in the `object`. This function must return a `Symbol`
according to the following description:

- `:keystroke_processed`: The object processed the focus and nothing more should
    be done.
- `:keystroke_not_processed`: The object could not process the keystroke.
- `:next_object`: Pass the focus to the next object in the chain.
- `:previous_object`: Pass the focus to the previous object in the chain.
"""
process_keystroke!

"""
    reserve_object_id()

Reserve and return an unique object ID.
"""
function reserve_object_id()
    tui._num_of_created_objects += 1
    return tui._num_of_created_objects
end

"""
    release_focus!(object::Object)

Release the focus from `object`. It must return `true` if the focus was
released, or `false` otherwise.
"""
release_focus!(object::Object)

"""
    request_focus!(object::Object)

Return `true` if the object can accept the focus. `false` otherwise.
"""
request_focus!

"""
    request_update!(object::Object::Object)

Request update for `object`.
"""
request_update!(object::Object) = return nothing

"""
    update!(object::Object; force::Bool = true)

Update the `object` and return `true` it an updated was needed, or `false`
otherwise. If the keyword `force` is `true`, the `object` must be updated.
"""
update!(object::Object; force::Bool = true) = return false

"""
    update_layout!(object::Object)

Update the layout of the object based on the stored configuration.
"""
update_layout!
