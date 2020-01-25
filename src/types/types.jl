# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
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
include("./temp.jl")

@with_kw mutable struct TUI
    init::Bool = false

    # Windows
    # ==========================================================================
    stdscr::Ptr{WINDOW} = Ptr{WINDOW}(0)
    wins::Vector{Window}  = Window[]

    # Colors
    # ==========================================================================
    initialized_colors::Vector{NCURSES_COLOR} =
        NCURSES_COLOR[
            NCURSES_COLOR(:black,   COLOR_BLACK),
            NCURSES_COLOR(:red,     COLOR_RED),
            NCURSES_COLOR(:green,   COLOR_GREEN),
            NCURSES_COLOR(:yellow,  COLOR_YELLOW),
            NCURSES_COLOR(:blue,    COLOR_BLUE),
            NCURSES_COLOR(:magenta, COLOR_MAGENTA),
            NCURSES_COLOR(:cyan,    COLOR_CYAN),
            NCURSES_COLOR(:white,   COLOR_WHITE)
           ]

    initialized_color_pairs::Vector{NCURSES_COLOR_PAIR} =
        NCURSES_COLOR_PAIR[]

    # Focus manager
    # ==========================================================================
    focus_chain::Vector{Window} = Vector{Window}[]
    focus_id::Int = 0

    # Functions to check if a keystroke must change the window.
    wants_next_window::Function     = (k)->return false
    wants_previous_window::Function = (k)->return false
end

# Global instance to store the TUI configurations.
const tui = TUI()

"""
    struct Keystorke

Structure that defines a keystroke.

# Fields

* `value`: String representing the keystroke.
* `ktype`: Type of the key (`:char`, `:F1`, `:up`, etc.).
* `alt`: `true` if ALT key was pressed (only valid if `ktype != :char`).
* `ctrl`: `true` if CTRL key was pressed (only valid if `ktype != :char`).
* `shift`: `true` if SHIFT key was pressed (only valid if `ktype != :char`).

"""
@with_kw struct Keystroke
    raw::Int32 = 0
    value::String
    ktype::Symbol
    alt::Bool   = false
    ctrl::Bool  = false
    shift::Bool = false
end
