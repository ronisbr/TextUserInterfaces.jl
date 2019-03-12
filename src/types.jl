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
@with_kw mutable struct NCURSES
    libncurses::Ptr{Nothing} = Ptr{Nothing}(0)
    libform::Ptr{Nothing}    = Ptr{Nothing}(0)
    libmenu::Ptr{Nothing}    = Ptr{Nothing}(0)
    libpanel::Ptr{Nothing}   = Ptr{Nothing}(0)

    # libncurses global symbols
    # ==========================================================================

    LINES::Ptr{Cint}            = Ptr{Cint}(0)
    COLS::Ptr{Cint}             = Ptr{Cint}(0)
    acs_map::Ptr{Cuint}         = Ptr{Cuint}(0)
    acs_map_arr::Vector{UInt32} = UInt32[]

    # libforms global symbols
    # ==========================================================================

    TYPE_ALNUM::Ptr{Nothing}   = Ptr{Nothing}(0)
    TYPE_ALPHA::Ptr{Nothing}   = Ptr{Nothing}(0)
    TYPE_ENUM::Ptr{Nothing}    = Ptr{Nothing}(0)
    TYPE_INTEGER::Ptr{Nothing} = Ptr{Nothing}(0)
    TYPE_NUMERIC::Ptr{Nothing} = Ptr{Nothing}(0)
    TYPE_REGEXP::Ptr{Nothing}  = Ptr{Nothing}(0)
    TYPE_IPV4::Ptr{Nothing}    = Ptr{Nothing}(0)
    TYPE_IPV6::Ptr{Nothing}    = Ptr{Nothing}(0)

end

const ncurses = NCURSES()

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

@with_kw mutable struct TUI_FIELD
    id::String
    ptr::Ptr{Cvoid}       = Ptr{Cvoid}(0)

    # Field properties.
    height::Int           = 0
    width::Int            = 0
    y::Int                = 0
    x::Int                = 0
    buffer::String        = ""
    offscreen::Int        = 0
    nbuffers::Int         = 0
    color_foreground::Int = -1
    color_background::Int = -1
    justification::Symbol = :l
    visible::Bool         = true
    active::Bool          = true
    public::Bool          = true
    edit::Bool            = true
    wrap::Bool            = true
    blank::Bool           = false
    autoskip::Bool        = false
    nullok::Bool          = true
    passok::Bool          = false
    static::Bool          = true

    # Store the pointer if the field type is `TYPE_ENUM` to avoid deallocation
    # by the GC.
    penum::Vector{Cstring} = Cstring[]
end

@with_kw mutable struct TUI_FORM
    fields::Vector{TUI_FIELD}      = Vector{TUI_FIELD}(undef,0)
    ptr_fields::Vector{Ptr{Cvoid}} = Vector{Ptr{Cvoid}}(undef,0)
    ptr::Ptr{Cvoid}                = Ptr{Cvoid}(0)
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
    value::String
    ktype::Symbol
    alt::Bool   = false
    ctrl::Bool  = false
    shift::Bool = false
end

