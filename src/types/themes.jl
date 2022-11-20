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
    default::Int = 0
    error::Int = 0
    highlight::Int = 0
    border::Int = 0
    title::Int = 0
end
