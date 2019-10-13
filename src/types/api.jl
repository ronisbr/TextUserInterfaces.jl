# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Description
#
#   Types related to TextUserInterfaces API.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export Window, Widget, WidgetCommon, WidgetParent, tui

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

@with_kw mutable struct Window
    id::String = ""
    title::String = ""
    coord::Tuple{Int,Int} = (0,0)
    has_border::Bool = false

    # List of widgets.
    widgets::Vector{Any} = Any[]

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

    # Panel of the window.
    panel::Ptr{Cvoid} = Ptr{Cvoid}(0)

    # Focus manager
    # ==========================================================================

    # Indicate if the window can have focus.
    focusable::Bool = true

    # Widget ID that has the focus.
    focus_id::Int = 0

    # Signals
    # ==========================================================================
    on_focus_acquired::Function = (win)->return nothing
    on_focus_released::Function = (win)->return nothing
end

@with_kw mutable struct TUI_FORM
    fields::Vector{TUI_FIELD}      = Vector{TUI_FIELD}(undef,0)
    ptr_fields::Vector{Ptr{Cvoid}} = Vector{Ptr{Cvoid}}(undef,0)
    ptr::Ptr{Cvoid}                = Ptr{Cvoid}(0)
    win::Union{Nothing,Window} = nothing

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
    win::Union{Nothing,Window} = nothing

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

# Abstract type for all widgets.
abstract type Widget end

# Types that can be parent of widgets.
WidgetParent = Union{Window,Widget}

# Common configurations for all widgets.
@with_kw mutable struct WidgetCommon
    parent::WidgetParent
    buffer::Ptr{WINDOW} = Ptr{WINDOW}(0)

    top::Number
    left::Number
    height::Number
    width::Number
    hsize_policy::Symbol
    vsize_policy::Symbol

    update_needed::Bool = true
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
    raw::Int32 = 0
    value::String
    ktype::Symbol
    alt::Bool   = false
    ctrl::Bool  = false
    shift::Bool = false
end
