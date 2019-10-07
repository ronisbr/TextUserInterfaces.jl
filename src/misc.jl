# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Description
#
#   Miscellaneous functions of TextUserInterfaces.jl.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export obj_desc, obj_to_ptr

const _test_hide_address = [false]

"""
    function obj_desc(obj)

Return a string with the description of the object `obj` formed by:

    <Object type> (<Object address if mutable>)

"""
function obj_desc(obj)
    obj_type = string(typeof(obj))

    if isimmutable(obj)
        return obj_type
    else
        return obj_type * " (" * obj_to_ptr(obj) * ")"
    end
end

"""
     function obj_to_ptr(obj)

Returns the hexadecimal representation of the address of the object `obj`. It
**only** works with mutable objects.  If `obj` is immutable, then `0x0` will be
returned.

"""
function obj_to_ptr(obj)
    if _test_hide_address[1]
        return "0x0"
    else
        return isimmutable(obj) ? "0x0" : repr(UInt64(pointer_from_objref(obj)))
    end
end

