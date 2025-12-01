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

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _fill_with_default_theme!(theme::Theme) -> Nothing

Fill `theme` with the default theme values.
"""
function _fill_with_default_theme!(theme)
    theme[:default]   = ncurses_color(:white, :black)
    theme[:error]     = ncurses_color(:red, :black)
    theme[:highlight] = ncurses_color(; reversed = true)
    theme[:selected]  = ncurses_color(:yellow, :black)
    theme[:border]    = ncurses_color(:white, :black)
    theme[:title]     = ncurses_color(:white, :black; bold = true)

    return nothing
end
