## Description #############################################################################
#
# This file contains the types related to themes.
#
############################################################################################

export Theme

"""
    struct Theme

Defines a theme in the text user interface.

# Fields

- `default::Int`: NCurses color for all elements.
- `error::Int`: NCurses color for errors.
- `highlight::Int`: NCurses color used for highlighted elements.
- `selected::Int`: NCurses color for selected items.
- `border::Int`: NCurses color for borders.
- `title::Int`: NCurses color for titles.
"""
@kwdef struct Theme
    default::Int = 0
    error::Int = 0
    highlight::Int = 0
    selected::Int = 0
    border::Int = 0
    title::Int = 0
end
