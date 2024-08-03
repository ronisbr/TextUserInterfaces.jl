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
function create_theme(; kwargs...)
    return Theme(tui.default_theme; kwargs...)
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

# Create the default theme.
function _create_default_theme()
    default   = ncurses_color(:white, :black)
    error     = ncurses_color(:red, 0)
    highlight = ncurses_color(A_REVERSE)
    selected  = ncurses_color(:yellow, 0)
    border    = default
    title     = default

    return Theme(
        ;
        default,
        error,
        highlight,
        selected,
        border,
        title,
    )
end
