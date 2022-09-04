# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains the definitions of types and structures.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

include("./colors.jl")
include("./logger.jl")
include("./themes.jl")
include("./windows.jl")

@with_kw mutable struct TextUserInterface
    initialized::Bool = false

    # Windows
    # ==========================================================================
    stdscr::Ptr{WINDOW} = Ptr{WINDOW}(0)

    # Colors
    # ==========================================================================
    initialized_color_pair::Vector{Tuple{Int, Int}} = Tuple{Int, Int}[]

    # Default theme
    # ==========================================================================

    default_theme::Theme = Theme()
end
