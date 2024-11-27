## Description #############################################################################
#
# This file contains a wrapper of all libncurses functions that are used by the package.
#
############################################################################################

############################################################################################
#                                    NCurses Functions                                     #
############################################################################################

# == General Functions =====================================================================

# This code assembles the functions by using the following information:
#
# - `f`: Function name.
# - `r`: Return type.
# - `v`: Variable name.
# - `j`: Variable type in Julia.
# - `c`: Variable type in C.

for (f, r, v, j, c) in
    (
        (
            :addstr,
            Cvoid,
            ["str"],
            ["AbstractString"],
            ["Cstring"]
        ),
        (
            :attroff,
            Cint,
            ["attrs"],
            ["Integer"],
            ["Cint"]
        ),
        (
            :attron,
            Cint,
            ["attrs"],
            ["Integer"],
            ["Cint"]
        ),
        (
            :beep,
            Cint,
            [],
            [],
            []
        ),
        (
            :bkgd,
            Cint,
            ["ch"],
            ["Integer"],
            ["Cint"]
        ),
        (
            :box,
            Cvoid,
            ["win", "verch", "horch"],
            ["Ptr{WINDOW}", "jlchtype", "jlchtype"],
            ["Ptr{WINDOW}", "chtype", "chtype"]
        ),
        (
            :can_change_color,
            Cbool,
            [],
            [],
            []
        ),
        (
            :cbreak,
            Cint,
            [],
            [],
            []
        ),
        (
            :clear,
            Cint,
            [],
            [],
            []
        ),
        (
            :clrtobot,
            Cint,
            [],
            [],
            []
        ),
        (
            :clrtoeol,
            Cint,
            [],
            [],
            []
        ),
        (
            :copywin,
            Cint,
            [
                "scr",
                "dest",
                "sminrow",
                "smincol",
                "dminrow",
                "dmincol",
                "dmaxrow",
                "dmaxcol",
                "overlay"
            ],
            ["Ptr{WINDOW}", "Ptr{WINDOW}", ["Integer" for _ = 1:7]...],
            ["Ptr{WINDOW}", "Ptr{WINDOW}", ["Cint" for _ = 1:7]...]
        ),
        (
            :curs_set,
            Cint,
            ["visibility"],
            ["Integer"],
            ["Cint"]
        ),
        (
            :def_prog_mode,
            Cint,
            [],
            [],
            []
        ),
        (
            :delwin,
            Cvoid,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :derwin,
            Ptr{WINDOW},
            ["win", "nlines", "ncols", "begin_y", "begin_x"],
            ["Ptr{WINDOW}", ["Integer" for _ = 1:4]...],
            ["Ptr{WINDOW}", ["Cint" for _ = 1:4]...]
        ),
        (
            :doupdate,
            Cvoid,
            [],
            [],
            []
        ),
        (
            :endwin,
            Cvoid,
            [],
            [],
            []
        ),
        (
            :erase,
            Cint,
            [],
            [],
            []
        ),
        (
            :getch,
            Cint,
            [],
            [],
            []
        ),
        (
            :getbegx,
            Cint,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :getbegy,
            Cint,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :getcurx,
            Cint,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :getcury,
            Cint,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :getmaxx,
            Cint,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :getmaxy,
            Cint,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :getmouse,
            Cint,
            ["event"],
            ["Ptr{MEVENT}"],
            ["Ptr{MEVENT}"]
        ),
        (
            :halfdelay,
            Cint,
            ["tenths"],
            ["Integer"],
            ["Cint"]
        ),
        (
            :has_colors,
            Cbool,
            [],
            [],
            []
        ),
        (
            :hline,
            Cint,
            ["ch", "n"],
            ["jlchtype", "Integer"],
            ["chtype", "Cint"]
        ),
        (
            :init_color,
            Cint,
            ["color", "r", "g", "b"],
            ["Integer", "Integer", "Integer", "Integer"],
            ["Cshort", "Cshort", "Cshort", "Cshort"]
        ),
        (
            :init_pair,
            Cint,
            ["pair", "f", "b"],
            ["Integer", "Integer", "Integer"],
            ["Cshort", "Cshort", "Cshort"]
        ),
        (
            :initscr,
            Ptr{WINDOW},
            [],
            [],
            []
        ),
        (
            :keypad,
            Cvoid,
            ["win", "bf"],
            ["Ptr{WINDOW}", "Bool"],
            ["Ptr{WINDOW}", "Cuchar"]
        ),
        (
            :leaveok,
            Cvoid,
            ["win", "bf"],
            ["Ptr{WINDOW}", "Bool"],
            ["Ptr{WINDOW}", "Cuchar"]
        ),
        (
            :mouseinterval,
            Cint,
            ["n"],
            ["Integer"],
            ["Cint"]
        ),
        (
            :mousemask,
            Culong,
            ["newmask", "oldmask"],
            ["UInt", "Ptr{UInt}"],
            ["Culong", "Ptr{Culong}"]
        ),
        (
            :mvaddch,
            Cint,
            ["y", "x", "ch"],
            ["Integer", "Integer", "jlchtype"],
            ["Cint", "Cint", "chtype"]
        ),
        (
            :mvhline,
            Cint,
            ["y", "x", "ch", "n"],
            ["Integer", "Integer", "jlchtype", "Integer"],
            ["Cint", "Cint", "chtype", "Cint"]
        ),
        (
            :mvvline,
            Cint,
            ["y", "x", "ch", "n"],
            ["Integer", "Integer", "jlchtype", "Integer"],
            ["Cint", "Cint", "chtype", "Cint"]
        ),
        (
            :mvwaddch,
            Cint,
            ["win", "y", "x", "ch"],
            ["Ptr{WINDOW}", "Integer", "Integer", "jlchtype"],
            ["Ptr{WINDOW}", "Cint", "Cint", "chtype"]
        ),
        (
            :mvwhline,
            Cint,
            ["win", "y", "x", "ch", "n"],
            ["Ptr{WINDOW}", "Integer", "Integer", "jlchtype", "Integer"],
            ["Ptr{WINDOW}", "Cint", "Cint", "chtype", "Cint"]
        ),
        (
            :mvprintw,
            Cvoid,
            ["y", "x", "str"],
            ["Integer", "Integer", "AbstractString"],
            ["Cint", "Cint", "Cstring"]
        ),
        (
            :mvwprintw,
            Cvoid,
            ["win", "y", "x", "str"],
            ["Ptr{WINDOW}", "Integer", "Integer", "AbstractString"],
            ["Ptr{WINDOW}", "Cint", "Cint", "Cstring"]
        ),
        (
            :mvwvline,
            Cint,
            ["win", "y", "x", "ch", "n"],
            ["Ptr{WINDOW}", "Integer", "Integer", "jlchtype", "Integer"],
            ["Ptr{WINDOW}", "Cint", "Cint", "chtype", "Cint"]
        ),
        (
            :mvwin,
            Cvoid,
            ["win", "y", "x"],
            ["Ptr{WINDOW}", "Integer", "Integer"],
            ["Ptr{WINDOW}", "Cint", "Cint"]
        ),
        (
            :newpad,
            Ptr{WINDOW},
            ["lines", "cols"],
            ["Integer", "Integer"],
            ["Cint", "Cint"]
        ),
        (
            :newwin,
            Ptr{WINDOW},
            ["lines", "cols", "y", "x"],
            ["Integer" for _ = 1:4],
            ["Cint" for _ = 1:4]
        ),
        (
            :nodelay,
            Cvoid,
            ["win", "bf"],
            ["Ptr{WINDOW}", "Bool"],
            ["Ptr{WINDOW}", "Cuchar"]
        ),
        (
            :noecho,
            Cvoid,
            [],
            [],
            []
        ),
        (
            :notimeout,
            Cvoid,
            ["win", "bf"],
            ["Ptr{WINDOW}", "Bool"],
            ["Ptr{WINDOW}", "Cuchar"]
        ),
        (
            :overwrite,
            Cint,
            ["scr", "dest"],
            ["Ptr{WINDOW}", "Ptr{WINDOW}"],
            ["Ptr{WINDOW}", "Ptr{WINDOW}"]
        ),
        (
            :prefresh,
            Cint,
            ["win", "pminrow", "pmincol", "sminrow", "smincol", "smaxrow", "smaxcol"],
            ["Ptr{WINDOW}", ["Integer" for _ = 1:6]...],
            ["Ptr{WINDOW}", ["Cint" for _ = 1:6]...]
        ),
        (
            :pnoutrefresh,
            Cint,
            ["win", "pminrow", "pmincol", "sminrow", "smincol", "smaxrow", "smaxcol"],
            ["Ptr{WINDOW}", ["Integer" for _ = 1:6]...],
            ["Ptr{WINDOW}", ["Cint" for _ = 1:6]...]
        ),
        (
            :printw,
            Cvoid,
            ["str"],
            ["AbstractString"],
            ["Cstring"]
        ),
        (
            :refresh,
            Cvoid,
            [],
            [],
            []
        ),
        (
            :reset_prog_mode,
            Cint,
            [],
            [],
            []
        ),
        (
            :resizeterm,
            Cint,
            ["lines", "columns"],
            ["Integer", "Integer"],
            ["Cint", "Cint"]
        ),
        (
            :scrollok,
            Cvoid,
            ["win", "bf"],
            ["Ptr{WINDOW}", "Bool"],
            ["Ptr{WINDOW}", "Cuchar"]
        ),
        (
            :start_color,
            Cint,
            [],
            [],
            []
        ),
        (
            :subpad,
            Ptr{WINDOW},
            ["win", "nlines", "ncols", "begin_y", "begin_x"],
            ["Ptr{WINDOW}", ["Integer" for _ = 1:4]...],
            ["Ptr{WINDOW}", ["Cint" for _ = 1:4]...]
        ),
        (
            :touchwin,
            Cvoid,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :vline,
            Cint,
            ["ch", "n"],
            ["jlchtype", "Integer"],
            ["chtype", "Cint"]
        ),
        (
            :waddch,
            Cvoid,
            ["win", "ch"],
            ["Ptr{WINDOW}", "jlchtype"],
            ["Ptr{WINDOW}", "chtype"]
        ),
        (
            :waddstr,
            Cvoid,
            ["win", "str"],
            ["Ptr{WINDOW}", "AbstractString"],
            ["Ptr{WINDOW}", "Cstring"]
        ),
        (
            :wattroff,
            Cint,
            ["win", "attrs"],
            ["Ptr{WINDOW}", "Integer"],
            ["Ptr{WINDOW}", "Cint"]
        ),
        (
            :wattron,
            Cint,
            ["win", "attrs"],
            ["Ptr{WINDOW}", "Integer"],
            ["Ptr{WINDOW}", "Cint"]
        ),
        (
            :wbkgd,
            Cint,
            ["win", "ch"],
            ["Ptr{WINDOW}", "Integer"],
            ["Ptr{WINDOW}", "Cint"]
        ),
        (
            :wborder,
            Cvoid,
            ["win", "ls", "rs", "ts", "bs", "tl", "tr", "bl", "br"],
            ["Ptr{WINDOW}", ["jlchtype" for _ = 1:8]...],
            ["Ptr{WINDOW}", ["chtype" for _ = 1:8]...]
        ),
        (
            :wclear,
            Cvoid,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :wclrtobot,
            Cint,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :wclrtoeol,
            Cint,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :werase,
            Cvoid,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :wgetch,
            Cint,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :whline,
            Cint,
            ["win", "ch", "n"],
            ["Ptr{WINDOW}", "jlchtype", "Integer"],
            ["Ptr{WINDOW}", "chtype", "Cint"]
        ),
        (
            :winch,
            Cint,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :wmove,
            Cvoid,
            ["win", "y", "x"],
            ["Ptr{WINDOW}", "Integer", "Integer"],
            ["Ptr{WINDOW}", "Cint", "Cint"]
        ),
        (
            :wnoutrefresh,
            Cvoid,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :wrefresh,
            Cvoid,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :wprintw,
            Cvoid,
            ["win", "str"],
            ["Ptr{WINDOW}", "AbstractString"],
            ["Ptr{WINDOW}", "Cstring"]
        ),
        (
            :wresize,
            Cvoid,
            ["win", "lines", "cols"],
            ["Ptr{WINDOW}", "Integer", "Integer"],
            ["Ptr{WINDOW}", "Cint", "Cint"]
        ),
        (
            :wtimeout,
            Cvoid,
            ["win", "delay"],
            ["Ptr{WINDOW}", "Integer"],
            ["Ptr{WINDOW}", "Cint"]
        ),
        (
            :wvline,
            Cint,
            ["win", "ch", "n"],
            ["Ptr{WINDOW}", "jlchtype", "Integer"],
            ["Ptr{WINDOW}", "chtype", "Cint"]
        ),
    )

    fb    = Meta.quot(f)
    argst = Meta.parse("(" * ([s * "," for s in j]...) * ")")
    argsj = [Meta.parse(i * "::" * j) for (i,j) in zip(v,j)]
    argsc = [Meta.parse(i * "::" * j) for (i,j) in zip(v,c)]

    # Assemble the argument string to build the function documentation.
    args_str = ""
    for i in 1:length(v)
        args_str *= v[i] * "::" * j[i]

        if i != length(v)
            args_str *= ", "
        end
    end

    @eval begin
        """
            $($fb)($($args_str)) -> $($r)

        For more information, see `libncurses` documentation.
        """
        $f($(argsj...)) = @ccall $f($(argsc...))::$r
        _precompile_func($f, $argst)
    end
