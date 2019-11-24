# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains the definition of attributes in libncurses.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

const NCURSES_ATTR_SHIFT = 8

function NCURSES_BITS(m, shf)
    m << (shf + NCURSES_ATTR_SHIFT)
end

const A_NORMAL     =  UInt32(0)
const A_ATTRIBUTES = ~UInt32(0)
const A_CHARTEXT   = NCURSES_BITS(UInt32(1),0) - UInt32(1)
const A_COLOR      = NCURSES_BITS( (UInt32(1) << 8) - UInt32(1),0)
const A_STANDOUT   = NCURSES_BITS(UInt32(1), 8)
const A_UNDERLINE  = NCURSES_BITS(UInt32(1), 9)
const A_REVERSE    = NCURSES_BITS(UInt32(1),10)
const A_BLINK      = NCURSES_BITS(UInt32(1),11)
const A_DIM        = NCURSES_BITS(UInt32(1),12)
const A_BOLD       = NCURSES_BITS(UInt32(1),13)
const A_ALTCHARSET = NCURSES_BITS(UInt32(1),14)
const A_INVIS      = NCURSES_BITS(UInt32(1),15)
const A_PROTECT    = NCURSES_BITS(UInt32(1),16)
const A_HORIZONTAL = NCURSES_BITS(UInt32(1),17)
const A_LEFT       = NCURSES_BITS(UInt32(1),18)
const A_LOW        = NCURSES_BITS(UInt32(1),19)
const A_RIGHT      = NCURSES_BITS(UInt32(1),20)
const A_TOP        = NCURSES_BITS(UInt32(1),21)
const A_VERTICAL   = NCURSES_BITS(UInt32(1),22)

export A_NORMAL, A_ATTRIBUTES, A_CHARTEXT, A_COLOR, A_STANDOUT, A_UNDERLINE,
       A_REVERSE, A_BLINK, A_DIM, A_BOLD, A_ALTCHARSET, A_INVIS, A_PROTECT,
       A_HORIZONTAL, A_LEFT, A_LOW, A_RIGHT, A_TOP, A_VERTICAL

const COLOR_BLACK   = 0
const COLOR_RED     = 1
const COLOR_GREEN   = 2
const COLOR_YELLOW  = 3
const COLOR_BLUE    = 4
const COLOR_MAGENTA = 5
const COLOR_CYAN    = 6
const COLOR_WHITE   = 7

COLOR_PAIR(n) = NCURSES_BITS(n, 0)

export COLOR_BLACK, COLOR_RED, COLOR_GREEN, COLOR_YELLOW, COLOR_BLUE,
       COLOR_MAGENTA, COLOR_CYAN, COLOR_WHITE, COLOR_PAIR
