# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Description
#
#   This file contains functions related to the color support.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export ncurses_color, get_color_pair, init_color, init_color_pair, set_color,
       unset_color

"""
    function ncurses_color([foreground::Symbol, background::Symbol,] attrs::Int = 0; kwargs...)

Return a mask to apply a color format with the foreground color `foreground`,
background color `background`, and the attributes `attrs`.

If the pair (`foreground`, `background`) is omitted, then the foreground and
background color will not be changed.

# Keywords

* `bold`: If `true`, then apply bold format mask to `attrs`.
          (**Default** = `false`)
* `underline`: If `true`, then apply underline format mask to `attrs`.
               (**Default** = `false`)

"""
function ncurses_color(foreground::Symbol, background::Symbol, attrs::Int = 0;
                       kwargs...)

    idp = init_color_pair(foreground, background)

    return ncurses_color(COLOR_PAIR(idp) | attrs; kwargs...)
end

function ncurses_color(attrs::Int = 0;
                       bold::Bool = false, underline::Bool = false)

    attrs |= bold ? A_BOLD : 0
    attrs |= underline ? A_UNDERLINE : 0

    return attrs
end

"""
    function get_color_pair(foreground::Symbol, background::Symbol)

Return the ID of the color pair (`foreground`, `background`), or `nothing` if
the color pair is not initialized.

"""
function get_color_pair(foreground::Symbol, background::Symbol)
    findfirst(x -> (x.foreground == foreground) && (x.background == background),
              tui.initialized_color_pairs)
end

"""
    function init_color(name::Symbol, r::Int, g::Int, b::Int)

Initialize the color with name `name` and RGB color `r`, `g`, and `b`.  Notice
that the range for the last three variables is `[0,1000]`.

If the color is already initialized, then nothing will be changed.

If the color was initialized, then it returns the color ID. Otherwise, it
returns `-1`.

"""
function init_color(name::Symbol, r::Int, g::Int, b::Int)
    aux  = findfirst(x -> x.name == name, tui.initialized_colors)

    aux != nothing && return -1

    idc = tui.initialized_colors[end].id + 1

    if init_color(idc, r, g, b) == 0
        push!(tui.initialized_colors, NCURSES_COLOR(name,idc))
        return idc
    end

    return -1
end

"""
    function init_color_pair(foreground::Symbol, background::Symbol)

Initialize the color pair (`foreground`, `background`) and return its ID. If the
pair already exists, then just the function just returns its ID.

"""
function init_color_pair(foreground::Symbol, background::Symbol)
    # Check if the pair already exists.
    aux = get_color_pair(foreground, background)
    aux != nothing && return aux

    # Find foreground color ID.
    idf = findfirst(x -> x.name == foreground, tui.initialized_colors)
    idf == nothing && error("Color `$foreground` was not initialized.")
    f_color = tui.initialized_colors[idf].id

    # Find background color ID.
    idb = findfirst(x -> x.name == background, tui.initialized_colors)
    idb == nothing && error("Color `$background` was not initialized.")
    b_color = tui.initialized_colors[idb].id

    # Initialize the color pair.
    idx = length(tui.initialized_color_pairs) + 1
    init_pair(idx, f_color, b_color)
    push!(tui.initialized_color_pairs, NCURSES_COLOR_PAIR(foreground, background))

    return idx
end

"""
    function set_color([win::Window,] color::Int)

Set the color of the window `win` to `color` (see `ncurses_color`). If `win` is
omitted, then it defaults to the root window.

"""
set_color(color::Int) = set_color(tui.wins[1], color)

function set_color(win::Window, color::Int)
    win.ptr != C_NULL && wattron(win.ptr, color)
    return nothing
end

"""
    function unset_color([win::Window,] color::Number)

Unset the color `color` (see `ncurses_color`) in the window `win`. If `win` is
omitted, then it defaults to the root window.

"""
unset_color(color::Int) = unset_color(tui.wins[1], color)

function unset_color(win::Window, color::Int)
    win.ptr != C_NULL && wattroff(win.ptr, color)
    return nothing
end
