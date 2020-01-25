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

struct Anchor{T<:Object}
    obj::T
    side::Symbol
    pad::Int
end

# Types that can be anchors to objects.
ObjectAnchor = Union{Nothing,Anchor}

# Configuration related to the position of the objects.
@with_kw mutable struct ObjectPositioningConfiguration{Tb<:ObjectAnchor,
                                                       Tl<:ObjectAnchor,
                                                       Tr<:ObjectAnchor,
                                                       Tt<:ObjectAnchor,
                                                       Tc<:ObjectAnchor,
                                                       Tm<:ObjectAnchor}
    # Anchors (relative positioning).
    anchor_bottom::Tb = nothing
    anchor_left::Tl   = nothing
    anchor_right::Tr  = nothing
    anchor_top::Tt    = nothing
    anchor_center::Tc = nothing
    anchor_middle::Tm = nothing

    # Absolute positioning.
    top::Int    = -1
    left::Int   = -1
    height::Int = -1
    width::Int  = -1

    # Type of positioning.
    vertical::Symbol   = :unknown
    horizontal::Symbol = :unknown
end
