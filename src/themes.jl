## Description #############################################################################
#
# This file contains functions related to the themes.
#
############################################################################################

export get_color, set_default_theme_color!

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    get_color(theme::Theme, key::Symbol) -> Int

Get the color associated with `key` in the `theme`. If the `key` does not exist in `theme`,
the color from the TUI default theme is returned.
"""
function get_color(theme::Theme, key::Symbol)
    dt = tui.default_theme
    !haskey(theme, key) && return get(dt, key, get(dt, :default, 0))
    return theme[key]
end

"""
    set_default_theme_color!(key::Symbol, color::Int) -> Nothing

Set the color associated with `key` in the TUI default theme to `color`.
"""
function set_default_theme_color!(key::Symbol, color::Int)
    tui.default_theme[key] = color
    key == :default && set_window_theme!(tui.default_theme)
    return nothing
end

"""
    set_ncurses_default_colors(foreground::Union{Int, Symbol}, background::Union{Int, Symbol}) -> Nothing

Set the default ncurses colors to `foreground` and `background`. The arguments can be either
the symbol specifying the color or the color index.
"""
function set_ncurses_default_colors(foreground::Symbol, background::Symbol)
    # Get the index related to the selected colors.
    foreground_id = _get_color_index(foreground)
    background_id = _get_color_index(background)

    return set_ncurses_default_colors(foreground_id, background_id)
end

function set_ncurses_default_colors(foreground::Integer, background::Symbol)
    background_id = _get_color_index(background)
    return set_ncurses_default_colors(foreground, background_id)
end

function set_ncurses_default_colors(foreground::Symbol, background::Integer)
    foreground_id = _get_color_index(foreground)
    return set_ncurses_default_colors(foreground_id, background)
end

function set_ncurses_default_colors(foreground::Integer, background::Integer)
    NCurses.assume_default_colors(foreground, background)
    tui_update(force = true)
    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _fill_with_default_theme!(theme::Theme) -> Nothing

Fill `theme` with the default theme values.
"""
function _fill_with_default_theme!(theme)
    theme[:default]   = ncurses_color(:white, -1)
    theme[:error]     = ncurses_color(:red, -1)
    theme[:highlight] = ncurses_color(; reversed = true)
    theme[:selected]  = ncurses_color(:yellow, -1)
    theme[:border]    = ncurses_color(:white, -1)
    theme[:title]     = ncurses_color(:white, -1; bold = true)

    return nothing
end
