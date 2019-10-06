# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains functions reltated to input handling.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export Keystroke
export jlgetch

################################################################################
#                                  Constants
################################################################################

include("keycodes.jl")

################################################################################
#                                  Functions
################################################################################

"""
    function jlgetch(win::Union{Ptr{WINDOW},Nothing} = nothing)

Wait for an keystroke in the window `win` and return it (see `Keystroke`).  If
`win` is `nothing`, then `getch()` will be used instead of `wgetch(win)` to
listen for the keystroke.

"""
function jlgetch(win::Union{Ptr{WINDOW},Nothing} = nothing)
    c_raw = (win == nothing) ? getch() : wgetch(win)

    c_raw < 0 && return Keystroke(raw = c_raw, value = "ERR", ktype = :undefined)

    c::UInt32  = UInt32(c_raw)
    nc::UInt32 = 0

    if c == 27

        s = string(Char(c))

        for i = 1:10
            nc = (win == nothing) ? getch() : wgetch(win)
            nc == nocharval && break
            s *= string(Char(nc))
            haskey(keycodes, s) && break
        end

        if length(s) == 1
            return Keystroke(raw = c, value = c, ktype = :esc)
        elseif haskey( keycodes, s )
            return Keystroke(keycodes[s], raw = c)
        else
            return Keystroke(raw = c, value = s, ktype = :undefined)
        end
    elseif c == nocharval
        return Keystroke(raw = c, value = c, ktype = :undefined)
    elseif c < 192 || c > 253
        if c == 9
            return Keystroke(raw = c, value = string(Char(c)), ktype = :tab)
        elseif c == 10
            return Keystroke(raw = c, value = "\n", ktype = :enter)
        elseif c == 127
            return Keystroke(raw = c, value = string(Char(c)), ktype = :backspace)
        else
            return Keystroke(raw = c, value = string(Char(c)), ktype = :char)
        end
    elseif 192 <= c <= 223 # utf8 based logic starts here
        bs1 = UInt8(c)
        bs2 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        return Keystroke(raw = c, value = String([bs1,bs2]), ktype = :utf8)
    elseif  224 <= c <= 239
        bs1 = UInt8(c)
        bs2 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        bs3 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        return Keystroke(raw = c, value = String([bs1,bs2,bs3]), ktype = :utf8)
    elseif  240 <= c <= 247
        bs1 = UInt8(c)
        bs2 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        bs3 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        bs4 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        return Keystroke(raw = c, value = String([bs1,bs2,bs3,bs4]),
                         ktype = :utf8)
    elseif  248 <= c <= 251
        bs1 = UInt8(c)
        bs2 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        bs3 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        bs4 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        bs5 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        return Keystroke(raw = c, value = String([bs1,bs2,bs3,bs4,bs5]),
                         ktype = :utf8)
    elseif  252 <= c <= 253
        bs1 = UInt8(c)
        bs2 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        bs3 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        bs4 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        bs5 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        bs6 = (win == nothing) ? UInt8(getch()) : UInt8(wgetch(win))
        return Keystroke(raw = c, value = String([bs1,bs2,bs3,bs4,bs5,bs6]),
                         ktype = :utf8)
    end

    return Keystroke(raw = 0, value = string(c), ktype = :undefined)
end
