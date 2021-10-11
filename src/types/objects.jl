# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Types related to objects.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export Anchor, ObjectLayout, ObjectLayout

################################################################################
#                                   Anchors
################################################################################

"""
    struct Anchor

This structure defines an anchor to another object. It should be used in one of
the fields `anchor_*` of `ObjectLayout`.

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
    obj::Union{Symbol, Object}
    side::Symbol
    pad::Int
end

# Singleton that indicates that no anchor is available.
const _no_anchor = Anchor(:noobject, :nosize, 0)

"""
    struct ObjectLayout

This structure defines the layout of an object.

# Fields

- `anchor_bottom::Anchor`: Bottom anchor specification.
    (**Default** = `_no_anchor`)
- `anchor_left::Anchor`: Left anchor specification.
    (**Default** = `_no_anchor`)
- `anchor_right::Anchor`: Right anchor specification.
    (**Default** = `_no_anchor`)
- `anchor_top::Anchor`: Top anchor specification. (**Default** = `_no_anchor`)
- `anchor_center::Anchor`: Center anchor specification.
    (**Default** = `_no_anchor`)
- `anchor_middle::Anchor`: Middle anchor specification.
    (**Default** = `_no_anchor`)
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
@with_kw mutable struct ObjectLayout
    # Anchors (relative positioning).
    anchor_bottom::Anchor = _no_anchor
    anchor_left::Anchor   = _no_anchor
    anchor_right::Anchor  = _no_anchor
    anchor_top::Anchor    = _no_anchor
    anchor_center::Anchor = _no_anchor
    anchor_middle::Anchor = _no_anchor

    # Absolute positioning.
    top::Union{Int, String}    = -1
    left::Union{Int, String}   = -1
    height::Union{Int, String} = -1
    width::Union{Int, String}  = -1
end