end

# == Other Functions =======================================================================

"""
    ACS_(s::Symbol)

Return the symbol `s` of the `acs_map`. For example, `ACS_HLINE` can be obtained from
`ACS_(:HLINE)`.
"""
function ACS_(s::Symbol)
    if ncurses.acs_map == C_NULL
        if !ncurses.NCURSES_REENTRANT
            ncurses.acs_map = cglobal(dlsym(ncurses.libncurses, :acs_map), Cuint)
        else
            ncurses.acs_map = ccall(dlsym(ncurses.libncurses, :_nc_acs_map), Cuint, ())
        end
        ncurses.acs_map_arr = unsafe_wrap(Array, ncurses.acs_map, 128)
    end

    if haskey(acs_map_dict, s)
        return ncurses.acs_map_arr[acs_map_dict[s]+1]
    else
        error("Symbol `$s` is not defined in `acs_map`.")
    end
end

"""
    COLS() -> Cint

Return the number of columns in the root window. It must be called after `initscr()`.

For more information, see `libncurses` documentation.
"""
function COLS()
    if !ncurses.NCURSES_REENTRANT
        ncurses.COLS == C_NULL && ( ncurses.COLS = cglobal( dlsym(ncurses.libncurses, :COLS), Cint) )
        return unsafe_load(ncurses.COLS)
    else
        return ccall(dlsym(ncurses.libncurses, :_nc_COLS), Cint, ())
    end
