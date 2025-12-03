## Description #############################################################################
#
# This file contains functions related to the style support.
#
############################################################################################

export add_attribute, tui_style, get_color_pair, init_color_pair

"""
    add_attribute(style::NCursesStyle, attr::Int) -> NCursesStyle

Add the attribute `attr` to the given `style` and return the new style.
"""
function add_attribute(style::NCursesStyle, attr::Integer)
    new_style = NCursesStyle(style.attrs | attr, style.color_pair)
    return new_style
end

"""
    tui_style([foreground, background,]; kwargs...) -> NCursesStyle

Return an object that describe a style to be applied to the printed characters. The style
consists in a `foreground` color, a `background` color, and a set of attributes.

If the `foreground` or `background` is nothing (default), the color will be the same as the
default one.

The colors are specified by a `Colorant` or a `Symbol`. In the latter case, the color is
looked up in the dictionary with the XTerm color names.

# Keywords

- `bold::Boolean`: If `true`, turn on the bold attribute.
    (**Default** = `false`)
- `reversed::Boolean`: If `true`, turn on the reversed attribute.
    (**Default** = `false`)
- `underline::Boolean`: If `true`, turn on the underline attribute.
    (**Default** = `false`)
"""
function tui_style(
    foreground::Union{Colorant, Symbol} = :transparent,
    background::Union{Colorant, Symbol} = :transparent;
    bold::Bool = false,
    reversed::Bool = false,
    underline::Bool = false,
)
    # Get the index related to the selected colors.
    if tui.true_color
        fgid = _convert_colorant_to_24bit_color(foreground)
        bgid = _convert_colorant_to_24bit_color(background)
    else
        fgid = _convert_colorant_to_256_colors(foreground)
        bgid = _convert_colorant_to_256_colors(background)
    end

    # Initialize the color pair.
    idp = init_color_pair(fgid, bgid)

    # Set the attributes.
    attrs  = bold      ? NCurses.A_BOLD      : NCurses.attr_t(0)
    attrs |= reversed  ? NCurses.A_REVERSE   : NCurses.attr_t(0)
    attrs |= underline ? NCurses.A_UNDERLINE : NCurses.attr_t(0)

    return NCursesStyle(attrs, idp)
end

"""
    get_color_pair(foreground::Integer, background::Integer) -> Int

Return the ID of the color pair (`foreground`, `background`), or `nothing` if the color pair
is not initialized.
"""
function get_color_pair(foreground::Integer, background::Integer)
    return findfirst(x -> x == (foreground, background), tui.initialized_color_pairs)
end

"""
    init_color_pair(foreground::Symbol, background::Symbol) -> Int

Initialize the color pair (`foreground`, `background`) and return its ID. If the pair
already exists, just the function just returns its ID.
"""
function init_color_pair(foreground::Integer, background::Integer)
    # Check if the pair already exists.
    aux = get_color_pair(foreground, background)
    aux != nothing && return aux

    # Initialize the color pair.
    idx = length(tui.initialized_color_pairs) + 1
    NCurses.init_extended_pair(idx, foreground, background)
    push!(tui.initialized_color_pairs, (foreground, background))

    return idx
end

"""
    set_background_style!([buffer::Ptr{WINDOW}, ]style::NCursesStyle) -> Nothing

Set the background of the `buffer` to the specified `style`. If `buffer` is omitted, the
standard screen is used.
"""
function set_background_style!(style::NCursesStyle)
    @unpack attrs, color_pair = style

    t = NCurses.cchar_t(attrs, (0, 0, 0, 0, 0), color_pair)
    p = Base.pointer_from_objref(t) |> Ptr{NCurses.cchar_t}
    GC.@preserve t NCurses.bkgrnd(p)

    # INFO: NCurses copies the data from the pointer, so it's safe to free it right after.
    return nothing
end

function set_background_style!(buffer::Ptr{WINDOW}, style::NCursesStyle)
    @unpack attrs, color_pair = style

    t = NCurses.cchar_t(attrs, (0, 0, 0, 0, 0), color_pair)
    p = Base.pointer_from_objref(t) |> Ptr{NCurses.cchar_t}
    GC.@preserve t NCurses.wbkgrnd(buffer, p)

    # INFO: NCurses copies the data from the pointer, so it's safe to free it right after.
    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

function _convert_colorant_to_24bit_color(colorant::Symbol)
    id = get(_XTERM_NAMES, colorant, -1)
    colorant = id == -1 ? nothing : first(_XTERM_COLORS[id + 1])
    return _convert_colorant_to_24bit_color(colorant)
end

_convert_colorant_to_24bit_color(colorant::Nothing) = -1

function _convert_colorant_to_24bit_color(colorant::Colorant)
    return parse(Int, hex(RGB(colorant), :rrggbb); base = 16)
end

function _convert_colorant_to_256_colors(colorant::Symbol)
    id = get(_XTERM_NAMES, colorant, -1)
    ((id == -1) || (id + 1 > length(_XTERM_COLORS))) && return -1
    return last(_XTERM_COLORS[id + 1])
end

function _convert_colorant_to_256_colors(colorant::Colorant)
    _, id = findmin(colordiff.(colorant, first.(_XTERM_COLORS)))
    return last(_XTERM_COLORS[id])
end

_convert_colorant_to_256_colors(colorant::Nothing) = -1
