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

"""
    mutable struct TextUserInterface

Main structure that defines a text user interface.

# Fields

- `initialized::Bool`: If `true`, then the TUI is initialized.
    (**Default** = `false`)
- `stdscr::Ptr{WINDOW}`: Pointer to the standard NCurses window.
    (**Default** = `Ptr{WINDOW}(0)`)
- `windows::Vector{Window}`: Vector that contains all created windows.
    (**Default** = `Window[]`)
- `focused_window_id::Int`: ID of the focused window.
    (**Default** = `0`)
- `initialized_color_pairs::Vector{Tuple{Int, Int}}`: Vector that contains all initialized
    color pairs.
    (**Default** = `Tuple{Int, Int}[]`)
- `default_theme::Theme`: Default theme of the TUI.
    (**Default** = `Theme()`)

# Signals

- `keypressed`: Emitted when a key is pressed.
"""
@kwdef mutable struct TextUserInterface
    initialized::Bool = false

    # == Windows ===========================================================================

    stdscr::Ptr{WINDOW} = Ptr{WINDOW}(0)
    windows::Vector{Window} = Window[]

    # -- Focus Manager ---------------------------------------------------------------------

    focused_window_id::Int = 0

    # == Colors ============================================================================

    true_color::Bool = false
    initialized_color_pairs::Vector{Tuple{Int, Int}} = Tuple{Int, Int}[]

    # == Default Theme =====================================================================

    default_theme::Theme = Theme()

    # == Signals ===========================================================================

    @signal keypressed

    # == Private variables =================================================================

    # Internal variable to obtain an unique object ID.
    _num_of_created_objects::Int = 0
end
