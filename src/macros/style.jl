## Description #############################################################################
#
# This file contains macros related to the colors.
#
############################################################################################

export nstyle

"""
    @nstyle(style, buffer, block)

Apply the `style` to the `buffer` while executing the `block`. After the block is executed,
the default style is restored.
"""
macro nstyle(style, buffer, block)
    ex = quote
        color_pair = $style.color_pair
        attrs      = $style.attrs

        color_pair >= 0 && NCurses.wcolor_set($buffer, color_pair, C_NULL)
        NCurses.wattr_on($buffer, attrs, C_NULL)
        $block
        NCurses.wattr_off($buffer, attrs, C_NULL)
        color_pair >= 0 && NCurses.wcolor_set($buffer, 0, C_NULL)
    end

    return esc(ex)
end
