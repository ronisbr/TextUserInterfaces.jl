# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains the definitions of the types.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export tui

include("./abstract.jl")
include("./colors.jl")
include("./logger.jl")
include("./objects.jl")
include("./windows.jl")
include("./widgets.jl")

@with_kw mutable struct TUI
    init::Bool = false

    # Windows
    # ==========================================================================
    stdscr::Ptr{WINDOW} = Ptr{WINDOW}(0)
    wins::Vector{Window}  = Window[]

    # Colors
    # ==========================================================================
    initialized_color_pairs::Vector{Tuple{Int,Int}} = Tuple{Int,Int}[]

    # Focus manager
    # ==========================================================================
    focus_chain::Vector{Window} = Vector{Window}[]
    focus_win::Union{Nothing,Window} = nothing
    focus_id::Int = 0
end

# Global instance to store the TUI configurations.
const tui = TUI()

"""
    struct Keystorke

Structure that defines a keystroke.

# Fields

- `raw::Int32`: Raw value of the keystroke.
- `value::String`: String representing the keystroke.
- `ktype::Symbol`: Type of the key (`:char`, `:F1`, `:up`, etc.).
- `alt::Bool`: `true` if ALT key was pressed (only valid if `ktype != :char`).
- `ctrl::Bool`: `true` if CTRL key was pressed (only valid if `ktype != :char`).
- `shift::Bool`: `true` if SHIFT key was pressed (only valid if `ktype != :char`).
"""
@with_kw struct Keystroke
    raw::Int32 = 0
    value::String
    ktype::Symbol
    alt::Bool   = false
    ctrl::Bool  = false
    shift::Bool = false
end
