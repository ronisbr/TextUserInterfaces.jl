# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains constants related to windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Hints for the window layout.
const _WINDOW_HORIZONTAL_LAYOUT_HINTS = Dict{Symbol, Any}(
    :anchor_left  => Anchor(:parent, :left,   0),
    :anchor_right => Anchor(:parent, :right,  0),
)

const _WINDOW_VERTICAL_LAYOUT_HINTS = Dict{Symbol, Any}(
    :anchor_bottom => Anchor(:parent, :bottom, 0),
    :anchor_top    => Anchor(:parent, :top,    0),
)

# Object layout for the window's widget container.
const _WINDOW_CONTAINER_OBJECT_LAYOUT = ObjectLayout(
    anchor_top    = Anchor(:parent, :top,    0),
    anchor_left   = Anchor(:parent, :left,   0),
    anchor_right  = Anchor(:parent, :right,  0),
    anchor_bottom = Anchor(:parent, :bottom, 0)
)
