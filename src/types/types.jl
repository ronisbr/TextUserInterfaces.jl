## Description #############################################################################
#
# This file contains the definitions of types and structures.
#
############################################################################################

include("./abstract.jl")
include("./colors.jl")
include("./input.jl")
include("./logger.jl")
include("./objects.jl")
include("./themes.jl")
include("./signals.jl")
include("./widgets.jl")
include("./windows.jl")

@kwdef mutable struct TextUserInterface
    initialized::Bool = false

    # == Windows ===========================================================================

    stdscr::Ptr{WINDOW} = Ptr{WINDOW}(0)
    windows::Vector{Window} = Window[]

    # -- Focus Manager ---------------------------------------------------------------------

    focused_window_id::Int = 0

    # == Colors ============================================================================

    initialized_color_pairs::Vector{Tuple{Int, Int}} = Tuple{Int, Int}[]

    # == Default Theme =====================================================================

    default_theme::Theme = Theme()

    # == Signals ===========================================================================

    @signal keypressed

    # == Private variables =================================================================

    # Internal variable to obtain an unique object ID.
    _num_of_created_objects::Int = 0
end
