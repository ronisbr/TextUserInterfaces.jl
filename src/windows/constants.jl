# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains constants related to windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Hints for the window layout.
const _WINDOW_HORIZONTAL_LAYOUT_HINTS = (
    anchor_left  = Anchor(:parent, :left,   0),
    anchor_right = Anchor(:parent, :right,  0),
)

const _WINDOW_VERTICAL_LAYOUT_HINTS = (
    anchor_bottom = Anchor(:parent, :bottom, 0),
    anchor_top    = Anchor(:parent, :top,    0),
)
