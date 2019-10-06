# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains the definition of types related to libncurses.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WINDOW

################################################################################
#                                    Types
################################################################################

const attr_t         = Cuint
const Cbool          = UInt8
const chtype         = UInt32
const jlchtype       = Union{Integer,Char}
const NCURSES_SIZE_T = Cshort

################################################################################
#                                  Constants
################################################################################

const KEY_MAX = 0o777

# Dictionary to select a symbol in `acs_map`.
const acs_map_dict = Dict{Symbol, Int}(
    :ULCORNER => Int('l'),
    :LLCORNER => Int('m'),
    :URCORNER => Int('k'),
    :LRCORNER => Int('j'),
    :LTEE     => Int('t'),
    :RTEE     => Int('u'),
    :BTEE     => Int('v'),
    :TTEE     => Int('w'),
    :HLINE    => Int('q'),
    :VLINE    => Int('x'),
    :PLUS     => Int('n'),
    :S1       => Int('o'),
    :S9       => Int('s'),
    :DIAMOND  => Int('`'),
    :CKBOARD  => Int('a'),
    :DEGREE   => Int('f'),
    :PLMINUS  => Int('g'),
    :BULLET   => Int('~'),
    :LARROW   => Int(','),
    :RARROW   => Int('+'),
    :DARROW   => Int('.'),
    :UARROW   => Int('-'),
    :BOARD    => Int('h'),
    :LANTERN  => Int('i'),
    :BLOCK    => Int('0'),
    :S3       => Int('p'),
    :S7       => Int('r'),
    :LEQUAL   => Int('y'),
    :GEQUAL   => Int('z'),
    :PI       => Int('{'),
    :NEQUAL   => Int('|'),
    :STERLING => Int('}'),
)

################################################################################
#                                  Structures
################################################################################

"""
    struct WINDOW

Handles a ncurses window.

"""
mutable struct WINDOW
    cury::NCURSES_SIZE_T
    curx::NCURSES_SIZE_T
    maxy::NCURSES_SIZE_T
    maxx::NCURSES_SIZE_T
    begy::NCURSES_SIZE_T
    begx::NCURSES_SIZE_T
    flags::Cshort
    attrs::attr_t
    notimeout::Cbool
    clear::Cbool
    leaveok::Cbool
    scroll::Cbool
    idlok::Cbool
    idcok::Cbool
    immed::Cbool
    sync::Cbool
    use_keypad::Cbool
    delay::Cint
    ldat::Ptr{Cvoid}
    regtop::NCURSES_SIZE_T
    regbottom::NCURSES_SIZE_T
    parx::Cint
    pary::Cint
    parent::Ptr{WINDOW}
    pad_y::NCURSES_SIZE_T
    pad_x::NCURSES_SIZE_T
    pad_top::NCURSES_SIZE_T
    pad_left::NCURSES_SIZE_T
    pad_bottom::NCURSES_SIZE_T
    pad_right::NCURSES_SIZE_T
    yoffset::NCURSES_SIZE_T
end
