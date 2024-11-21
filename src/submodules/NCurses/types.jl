## Description #############################################################################
#
# Types related to NCurses.
#
############################################################################################

export ncurses

"""
    struct NCURSES

This private structure handles some global variables that are used in the ncurses wrapper.
"""
@kwdef mutable struct NCURSES

    NCURSES_REENTRANT::Bool  = false

    libncurses::Ptr{Nothing} = Ptr{Nothing}(0)
    libform::Ptr{Nothing}    = Ptr{Nothing}(0)
    libmenu::Ptr{Nothing}    = Ptr{Nothing}(0)
    libpanel::Ptr{Nothing}   = Ptr{Nothing}(0)

    # == libncurses global symbols =========================================================

    LINES::Ptr{Cint}            = Ptr{Cint}(0)
    COLS::Ptr{Cint}             = Ptr{Cint}(0)
    acs_map::Ptr{Cuint}         = Ptr{Cuint}(0)
    acs_map_arr::Vector{UInt32} = UInt32[]

    # == libforms global symbols ===========================================================

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

include("ncurses_types.jl")
include("ncurses_attributes.jl")
include("ncurses_keys.jl")
include("ncurses_mouse.jl")
include("./form/form_types.jl")
include("./menu/menu_types.jl")
include("./panel/panel_types.jl")
