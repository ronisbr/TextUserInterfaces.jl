## Description #############################################################################
#
# This file contains functions related to keyboard input handling.
#
############################################################################################

export getkey

############################################################################################
#                                        Functions                                         #
############################################################################################

"""
    getkey(win::Ptr{WINDOW} = tui.stdscr) -> Keystroke

Wait for a keystroke in the window `win` and return it (see [`Keystroke`](@ref)). If `win`
is omited, the standard screen (`tui.stdscr`) is used.

# Keywords

- `block::Bool`: If `true`, the function will block waiting for a keystroke. Otherwise, it
    will immediately return the keystroke "ERR" if no key is available in the stack.
    (**Default** = `true`)
"""
function getkey(win::Ptr{WINDOW} = tui.stdscr; block::Bool = true)
    NCurses.nodelay(win, true)
    c_raw = NCurses.wgetch(win)

    while block && (c_raw < 0) && isopen(stdin)
        poll_fd(RawFD(Base.STDIN_NO), 0.1; readable=true)
        c_raw = NCurses.wgetch(win)
    end

    c_raw < 0 && return Keystroke(raw = c_raw, value = "ERR", ktype = :undefined)

    c::UInt32 = UInt32(c_raw)
    nc::Int32 = 0

    if c == 27

        s = string(Char(c))

        # Here, we need to read a sequence of characters that is already in the buffer,
        # limited to 10 characters.
        for i in 1:10
            nc = NCurses.wgetch(win)
            (nc < 0 || nc == nocharval) && break
            s *= string(Char(nc))
            haskey(keycodes, s) && break
        end

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
        bs2 = NCurses.wgetch(win)
        return Keystroke(raw = c, value = String(UInt8[bs1, bs2]), ktype = :utf8)

    elseif  224 <= c <= 239
        bs1 = UInt8(c)
        bs2 = NCurses.wgetch(win)
        bs3 = NCurses.wgetch(win)
        return Keystroke(raw = c, value = String(UInt8[bs1, bs2, bs3]), ktype = :utf8)

    elseif  240 <= c <= 247
        bs1 = UInt8(c)
        bs2 = NCurses.wgetch(win)
        bs3 = NCurses.wgetch(win)
        bs4 = NCurses.wgetch(win)
        return Keystroke(
            raw = c,
            value = String(UInt8[bs1, bs2, bs3, bs4]),
            ktype = :utf8
        )

    elseif  248 <= c <= 251
        bs1 = UInt8(c)
        bs2 = NCurses.wgetch(win)
        bs3 = NCurses.wgetch(win)
        bs4 = NCurses.wgetch(win)
        bs5 = NCurses.wgetch(win)
        return Keystroke(
            raw = c,
            value = String(UInt8[bs1, bs2, bs3, bs4, bs5]),
            ktype = :utf8
        )

    elseif  252 <= c <= 253
        bs1 = UInt8(c)
        bs2 = NCurses.wgetch(win)
        bs3 = NCurses.wgetch(win)
        bs4 = NCurses.wgetch(win)
        bs5 = NCurses.wgetch(win)
        bs6 = NCurses.wgetch(win)
        return Keystroke(
            raw = c,
            value = String(UInt8[bs1, bs2, bs3, bs4, bs5, bs6]),
            ktype = :utf8
        )

    end

    return Keystroke(raw = 0, value = string(c), ktype = :undefined)
end
