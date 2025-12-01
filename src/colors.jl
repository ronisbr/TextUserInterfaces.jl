## Description #############################################################################
#
# This file contains functions related to the color support.
#
############################################################################################

export ncurses_color, get_color_pair, modify_color, init_color_pair, set_color
export unset_color

"""
    ncurses_color([foreground, background,] attrs::Integer = 0; kwargs...) -> Int

Return a mask to apply a color format with the foreground color `foreground`, background
color `background`, and the attributes `attrs`.

If the pair (`foreground`, `background`) is omitted, then the foreground and background
color will not be changed.

The colors can be specified by their names using `Symbol` or by their indices using `Int`.

# Keywords

- `bold::Boolean`: If `true`, then apply bold format mask to `attrs`.
    (**Default** = `false`)
- `underline::Boolean`: If `true`, then apply underline format mask to `attrs`.
    (**Default** = `false`)
"""
function ncurses_color(
    foreground::Symbol,
    background::Symbol,
    attrs::Integer = 0;
    kwargs...
)
    # Get the index related to the selected colors.
    foreground_id = _get_color_index(foreground)
    background_id = _get_color_index(background)

    return ncurses_color(foreground_id, background_id, attrs; kwargs...)
end

function ncurses_color(
    foreground::Symbol,
    background::Integer,
    attrs::Integer = 0;
    kwargs...
)
    # Get the index related to the selected colors.
    foreground_id = _get_color_index(foreground)
    return ncurses_color(foreground_id, background, attrs; kwargs...)
end

function ncurses_color(
    foreground::Integer,
    background::Symbol,
    attrs::Integer = 0;
    kwargs...
)
    # Get the index related to the selected colors.
    background_id = _get_color_index(background)
    return ncurses_color(foreground, background_id, attrs; kwargs...)
end

function ncurses_color(
    foreground::Integer,
    background::Integer,
    attrs::Integer = 0;
    kwargs...
)
    idp = init_color_pair(foreground, background)
    return ncurses_color(COLOR_PAIR(idp) | attrs; kwargs...)
end

function ncurses_color(
    attrs::Integer = 0;
    bold::Bool = false,
    reversed::Bool = false,
    underline::Bool = false
)
    attrs |= bold ? A_BOLD : 0
    attrs |= reversed ? A_REVERSE : 0
    attrs |= underline ? A_UNDERLINE : 0
    return signed(attrs)
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
    foreground_id = _get_color_index(foreground)
    background_id = _get_color_index(background)
    return init_color_pair(foreground_id, background_id)
end

function init_color_pair(foreground::Symbol, background::Integer)
    # Get the index related to the selected colors.
    foreground_id = _get_color_index(foreground)
    return init_color_pair(foreground_id, background)
end

function init_color_pair(foreground::Integer, background::Symbol)
    # Get the index related to the selected colors.
    background_id = _get_color_index(background)
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

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _get_color_index(color::Symbol) -> Int

Return the index related to the `color`.
"""
function _get_color_index(color::Symbol)
    return get(_XTERM_COLORS, color, 0)
end