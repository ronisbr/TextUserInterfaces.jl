# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   This file contains functions related to keyboard input handling.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export getkey

############################################################################################
#                                        Functions
############################################################################################

"""
    getkey(win::Union{Ptr{WINDOW},Nothing} = nothing) -> Keystroke

Wait for a keystroke in the window `win` and return it (see [`Keystroke`](@ref)).  If `win`
is `nothing`, `getch()` will be used instead of `wgetch(win)` to listen for the keystroke.
"""
function getkey(win::Union{Ptr{WINDOW}, Nothing} = nothing)
    win_ptr = win === nothing ? tui.stdscr : win
    nodelay(win_ptr, true)
    c_raw = wgetch(win_ptr)

    while (c_raw < 0) && isopen(stdin)
        poll_fd(RawFD(Base.STDIN_NO), 0.1; readable=true)
        c_raw = wgetch(win_ptr)
    end

    c_raw < 0 && return Keystroke(raw = c_raw, value = "ERR", ktype = :undefined)

    c::UInt32 = UInt32(c_raw)
    nc::Int32 = 0

    if c == 27

        s = string(Char(c))

        # Here, we need to read a sequence of characters that is already in the
        # buffer. Thus, we will disable the delay.
        win_ptr = win === nothing ? tui.stdscr : win
        #nodelay(win_ptr, true)

        # Read the entire sequence limited to 10 characters.
        for i = 1:10
            nc = wgetch(win_ptr)
            (nc < 0 || nc == nocharval) && break
            s *= string(Char(nc))
            haskey(keycodes, s) && break
        end

        # Re-enable the delay.
        #nodelay(win_ptr, false)

        if length(s) == 1
            return Keystroke(raw = c, value = s, ktype = :esc)

        elseif haskey(keycodes, s)
            return Keystroke(keycodes[s], raw = c)

        else
            # In this case, ALT was pressed.
            return Keystroke(raw = c, value = s, alt = true, ktype = :undefined)

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

        elseif c == 410
            return Keystroke(raw = c, value = string(Char(c)), ktype = :resize)

        else
            return Keystroke(raw = c, value = string(Char(c)), ktype = :char)

        end
    elseif 192 <= c <= 223 # utf8 based logic starts here
        bs1 = UInt8(c)
        bs2 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        return Keystroke(raw = c, value = String([bs1, bs2]), ktype = :utf8)

    elseif  224 <= c <= 239
        bs1 = UInt8(c)
        bs2 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        bs3 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        return Keystroke(raw = c, value = String([bs1, bs2, bs3]), ktype = :utf8)

    elseif  240 <= c <= 247
        bs1 = UInt8(c)
        bs2 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        bs3 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        bs4 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        return Keystroke(
            raw = c,
            value = String([bs1, bs2, bs3, bs4]),
            ktype = :utf8
        )

    elseif  248 <= c <= 251
        bs1 = UInt8(c)
        bs2 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        bs3 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        bs4 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        bs5 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        return Keystroke(
            raw = c,
            value = String([bs1, bs2, bs3, bs4, bs5]),
            ktype = :utf8
        )

    elseif  252 <= c <= 253
        bs1 = UInt8(c)
        bs2 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        bs3 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        bs4 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        bs5 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        bs6 = win === nothing ? UInt8(getch()) : UInt8(wgetch(win))
        return Keystroke(
            raw = c,
            value = String([bs1, bs2, bs3, bs4, bs5, bs6]),
            ktype = :utf8
        )

    end

    return Keystroke(raw = 0, value = string(c), ktype = :undefined)
end
