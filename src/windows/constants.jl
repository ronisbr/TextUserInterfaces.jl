# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   This file contains constants related to windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Hints for the window layout.
const _WINDOW_HORIZONTAL_LAYOUT_HINTS = Dict{Symbol, Any}(
    :left_anchor  => Anchor(:parent, :left,   0),
    :right_anchor => Anchor(:parent, :right,  0),
)

const _WINDOW_VERTICAL_LAYOUT_HINTS = Dict{Symbol, Any}(
    :bottom_anchor => Anchor(:parent, :bottom, 0),
    :top_anchor    => Anchor(:parent, :top,    0),
)

# Object layout for the window's widget container.
const _WINDOW_CONTAINER_OBJECT_LAYOUT = ObjectLayout(
    bottom_anchor = Anchor(:parent, :bottom, 0),
    left_anchor   = Anchor(:parent, :left,   0),
    right_anchor  = Anchor(:parent, :right,  0),
    top_anchor    = Anchor(:parent, :top,    0),
)
