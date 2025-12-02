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
        cp_ref     = Ref{Cint}(color_pair)
        cp_pointer = color_pair >= 0 ? Base.pointer_from_objref(cp_ref) : C_NULL

        GC.@preserve cp_ref NCurses.wattr_set($buffer, attrs, 0, cp_pointer)
        $block
        NCurses.wattr_set($buffer, 0, 0, C_NULL)
    end

    return esc(ex)
end
