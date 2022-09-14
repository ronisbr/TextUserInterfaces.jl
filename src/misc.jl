# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Miscellaneous functions.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export obj_desc

"""
    obj_desc(obj)

Return a string with the description of the object `obj` formed by:

    <Object type> (<Object ID>)
"""
function obj_desc(obj)
    obj_type = string(typeof(obj))
    return obj_type * " (" * string(get_id(obj)) * ")"
end
