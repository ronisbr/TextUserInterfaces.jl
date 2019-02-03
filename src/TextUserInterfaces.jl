module TextUserInterfaces

using Libdl
using LinearAlgebra
using Parameters

################################################################################
#                                    Types
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
include("./ncurses/form_types.jl")
include("./ncurses/menu_types.jl")
include("./ncurses/panel_types.jl")

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
    wins::Vector{TUI_WINDOW}  = TUI_WINDOW[]
    panels::Vector{TUI_PANEL} = TUI_PANEL[]
    top_panel::Union{Nothing,TUI_PANEL} = nothing
end

const tui = TUI()

################################################################################
#                                   Includes
################################################################################

# Ncurses bindings
# ==============================================================================

include("./ncurses/ncurses_attributes.jl")
include("./ncurses/ncurses_functions.jl")

include("./ncurses/form_functions.jl")

include("./ncurses/menu_functions.jl")

include("./ncurses/panel_functions.jl")

# Other includes
# ==============================================================================

include("input.jl")
include("windows.jl")
include("menus.jl")
include("panels.jl")

################################################################################
#                        Initialization and destruction
################################################################################

function __init__()
    try
        ncurses.libncurses = Libdl.dlopen("libncursesw")
    catch
        ncurses.libncurses = Libdl.dlopen("libncurses")
    end

    try
        ncurses.libform  = Libdl.dlopen("libformw")
    catch
        ncurses.libform  = Libdl.dlopen("libform")
    end

    try
        ncurses.libmenu  = Libdl.dlopen("libmenuw")
    catch
        ncurses.libmenu  = Libdl.dlopen("libmenu")
    end

    try
        ncurses.libpanel = Libdl.dlopen("libpanelw")
    catch
        ncurses.libpanel = Libdl.dlopen("libpanel")
    end
end

"""
    function init_tui()

Initialize the Text User Interface (TUI).

"""
function init_tui()
    tui.init && error("The text user interface was already initialized.")
    rootwin  = initscr()
    tui.init = true
    push!(tui.wins, TUI_WINDOW(id = "rootwin", parent = nothing, ptr = rootwin))

    return tui
end
export init_tui


"""
    function destroy_tui()

Destroy the Text User Interface (TUI).

"""
function destroy_tui()
    if tui.init
        destroy_all_panels()
        destroy_all_windows()
        endwin()
    end
end
export destroy_tui

end # module
