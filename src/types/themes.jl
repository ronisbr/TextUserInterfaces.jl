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
    (**Default** = `0`)
- `error::Int`: NCurses color for errors.
    (**Default** = `0`)
- `highlight::Int`: NCurses color used for highlighted elements.
    (**Default** = `0`)
- `selected::Int`: NCurses color for selected items.
    (**Default** = `0`)
- `border::Int`: NCurses color for borders.
    (**Default** = `0`)
- `title::Int`: NCurses color for titles.
    (**Default** = `0`)
"""
@kwdef struct Theme
    default::Int = 0
    error::Int = 0
    highlight::Int = 0
    selected::Int = 0
    border::Int = 0
    title::Int = 0
end
