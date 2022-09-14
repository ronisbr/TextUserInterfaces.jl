# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains macros related to the colors.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export ncolor

"""
    @ncolor(color, buffer, block)

This macro executes the following code:

```julia
color >= 0 && wattron(buffer, color)
block
color >= 0 && wattroff(buffer, color)
```
"""
macro ncolor(color, buffer, block)
    ex = quote
        $color >= 0 && wattron($buffer, $color)
        $block
        $color >= 0 && wattroff($buffer, $color)
    end

    return esc(ex)
end
