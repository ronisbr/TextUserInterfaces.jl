## Description #################################################################
#
# This file contains the definition of mouse events in libncurses.
#
################################################################################

"""
    struct MEVENT

represents a mouse event

"""
mutable struct MEVENT
    id::Cshort
    x::Cint
    y::Cint
    z::Cint
    bstate::Culong
end

NCURSES_MOUSE_MASK(b,m)=m<<((b-1)*6)
const NCURSES_BUTTON_RELEASED=1
const NCURSES_BUTTON_PRESSED=2
const NCURSES_BUTTON_CLICKED=4
const NCURSES_DOUBLE_CLICKED=8

const BUTTON1_RELEASED=       NCURSES_MOUSE_MASK(1, NCURSES_BUTTON_RELEASED)
const BUTTON1_PRESSED=        NCURSES_MOUSE_MASK(1, NCURSES_BUTTON_PRESSED)
const BUTTON1_CLICKED=        NCURSES_MOUSE_MASK(1, NCURSES_BUTTON_CLICKED)
const BUTTON1_DOUBLE_CLICKED= NCURSES_MOUSE_MASK(1, NCURSES_DOUBLE_CLICKED)
const BUTTON2_RELEASED=       NCURSES_MOUSE_MASK(2, NCURSES_BUTTON_RELEASED)
const BUTTON2_PRESSED=        NCURSES_MOUSE_MASK(2, NCURSES_BUTTON_PRESSED)
const BUTTON2_CLICKED=        NCURSES_MOUSE_MASK(2, NCURSES_BUTTON_CLICKED)
const BUTTON2_DOUBLE_CLICKED= NCURSES_MOUSE_MASK(2, NCURSES_DOUBLE_CLICKED)
const BUTTON3_RELEASED=       NCURSES_MOUSE_MASK(3, NCURSES_BUTTON_RELEASED)
const BUTTON3_PRESSED=        NCURSES_MOUSE_MASK(3, NCURSES_BUTTON_PRESSED)
const BUTTON3_CLICKED=        NCURSES_MOUSE_MASK(3, NCURSES_BUTTON_CLICKED)
const BUTTON3_DOUBLE_CLICKED= NCURSES_MOUSE_MASK(3, NCURSES_DOUBLE_CLICKED)
const REPORT_MOUSE_POSITION=  NCURSES_MOUSE_MASK(6, 10)
const ALL_MOUSE_EVENTS=       REPORT_MOUSE_POSITION-1

# two useful methods which also show the proper use of
# getmouse and mousemask

function getmouse() 
  me=MEVENT(1,0,0,0,0)
  getmouse(Ptr{MEVENT}(pointer_from_objref(me)))
  me
end

mousemask(x::Integer)=mousemask(UInt(x),Ptr{UInt}(C_NULL))

