# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains functions related to the themes.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Create the default theme.
function _create_default_theme()
    default   = ncurses_color()
    error     = ncurses_color(:red, 0)
    highlight = ncurses_color(A_REVERSE)
    border    = default
    title     = default

    return Theme(;
        default,
        error,
        highlight,
        border,
        title,
    )
end
