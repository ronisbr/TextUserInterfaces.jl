# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   This file defines the functions required by the Object API.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export get_left, get_height, get_width, get_top, get_id, reserve_object_id
export update_layout!

"""
    can_accept_focus(object::Object) -> Bool

Return `true` if `object` can accept focus. `false` otherwise.
"""
can_accept_focus

"""
    can_release_focus(object::Object) -> Bool

Return `true` if `object` can release focus. `false` otherwise.
"""
can_release_focus

"""
    destroy!(object::Object) -> Nothing

Destroy the `object`.
"""
destroy!

"""
    get_buffer(object::Object) -> Ptr{WINDOW}

Return the buffer of the `object`.
"""
get_buffer

"""
    get_left(object::Object) -> Object

Return the left of the `object` with respect to its parent.
"""
get_left

"""
    get_height(object::Object) -> Int

Return the height of `object`.
"""
get_height

"""
    get_width(object::Object) -> Int

Return the width of `object`.
"""
get_width

"""
    get_top(object::Object) -> Int

Return the top of the `object` with respect to its parent.
"""
get_top

"""
    get_inner_left(object::Object) -> Int

Return the left position in the inner container of the `object`.
"""
get_inner_left

"""
    get_inner_height(object::Object) -> Int

Return the height in the inner container of the `object`.
"""
get_inner_height

"""
    get_inner_width(object::Object) -> Int

Return the width in the inner container of the `object`.
"""
get_inner_width

"""
    get_inner_top(object::Object) -> Int

Return the top position in the inner container of the `object`.
"""
get_inner_top

"""
    get_id(object::Object) -> Int

Return the global ID of `object`.
"""
get_id(object::Object) = object.id

"""
    process_keystroke!(object::Object, keystroke::Keystroke) -> Symbol

Process the `keystroke` in the `object`.


# Returns

This function must return a `Symbol` according to the following description:

- `:keystroke_processed`: The object processed the focus and nothing more should be done.
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
    request_cursor(object::Object) -> Bool

If `true`, the physical cursor will be shown and the position will be updated according
to its position in the object window. Otherwise, the physical cursor will be hidden.
"""
request_cursor(object::Object) = false

"""
    release_focus!(object::Object) -> Nothing

Release the focus from `object`. If this function is called, the object **must** release the
focus.
"""
release_focus!(object::Object) = return nothing

"""
    request_update!(object::Object::Object) -> Nothing

Request update for `object`.
"""
request_update!(object::Object) = return nothing

"""
    sync_cursor(object::Object) -> Nothing

Synchronize the cursor considering the focused object inside `object` with the physical
cursor. This function must be implemented only if the `object` is a container.
"""
sync_cursor

"""
    update!(object::Object; force::Bool = true) -> Bool

Update the `object` and return `true` if an updated was needed, or `false` otherwise. If the
keyword `force` is `true`, the `object` must be updated.
"""
update!(object::Object; force::Bool = true) = return false

"""
    update_layout!(object::Object) -> Nothing

Update the layout of the object based on the stored configuration.
"""
update_layout!

# This helps to increase the performance due to the many conversions from object
# to string for debugging purposes.
Base.string(obj::Object) = sprint(print, obj)