end

"""
    LINES() -> Cint

Return the number of lines in the root window. It must be called after `initscr()`.

For more information, see `libncurses` documentation.
"""
function LINES()
    if !ncurses.NCURSES_REENTRANT
        ncurses.LINES == C_NULL && ( ncurses.LINES = cglobal( dlsym(ncurses.libncurses, :LINES), Cint) )
        return unsafe_load(ncurses.LINES)
    else
        return ccall(dlsym(ncurses.libncurses, :_nc_LINES), Cint, ())
    end
end

# == Specialization ========================================================================

"""
    wborder(win::Ptr{WINDOW})

Call the function `wborder(win, 0, 0, 0, 0, 0, 0, 0, 0)`.

"""
wborder(win::Ptr{WINDOW}) = wborder(win, 0, 0, 0, 0, 0, 0, 0, 0)

# == NCurses Version =======================================================================

"""
    curses_version() -> NamedTuple

Return the NCurses version in a named tuple with the following fields:

- `major`: Major version.
- `minor`: Minor version.
- `patch`: Patch version.
"""
function curses_version()
    ver_ptr  = ccall( dlsym(ncurses.libncurses, :curses_version), Cstring, () )
    ver_str  = unsafe_string(ver_ptr)
    tokens   = split(ver_str, ' ')
    ver_toks = split(tokens[2], '.')

    try
        major = parse(Int, ver_toks[1])
        minor = parse(Int, ver_toks[2])
        patch = parse(Int, ver_toks[3])

        return (major = major, minor = minor, patch = patch)
    catch
        error("Could not obtain the NCurses version. Returned string: $(tokens[2])")
    end
end
