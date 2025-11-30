## Description #############################################################################
#
# This file defines the root window. This object is currently only used for anchoring
# windows.
#
############################################################################################

get_left(rw::RootWindow)   = 0
get_height(rw::RootWindow) = Int(NCurses.LINES())
get_width(rw::RootWindow)  = Int(NCurses.COLS())
get_top(rw::RootWindow)    = 0

get_inner_left(rw::RootWindow)   = 0
get_inner_height(rw::RootWindow) = Int(NCurses.LINES())
get_inner_width(rw::RootWindow)  = Int(NCurses.COLS())
get_inner_top(rw::RootWindow)    = 0

function Base.getproperty(rw::T, field::Symbol) where T<:RootWindow
    field == :height && return get_height(rw)
    field == :width  && return get_width(rw)
    field == :id     && return 0
    error("$T has no field $field.")
end

Base.string(::RootWindow) = "Root window"
