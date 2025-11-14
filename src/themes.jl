## Description #############################################################################
#
# This file contains functions related to the themes.
#
############################################################################################

export create_theme

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    create_theme(; kwargs...)

Create a new theme using the default values but replacing the ones in the keywords
`kwargs...`. The latter can be any field name available in [`Theme`](@ref).
"""
function create_theme(;
    default   = tui.default_theme.default,
    error     = tui.default_theme.error,
    highlight = tui.default_theme.highlight,
    selected  = tui.default_theme.selected,
    border    = tui.default_theme.border,
    title     = tui.default_theme.title,
)
    return Theme(;
        default,
        error,
        highlight,
        selected,
        border,
        title,
    )
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _create_default_theme() -> Nothing

Create the default theme.
"""
function _create_default_theme()
    default   = ncurses_color(:white, :black)
    error     = ncurses_color(:red, 0)
    highlight = ncurses_color(A_REVERSE)
    selected  = ncurses_color(:yellow, 0)
    border    = default
    title     = default

    return Theme(;
        default,
        error,
        highlight,
        selected,
        border,
        title,
    )
end
