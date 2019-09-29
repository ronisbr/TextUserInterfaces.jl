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

    NCURSES_REENTRANT::Bool  = false

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

@with_kw mutable struct TUI_WINDOW
    id::String = ""
    title::String = ""
    coord::Tuple{Int,Int} = (0,0)

    # Parent window.
    parent::Union{Nothing,TUI_WINDOW} = nothing

    # If the user wants a border, then a window will be created to handle this
    # border and the view will be a child window of it. In this case, this
    # variable is a pointer to the window that holds the border.
    border::Ptr{WINDOW} = Ptr{WINDOW}(0)

    # This is a pointer to the window that must handler the child elements. This
    # can change whether the user wants a buffer or not.
    ptr::Ptr{WINDOW} = Ptr{WINDOW}(0)

    # Foremost element of the window, which can be the border or the view.
    foremost::Ptr{WINDOW} = Ptr{WINDOW}(0)

    # List of children elements.
    children::Vector{Any} = Any[]

    # Buffer
    # ==========================================================================

    # Pointer to the window (pad) that handles the buffer.
    buffer::Ptr{WINDOW} = Ptr{WINDOW}(0)

    # If `true`, then the buffer has changed, which requires a view update.
    buffer_changed::Bool = true

    # View
    # ==========================================================================

    # Pointer to the window view, which is the window that is actually draw on
    # screen.
    view::Ptr{WINDOW} = Ptr{WINDOW}(0)

    # Origin of the view window with respect to the physical screen. This is
    # useful for setting the cursor position when required.
    orig::Tuple{Int,Int} = (0,0)

    # If `true`, then the view has changed and must be updated.
    view_needs_update::Bool = true

    # Panel
    # ==========================================================================

    # Panel that holds the foremost visible element of the windows, which can be
    # the panel that holds the border or the view.
    panel::Ptr{Cvoid} = Ptr{Cvoid}(0)

    # Panel of the border.
    panel_border::Ptr{Cvoid} = Ptr{Cvoid}(0)

    # Panel of the view.
    panel_view::Ptr{Cvoid} = Ptr{Cvoid}(0)

    # Focus manager
    # ==========================================================================
    has_focus::Bool = false
    focus_id::Int = 1
    focus_ptr::Any = nothing

    # Signals
    # ==========================================================================
    on_focus_acquired::Function = (win)->return nothing
    on_focus_released::Function = (win)->return nothing
end

@with_kw mutable struct TUI_FORM
    fields::Vector{TUI_FIELD}      = Vector{TUI_FIELD}(undef,0)
    ptr_fields::Vector{Ptr{Cvoid}} = Vector{Ptr{Cvoid}}(undef,0)
    ptr::Ptr{Cvoid}                = Ptr{Cvoid}(0)
    win::Union{Nothing,TUI_WINDOW} = nothing

    # Focus manager
    # ==========================================================================
    has_focus::Bool = false

    # Signals
    # ==========================================================================
    on_return_pressed::Function = (form)->return nothing
end

@with_kw mutable struct TUI_MENU
    names::Vector{String}          = String[]
    descriptions::Vector{String}   = String[]
    items::Vector{Ptr{Cvoid}}      = Vector{Ptr{Cvoid}}(undef,0)
    ptr::Ptr{Cvoid}                = Ptr{Cvoid}(0)
    win::Union{Nothing,TUI_WINDOW} = nothing

    # Focus manager
    # ==========================================================================
    has_focus::Bool = false

    # Signals
    # ==========================================================================
    on_return_pressed::Function = (form)->return nothing
end

@with_kw mutable struct TUI
    init::Bool = false

    # Windows
    # ==========================================================================
    wins::Vector{TUI_WINDOW}  = TUI_WINDOW[]

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
    focus_chain::Vector{TUI_WINDOW} = Vector{TUI_WINDOW}[]
    focus_id::Int = 1
    focus_ptr::Union{Nothing,TUI_WINDOW} = nothing
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

