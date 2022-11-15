# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains the definitions of types and structures.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

include("./abstract.jl")
include("./colors.jl")
include("./input.jl")
include("./logger.jl")
include("./objects.jl")
include("./themes.jl")
include("./signals.jl")
include("./widgets.jl")
include("./windows.jl")

@with_kw mutable struct TextUserInterface
    initialized::Bool = false

    # Windows
    # ==========================================================================

    stdscr::Ptr{WINDOW} = Ptr{WINDOW}(0)
    windows::Vector{Window} = Window[]

    # Focus manager
    # --------------------------------------------------------------------------

    focused_window_id::Int = 0

    # Colors
    # ==========================================================================

    initialized_color_pairs::Vector{Tuple{Int, Int}} = Tuple{Int, Int}[]

    # Default theme
    # ==========================================================================

    # The default theme must only be initialized after the global `tui`
    # structure is created. Otherwise, it will not be possible to create custom
    # colors since they need the `initialized_color_pair`. Hence, this variable
    # is defined as `nothing`, but changed to the default theme when TUI is
    # initialized.
    default_theme::Union{Nothing, Theme} = nothing

    # Signals
    # ==========================================================================

    @signal keypressed

    # Private variables
    # ============================================================================

    # Internal variable to obtain an unique object ID.
    _num_of_created_objects::Int = 0
end
