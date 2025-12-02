## Description #############################################################################
#
# This file contains functions related to the themes.
#
############################################################################################

export get_style, set_default_theme_style!, set_ncurses_default_colors

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    get_style(theme::Theme, key::Symbol) -> Int

Get the style associated with `key` in the `theme`. If the `key` does not exist in `theme`,
the style from the TUI default theme is returned.
"""
function get_style(theme::Theme, key::Symbol)
    dt = tui.default_theme
    !haskey(theme, key) && return get(dt, key, get(dt, :default, 0))
    return theme[key]
end

"""
    set_default_theme_style!(key::Symbol, style::Int) -> Nothing

Set the style associated with `key` in the TUI default theme to `style`.
"""
function set_default_theme_style!(key::Symbol, style::Int)
    tui.default_theme[key] = style
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
    theme[:default]   = tui_style(:white)
    theme[:error]     = tui_style(:red)
    theme[:highlight] = tui_style(; reversed = true)
    theme[:selected]  = tui_style(:yellow)
    theme[:border]    = tui_style(:white)
    theme[:title]     = tui_style(:white; bold = true)

    return nothing
end
