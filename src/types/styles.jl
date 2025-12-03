## Description #############################################################################
#
# Types related to styles.
#
############################################################################################

export TuiStyle

"""
    struct TuiStyle

Structure that defines a style to be applied to printed characters.

# Fields

- `attrs::NCurses.attr_t`: Attributes to be applied (bold, underline, etc.).
    (**Default** = `0`)
- `color_pair::Integer`: ID of the color pair to be applied.
    (**Default** = `0`)
"""
struct TuiStyle
    attrs::NCurses.attr_t
    color_pair::Int
end