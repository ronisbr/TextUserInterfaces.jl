## Description #############################################################################
#
# This file contains macros related to the colors.
#
############################################################################################

export ncolor

"""
    @ncolor(color, buffer, block)

This macro expands to the following code:

```julia
color >= 0 && wattr_on(buffer, color, C_NULL)
block
color >= 0 && wattr_off(buffer, color, C_NULL)
```
"""
macro ncolor(color, buffer, block)
    ex = quote
        $color >= 0 && NCurses.wattr_on($buffer, $color, C_NULL)
        $block
        $color >= 0 && NCurses.wattr_off($buffer, $color, C_NULL)
    end

    return esc(ex)
end
