# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains the types related to themes.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export Theme

"""
    struct Theme

Defines a theme in the text user interface.

# Fields

- `default::Int`: The default NCurses color for all elements.
- `highlight::Int`: The NCurses color used for highlighted elements.
"""
@with_kw struct Theme
    default::Int = ncurses_color()
    highlight::Int = ncurses_color(A_REVERSE)
    border::Int = default
    title::Int = default
    input_field_focused::Int = ncurses_color(A_UNDERLINE)
end
