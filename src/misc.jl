## Description #############################################################################
#
# Miscellaneous functions.
#
############################################################################################

export obj_desc

"""
    obj_desc(obj) -> String

Return a string with the description of the object `obj` formed by:

    <Object type> (<Object ID>)
"""
function obj_desc(obj)
    obj_type = string(typeof(obj))

    # JET.jl reporter a problem that was solved by fixing the type here.
    obj_id::String = string(get_id(obj))

    return obj_type * " (" * obj_id * ")"
end
