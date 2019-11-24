# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Types related to widgets.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export Widget, WidgetCommon, WidgetParent

################################################################################
#                                   Anchors
################################################################################

# Objects that can be used as anchors.
AnchorObject = Union{Window,Widget}

struct Anchor{T<:AnchorObject}
    obj::T
    side::Symbol
    pad::Int
end

# Types that can be anchors to widgets.
WidgetAnchor = Union{Nothing,Anchor}

# Configuration related to the position of the widgets.
@with_kw mutable struct WidgetPositioningConfiguration{Tb<:WidgetAnchor,
                                                       Tl<:WidgetAnchor,
                                                       Tr<:WidgetAnchor,
                                                       Tt<:WidgetAnchor,
                                                       Tc<:WidgetAnchor,
                                                       Tm<:WidgetAnchor}
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

################################################################################
#                                   Widgets
################################################################################

# Types that can be parent of widgets.
WidgetParent = Union{Window,Widget}

# Common configurations for all widgets.
@with_kw mutable struct WidgetCommon{T<:WidgetParent}
    parent::T
    buffer::Ptr{WINDOW} = Ptr{WINDOW}(0)

    # Configuration related to the size and position of the widget.
    posconf::WidgetPositioningConfiguration

    # Current size and position of the widget.
    top::Int    = -1
    left::Int   = -1
    height::Int = -1
    width::Int  = -1

    update_needed::Bool = true
end
