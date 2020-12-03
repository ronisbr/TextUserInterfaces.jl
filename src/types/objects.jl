# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Types related to objects.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export Anchor, ObjectPositioningConfiguration, newopc

################################################################################
#                                   Anchors
################################################################################

"""
    struct Anchor

This structure defines an anchor to another object. It should be used in one of
the fields `anchor_*` of `ObjectPositioningConfiguration`.

# Fields

* `obj`: Reference object.
* `side`: Side of the reference object to which we will apply the attachment.
* `pad`: A space between the anchors of the two objects.

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
    struct ObjectPositioningConfiguration

This structure defines the positioning of an object. It can also be created with
the function `newopc`.

# Fields

* `anchor_bottom`: Bottom anchor specification. (**Default** = `_no_anchor`)
* `anchor_left`: Left anchor specification. (**Default** = `_no_anchor`)
* `anchor_right`: Right anchor specification. (**Default** = `_no_anchor`)
* `anchor_top`: Top anchor specification. (**Default** = `_no_anchor`)
* `anchor_center`: Center anchor specification. (**Default** = `_no_anchor`)
* `anchor_middle`: Middle anchor specification. (**Default** = `_no_anchor`)
* `top`: Absolute position of the object top side. (**Default** = -1)
* `left`: Absolute position of the object left side. (**Default** = -1)
* `height`: Height of the object. (**Default** = -1)
* `width`: Width of the object. (**Default** = -1)

!!! info

    If the absolute positioning arguments (`top`, `left`, `height`, and `width`)
    are negative, then it means that there is no information about them. Hence,
    the relative arguments (anchors) must provide the missing information.

"""
@with_kw mutable struct ObjectPositioningConfiguration
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

"""
    newopc(;kwargs...)

Create an instance of the structure `ObjectPositioningConfiguration`. The
following keywords are available to specify the positioning:

* `anchor_bottom`: Bottom anchor specification. (**Default** = `_no_anchor`)
* `anchor_left`: Left anchor specification. (**Default** = `_no_anchor`)
* `anchor_right`: Right anchor specification. (**Default** = `_no_anchor`)
* `anchor_top`: Top anchor specification. (**Default** = `_no_anchor`)
* `anchor_center`: Center anchor specification. (**Default** = `_no_anchor`)
* `anchor_middle`: Middle anchor specification. (**Default** = `_no_anchor`)
* `top`: Absolute position of the object top side. (**Default** = -1)
* `left`: Absolute position of the object left side. (**Default** = -1)
* `height`: Height of the object. (**Default** = -1)
* `width`: Width of the object. (**Default** = -1)

!!! info

    If the absolute positioning arguments (`top`, `left`, `height`, and `width`)
    are negative, then it means that there is no information about them. Hence,
    the relative arguments (anchors) must provide the missing information.

"""
const newopc = ObjectPositioningConfiguration
