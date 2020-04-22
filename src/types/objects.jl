# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Types related to objects.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

################################################################################
#                                   Anchors
################################################################################

struct Anchor
    obj::Object
    side::Symbol
    pad::Int
end

# Type of the tuple that defines an anchor.
AnchorTuple = Union{Nothing,Tuple{Object,Symbol,Int}}

# Types that can be anchors to objects.
ObjectAnchor = Union{Nothing,Anchor}

# Configuration related to the position of the objects.
@with_kw mutable struct ObjectPositioningConfiguration
    # Anchors (relative positioning).
    anchor_bottom::ObjectAnchor = nothing
    anchor_left::ObjectAnchor   = nothing
    anchor_right::ObjectAnchor  = nothing
    anchor_top::ObjectAnchor    = nothing
    anchor_center::ObjectAnchor = nothing
    anchor_middle::ObjectAnchor = nothing

    # Absolute positioning.
    top::Int    = -1
    left::Int   = -1
    height::Int = -1
    width::Int  = -1

    # Type of positioning.
    vertical::Symbol   = :unknown
    horizontal::Symbol = :unknown
end
