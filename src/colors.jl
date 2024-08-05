## Description #############################################################################
#
# This file contains functions related to the color support.
#
############################################################################################

import .NCurses: init_color
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
    background::Int,
    attrs::Integer = 0;
    kwargs...
)
    # Get the index related to the selected colors.
    foreground_id = _get_color_index(foreground)
    return ncurses_color(foreground_id, background, attrs; kwargs...)
end

function ncurses_color(
    foreground::Int,
    background::Symbol,
    attrs::Integer = 0;
    kwargs...
)
    # Get the index related to the selected colors.
    background_id = _get_color_index(background)
    return ncurses_color(foreground, background_id, attrs; kwargs...)
end

function ncurses_color(
    foreground::Int,
    background::Int,
    attrs::Integer = 0;
    kwargs...
)
    idp = init_color_pair(foreground, background)
    return ncurses_color(COLOR_PAIR(idp) | attrs; kwargs...)
end

function ncurses_color(
    attrs::Integer = 0;
    bold::Bool = false,
    underline::Bool = false
)
    attrs |= bold ? A_BOLD : 0
    attrs |= underline ? A_UNDERLINE : 0
    return signed(attrs)
end

"""
    get_color_pair(foreground::Int, background::Int) -> Int

Return the ID of the color pair (`foreground`, `background`), or `nothing` if the color pair
is not initialized.
"""
function get_color_pair(foreground::Int, background::Int)
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

function init_color_pair(foreground::Symbol, background::Int)
    # Get the index related to the selected colors.
    foreground_id = _get_color_index(foreground)
    return init_color_pair(foreground_id, background)
end

function init_color_pair(foreground::Int, background::Symbol)
    # Get the index related to the selected colors.
    background_id = _get_color_index(background)
    return init_color_pair(foreground, background_id)
end

function init_color_pair(foreground::Int, background::Int)
    # Check if the pair already exists.
    aux = get_color_pair(foreground, background)
    aux != nothing && return aux

    # Initialize the color pair.
    idx = length(tui.initialized_color_pairs) + 1
    NCurses.init_pair(idx, foreground, background)
    push!(tui.initialized_color_pairs, (foreground, background))

    return idx
end

"""
    modify_color([name::Symbol, ]id::Int, r::Int, g::Int, b::Int) -> Int

Modify the color ID `id` to the RGB value (`r`,`g`,`b`). If the symbol `name` is available,
the user can select this color ID by using `name` instead of the `id`.

If the color name `name` already exists, then nothing will be changed.

Notice that the range for the RGB color components is `[0, 1000]`.

If the color was initialized, it returns the color ID. Otherwise, it returns `-1`.
"""
function modify_color(name::Symbol, id::Int, r::Int, g::Int, b::Int)
    # If the color name is defined, then just return.
    if haskey(_ncurses_colors, name)
        return -1
    end

    if modify_color(id, r, g, b) != -1
        push!(_ncurses_colors, name => id)
        return id
    end

    return -1
end

function modify_color(id::Int, r::Int, g::Int, b::Int)
    if NCurses.can_change_color() == 1
        return init_color(id, r, g, b) == 0 ? id : -1
    end

    @log warning "modify_color" "The terminal does not support color change."
    return -1
end

"""
    set_color([win::Window,] color::Int) -> Nothing

Set the color of the window `win` to `color` (see `ncurses_color`). If `win` is omitted,
it defaults to the root window.
"""
set_color(color::Int) = set_color(tui.wins[1], color)

function set_color(win::Window, color::Int)
    win.ptr != C_NULL && NCurses.wattron(win.ptr, color)
    return nothing
end

"""
    unset_color([win::Window,] color::Number) -> Nothing

Unset the color `color` (see `ncurses_color`) in the window `win`. If `win` is omitted, it
defaults to the root window.
"""
unset_color(color::Int) = unset_color(tui.wins[1], color)

function unset_color(win::Window, color::Int)
    win.ptr != C_NULL && NCurses.wattroff(win.ptr, color)
    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

# Return the index related to the color `color`.
function _get_color_index(color::Symbol)
    if haskey(_ncurses_colors, color)
        return _ncurses_colors[color]
    else
        error("Unknown color :$color.")
    end
end

# Reset the color dictionary.
function _reset_color_dict()
    empty!(_ncurses_colors)
    merge!(_ncurses_colors, _default_ncurses_colors)
    return nothing
end
