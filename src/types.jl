# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Description
#
#   This file contains the definitions of the types.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

################################################################################
#                                   NCurses
################################################################################

"""
    struct NCURSES

This private structure handles some global variables that are used in the
ncurses wrapper.

"""
mutable struct NCURSES
    libncurses::Ptr{Nothing}
    libform::Ptr{Nothing}
    libmenu::Ptr{Nothing}
    libpanel::Ptr{Nothing}
    LINES::Ptr{Cint}
    COLS::Ptr{Cint}
    acs_map::Ptr{Cuint}
    acs_map_arr::Vector{UInt32}
end

const ncurses = NCURSES(Ptr{Nothing}(0), Ptr{Nothing}(0), Ptr{Nothing}(0),
                        Ptr{Nothing}(0), Ptr{Cint}(0), Ptr{Cint}(0),
                        Ptr{Cuint}(0), UInt32[])

include("./ncurses/ncurses_types.jl")
include("./ncurses/ncurses_attributes.jl")
include("./ncurses/form_types.jl")
include("./ncurses/menu_types.jl")
include("./ncurses/panel_types.jl")

################################################################################
#                                     API
################################################################################

struct NCURSES_COLOR
    name::Symbol
    id::Int
end

struct NCURSES_COLOR_PAIR
    foreground::Symbol
    background::Symbol
end

@with_kw mutable struct TUI_MENU
    names::Vector{String}        = String[]
    descriptions::Vector{String} = String[]
    items::Vector{Ptr{Cvoid}}    = Vector{Ptr{Cvoid}}(undef,0)
    ptr::Ptr{Cvoid}              = Ptr{Cvoid}(0)
end

@with_kw mutable struct TUI_WINDOW
    id::String = ""
    parent::Union{Nothing,TUI_WINDOW} = nothing
    border::Ptr{WINDOW} = Ptr{WINDOW}(0)
    title::String = ""
    ptr::Ptr{WINDOW} = Ptr{WINDOW}(0)
end

@with_kw mutable struct TUI_PANEL
    ptr::Ptr{Cvoid}
    ptr_border::Ptr{Cvoid} = Ptr{Cvoid}(0)
    win::TUI_WINDOW
    next::Union{Nothing,TUI_PANEL} = nothing
    prev::Union{Nothing,TUI_PANEL} = nothing
end

@with_kw mutable struct TUI
    init::Bool = false

    # Windows
    # ==========================================================================
    wins::Vector{TUI_WINDOW}  = TUI_WINDOW[]

    # Panels
    # ==========================================================================
    panels::Vector{TUI_PANEL} = TUI_PANEL[]
    top_panel::Union{Nothing,TUI_PANEL} = nothing

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
end
