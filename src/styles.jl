## Description #############################################################################
#
# This file contains functions related to the style support.
#
############################################################################################

export add_attribute, ncurses_style, get_color_pair, init_color_pair

"""
    add_attribute(style::NCursesStyle, attr::Int) -> NCursesStyle

Add the attribute `attr` to the given `style` and return the new style.
"""
function add_attribute(style::NCursesStyle, attr::Integer)
    new_style = NCursesStyle(style.attrs | attr, style.color_pair)
    return new_style
end

"""
    ncurses_style([foreground, background,]; kwargs...) -> NCursesStyle

Return an object that describe a style to be applied to the printed characters. The style
consists in a `foreground` color, a `background` color, and a set of attributes.

If the pair (`foreground`, `background`) is omitted, the foreground and background color
will not be changed.

The colors can be specified by their names using `Symbol` or by their indices using `Int`.

# Keywords

- `bold::Boolean`: If `true`, turn on the bold attribute.
    (**Default** = `false`)
- `reversed::Boolean`: If `true`, turn on the reversed attribute.
    (**Default** = `false`)
- `underline::Boolean`: If `true`, turn on the underline attribute.
    (**Default** = `false`)
"""
function ncurses_style(foreground::Symbol, background::Symbol; kwargs...)
    # Get the index related to the selected colors.
    foreground_id = _get_xterm_color_index(foreground)
    background_id = _get_xterm_color_index(background)

    return ncurses_style(foreground_id, background_id; kwargs...)
end

function ncurses_style(foreground::Symbol, background::Integer; kwargs...)
    # Get the index related to the selected colors.
    foreground_id = _get_xterm_color_index(foreground)
    return ncurses_style(foreground_id, background; kwargs...)
end

function ncurses_style(foreground::Integer, background::Symbol; kwargs...)
    # Get the index related to the selected colors.
    background_id = _get_xterm_color_index(background)
    return ncurses_style(foreground, background_id; kwargs...)
end

function ncurses_style(foreground::Integer, background::Integer; kwargs...)
    idp   = init_color_pair(foreground, background)
    attrs = ncurses_style(; kwargs...).attrs
    return NCursesStyle(attrs, idp)
end

function ncurses_style(; bold::Bool = false, reversed::Bool = false, underline::Bool = false)
    attrs  = bold      ? NCurses.A_BOLD      : 0
    attrs |= reversed  ? NCurses.A_REVERSE   : 0
    attrs |= underline ? NCurses.A_UNDERLINE : 0

    return NCursesStyle(attrs, -1)
end

"""
    get_color_pair(foreground::Integer, background::Integer) -> Int

Return the ID of the color pair (`foreground`, `background`), or `nothing` if the color pair
is not initialized.
"""
function get_color_pair(foreground::Integer, background::Integer)
    return findfirst(
        x -> x == (foreground, background),
        tui.initialized_color_pairs
    )
end

"""
    init_color_pair(foreground::Symbol, background::Symbol) -> Int

Initialize the color pair (`foreground`, `background`) and return its ID. If the pair
already exists, just the function just returns its ID.
"""
function init_color_pair(foreground::Symbol, background::Symbol)
    # Get the index related to the selected colors.
    foreground_id = _get_xterm_color_index(foreground)
    background_id = _get_xterm_color_index(background)
    return init_color_pair(foreground_id, background_id)
end

function init_color_pair(foreground::Symbol, background::Integer)
    # Get the index related to the selected colors.
    foreground_id = _get_xterm_color_index(foreground)
    return init_color_pair(foreground_id, background)
end

function init_color_pair(foreground::Integer, background::Symbol)
    # Get the index related to the selected colors.
    background_id = _get_xterm_color_index(background)
    return init_color_pair(foreground, background_id)
end

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
    NCurses.bkgrnd(p)

    # INFO: NCurses copies the data from the pointer, so it's safe to free it right after.
    return nothing
end

function set_background_style!(buffer::Ptr{WINDOW}, style::NCursesStyle)
    @unpack attrs, color_pair = style

    t = NCurses.cchar_t(attrs, (0, 0, 0, 0, 0), color_pair)
    p = Base.pointer_from_objref(t) |> Ptr{NCurses.cchar_t}
    NCurses.wbkgrnd(buffer, p)

    # INFO: NCurses copies the data from the pointer, so it's safe to free it right after.
    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _get_xterm_color_index(color::Symbol) -> Int

Return the Xterm color index related to the `color`.
"""
function _get_xterm_color_index(color::Symbol)
    return get(_XTERM_COLORS, color, 0)
end