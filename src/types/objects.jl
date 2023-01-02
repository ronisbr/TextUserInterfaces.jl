
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Types related to objects.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export Anchor, ObjectLayout

################################################################################
#                                   Anchors
################################################################################

"""
    struct Anchor

This structure defines an anchor to another object. It should be used in one of
the fields `*`_anchor of `ObjectLayout`.

# Fields

- `obj::Union{Symbol, Object}`: Reference object.
- `side::Symbol`: Side of the reference object to which we will apply the
    attachment.
- `pad::Int`: A space between the anchors of the two objects.

!!! info
    `side` is one of the following symbols: `:left`, `:right`, `:top`,
    `:bottom`, `:center`, or `:middle`.
"""
struct Anchor
    obj::Union{Object, Symbol}
    side::Symbol
    pad::Int
end

# Singleton that indicates that no anchor is available.
const _NO_ANCHOR = Anchor(:noobject, :noside, 0)

# Construct to the cases in which a padding is not required.
Anchor(obj::Union{Object, Symbol}, side::Symbol) = Anchor(obj, side, 0)

"""
    struct ObjectLayout

This structure defines the layout of an object.

# Fields

- `bottom_anchor::Anchor`: Bottom anchor specification.
    (**Default** = `_NO_ANCHOR`)
- `left_anchor::Anchor`: Left anchor specification.
    (**Default** = `_NO_ANCHOR`)
- `right_anchor::Anchor`: Right anchor specification.
    (**Default** = `_NO_ANCHOR`)
- `top_anchor::Anchor`: Top anchor specification. (**Default** = `_NO_ANCHOR`)
- `center_anchor::Anchor`: Center anchor specification.
    (**Default** = `_NO_ANCHOR`)
- `middle_anchor::Anchor`: Middle anchor specification.
    (**Default** = `_NO_ANCHOR`)
- `top::Union{Int, String}`: Absolute position of the object top side.
    (**Default** = -1)
- `left::Union{Int, String}`: Absolute position of the object left side.
    (**Default** = -1)
- `height::Union{Int, String}`: Height of the object. (**Default** = -1)
- `width::Union{Int, String}`: Width of the object. (**Default** = -1)

!!! info
    If the absolute positioning arguments (`top`, `left`, `height`, and `width`)
    are negative, then it means that there is no information about them. Hence,
    the relative arguments (anchors) must provide the missing information.
"""
@with_kw struct ObjectLayout
    # Anchors (relative positioning).
    bottom_anchor::Anchor = _NO_ANCHOR
    left_anchor::Anchor   = _NO_ANCHOR
    right_anchor::Anchor  = _NO_ANCHOR
    top_anchor::Anchor    = _NO_ANCHOR
    center_anchor::Anchor = _NO_ANCHOR
    middle_anchor::Anchor = _NO_ANCHOR

    # Absolute positioning.
    top::Union{Int, String}    = -1
    left::Union{Int, String}   = -1
    height::Union{Int, String} = -1
    width::Union{Int, String}  = -1
end
