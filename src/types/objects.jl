# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Types related to objects.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export Anchor, ObjectPositioningConfiguration

################################################################################
#                                   Anchors
################################################################################

struct Anchor
    obj::Object
    side::Symbol
    pad::Int
end

# Singleton that indicates that no anchor is available.
struct _NO_OBJECT <: Object end
const _no_anchor = Anchor(_NO_OBJECT(), :nosize, 0)

# Configuration related to the position of the objects.
@with_kw mutable struct ObjectPositioningConfiguration
    # Anchors (relative positioning).
    anchor_bottom::Anchor = _no_anchor
    anchor_left::Anchor   = _no_anchor
    anchor_right::Anchor  = _no_anchor
    anchor_top::Anchor    = _no_anchor
    anchor_center::Anchor = _no_anchor
    anchor_middle::Anchor = _no_anchor

    # Absolute positioning.
    top::Int    = -1
    left::Int   = -1
    height::Int = -1
    width::Int  = -1

    # Type of positioning.
    vertical::Symbol   = :unknown
    horizontal::Symbol = :unknown
end
