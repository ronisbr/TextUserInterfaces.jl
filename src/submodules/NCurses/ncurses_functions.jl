## Description #############################################################################
#
# This file contains a wrapper of all libncurses functions that are used by the package.
#
############################################################################################

############################################################################################
#                                      Private Macros                                      #
############################################################################################

"""
    @_ccalln expr

Make a `ccall` to a `libncurses` function. The usage should be:

    @_ccalln function(arg1::Type1, arg2::Type2, ...) -> TypeReturn

It uses the global constant structure `ncurses` to call the function. Hence, it must be
initialized.
"""
macro _ccalln(expr)
    !(expr.head == :(::) && expr.args[1].head == :call) &&
    error("Invalid use of @_ccall")

    return_type   = expr.args[2]
    function_name = QuoteNode(expr.args[1].args[1])
    args          = expr.args[1].args[2:end]

    arglist  = []
    typeargs = :(())
    handler  = :(dlsym($(esc(ncurses)).libncurses, $(esc(function_name))))
    out = :(ccall( $(handler), $(esc(return_type)), $(esc(typeargs))))

    for arg in args
        !(arg.head == :(::)) && error("All arguments must have a type.")
        push!(out.args, :($(esc(arg.args[1]))))
        push!(typeargs.args, arg.args[2])
    end

    return out
end

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
            :beep,
            Cint,
            [],
            [],
            []
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
            :has_colors,
            Cbool,
            [],
            [],
            []
        ),
        (
            :winch,
            Cint,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
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
            :mousemask,
            Culong,
            ["newmask", "oldmask"],
            ["UInt", "Ptr{UInt}"],
            ["Culong", "Ptr{Culong}"]
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
            :touchwin,
            Cvoid,
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
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
        $f($(argsj...)) = @_ccalln $f($(argsc...))::$r
        _precompile_func($f, $argst)
    end
end

# == Functions that Depends on Arguments that Must Be `Integer` ============================

for (f, r, v, j, c) in
    (
        (
            :attroff,
            Cint,
            ["attrs"],
            ["T"],
            ["Cint"]
        ),
        (
            :attron,
            Cint,
            ["attrs"],
            ["T"],
            ["Cint"]
        ),
        (
            :bkgd,
            Cint,
            ["ch"],
            ["T"],
            ["Cint"]
        ),
        (
            :curs_set,
            Cint,
            ["visibility"],
            ["T"],
            ["Cint"]
        ),
        (
            :derwin,
            Ptr{WINDOW},
            ["win", "nlines", "ncols", "begin_y", "begin_x"],
            ["Ptr{WINDOW}", ["T" for _ = 1:4]...],
            ["Ptr{WINDOW}", ["Cint" for _ = 1:4]...]
        ),
        (
            :halfdelay,
            Cint,
            ["tenths"],
            ["T"],
            ["Cint"]
        ),
        (
            :init_color,
            Cint,
            ["color", "r", "g", "b"],
            ["T", "T", "T", "T"],
            ["Cshort", "Cshort", "Cshort", "Cshort"]
        ),
        (
            :init_pair,
            Cint,
            ["pair", "f", "b"],
            ["T", "T", "T"],
            ["Cshort", "Cshort", "Cshort"]
        ),
        (
            :mouseinterval,
            Cint,
            ["n"],
            ["T"],
            ["Cint"]
        ),
        (
            :mvwin,
            Cvoid,
            ["win", "y", "x"],
            ["Ptr{WINDOW}", "T", "T"],
            ["Ptr{WINDOW}", "Cint", "Cint"]
        ),
        (
            :newpad,
            Ptr{WINDOW},
            ["lines", "cols"],
            ["T", "T"],
            ["Cint", "Cint"]
        ),
        (
            :newwin,
            Ptr{WINDOW},
            ["lines", "cols", "y", "x"],
            ["T" for _ = 1:4],
            ["Cint" for _ = 1:4]
        ),
        (
            :resizeterm,
            Cint,
            ["lines", "columns"],
            ["T", "T"],
            ["Cint", "Cint"]
        ),
        (
            :subpad,
            Ptr{WINDOW},
            ["win", "nlines", "ncols", "begin_y", "begin_x"],
            ["Ptr{WINDOW}", ["T" for _ = 1:4]...],
            ["Ptr{WINDOW}", ["Cint" for _ = 1:4]...]
        ),
        (
            :wattroff,
            Cint,
            ["win", "attrs"],
            ["Ptr{WINDOW}", "T"],
            ["Ptr{WINDOW}", "Cint"]
        ),
        (
            :wattron,
            Cint,
            ["win", "attrs"],
            ["Ptr{WINDOW}", "T"],
            ["Ptr{WINDOW}", "Cint"]
        ),
        (
            :wbkgd,
            Cint,
            ["win", "ch"],
            ["Ptr{WINDOW}", "T"],
            ["Ptr{WINDOW}", "Cint"]
        ),
        (
            :wmove,
            Cvoid,
            ["win", "y", "x"],
            ["Ptr{WINDOW}", "T", "T"],
            ["Ptr{WINDOW}", "Cint", "Cint"]
        ),
        (
            :wresize,
            Cvoid,
            ["win", "lines", "cols"],
            ["Ptr{WINDOW}", "T", "T"],
            ["Ptr{WINDOW}", "Cint", "Cint"]
        ),
        (
            :wtimeout,
            Cvoid,
            ["win", "delay"],
            ["Ptr{WINDOW}", "T"],
            ["Ptr{WINDOW}", "Cint"]
        ),
        # Functions with very long arguments.
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
            ["Ptr{WINDOW}", "Ptr{WINDOW}", ["T" for _ = 1:7]...],
            ["Ptr{WINDOW}", "Ptr{WINDOW}", ["Cint" for _ = 1:7]...]
        ),
        (
            :prefresh,
            Cint,
            ["win", "pminrow", "pmincol", "sminrow", "smincol", "smaxrow", "smaxcol"],
            ["Ptr{WINDOW}", ["T" for _ = 1:6]...],
            ["Ptr{WINDOW}", ["Cint" for _ = 1:6]...]
        ),
        (
            :pnoutrefresh,
            Cint,
            ["win", "pminrow", "pmincol", "sminrow", "smincol", "smaxrow", "smaxcol"],
            ["Ptr{WINDOW}", ["T" for _ = 1:6]...],
            ["Ptr{WINDOW}", ["Cint" for _ = 1:6]...]
        )
    )

    fb    = Meta.quot(f)
    argst = Meta.parse("(" * ([s == "T" ? "Int," : s * "," for s in j]...) * ")")
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
            $($fb)($($args_str)) where T<:Integer -> $($r)

        For more information, see `libncurses` documentation.
        """
        $f($(argsj...)) where T<:Integer = @_ccalln $f($(argsc...))::$r
        _precompile_func($f, $argst)
    end
end

# == Functions that Depends on Arguments that Must Be `jlchtype` ===========================

for (f, r, v, j, c) in
    (
        (
            :box,
            Cvoid,
            ["win", "verch", "horch"],
            ["Ptr{WINDOW}", "T", "T"],
            ["Ptr{WINDOW}", "chtype", "chtype"]
        ),
        (
            :waddch,
            Cvoid,
            ["win", "ch"],
            ["Ptr{WINDOW}", "T"],
            ["Ptr{WINDOW}", "chtype"]
        ),
        (
            :wborder,
            Cvoid,
            ["win", "ls", "rs", "ts", "bs", "tl", "tr", "bl", "br"],
            ["Ptr{WINDOW}", ["T" for _ = 1:8]...],
            ["Ptr{WINDOW}", ["chtype" for _ = 1:8]...]
        ),
    )

    fb     = Meta.quot(f)
    argst1 = Meta.parse("(" * ([s == "T" ? "Char," : s * "," for s in j]...) * ")")
    argst2 = Meta.parse("(" * ([s == "T" ? "Int,"  : s * "," for s in j]...) * ")")
    argsj  = [Meta.parse(i * "::" * j) for (i,j) in zip(v,j)]
    argsc  = [Meta.parse(i * "::" * j) for (i,j) in zip(v,c)]

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
            $($fb)($($args_str)) where T<:jlchtype -> $($r)

        For more information, see `libncurses` documentation.
        """
        $f($(argsj...)) where T<:jlchtype = @_ccalln $f($(argsc...))::$r
        _precompile_func($f, $argst1)
        _precompile_func($f, $argst2)
    end
end

# == Functions that Depends on Arguments that Must Be `Integer` and `jlchtype` =============

for (f, r, v, j, c) in
    (
        (
            :hline,
            Cint,
            ["ch", "n"],
            ["Tc", "Ti"],
            ["chtype", "Cint"]
        ),
        (
            :mvaddch,
            Cint,
            ["y", "x", "ch"],
            ["Ti", "Ti", "Tc"],
            ["Cint", "Cint", "chtype"]
        ),
        (
            :mvhline,
            Cint,
            ["y", "x", "ch", "n"],
            ["Ti", "Ti", "Tc", "Ti"],
            ["Cint", "Cint", "chtype", "Cint"]
        ),
        (
            :mvvline,
            Cint,
            ["y", "x", "ch", "n"],
            ["Ti", "Ti", "Tc", "Ti"],
            ["Cint", "Cint", "chtype", "Cint"]
        ),
        (
            :mvwaddch,
            Cint,
            ["win", "y", "x", "ch"],
            ["Ptr{WINDOW}", "Ti", "Ti", "Tc"],
            ["Ptr{WINDOW}", "Cint", "Cint", "chtype"]
        ),
        (
            :mvwhline,
            Cint,
            ["win", "y", "x", "ch", "n"],
            ["Ptr{WINDOW}", "Ti", "Ti", "Tc", "Ti"],
            ["Ptr{WINDOW}", "Cint", "Cint", "chtype", "Cint"]
        ),
        (
            :mvwvline,
            Cint,
            ["win", "y", "x", "ch", "n"],
            ["Ptr{WINDOW}", "Ti", "Ti", "Tc", "Ti"],
            ["Ptr{WINDOW}", "Cint", "Cint", "chtype", "Cint"]
        ),
        (
            :vline,
            Cint,
            ["ch", "n"],
            ["Tc", "Ti"],
            ["chtype", "Cint"]
        ),
        (
            :whline,
            Cint,
            ["win", "ch", "n"],
            ["Ptr{WINDOW}", "Tc", "Ti"],
            ["Ptr{WINDOW}", "chtype", "Cint"]
        ),
        (
            :wvline,
            Cint,
            ["win", "ch", "n"],
            ["Ptr{WINDOW}", "Tc", "Ti"],
            ["Ptr{WINDOW}", "chtype", "Cint"]
        ),
    )

    fb     = Meta.quot(f)
    argst1 = Meta.parse("(" * ([s == "Tc" ? "Char," : s == "Ti" ? "Int," : s * "," for s in j]...) * ")")
    argst2 = Meta.parse("(" * ([s == "Tc" ? "Int,"  : s == "Ti" ? "Int," : s * "," for s in j]...) * ")")
    argsj  = [Meta.parse(i * "::" * j) for (i,j) in zip(v,j)]
    argsc  = [Meta.parse(i * "::" * j) for (i,j) in zip(v,c)]

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
            $($fb)($($args_str)) where {Tc<:jlchtype, Ti<:Integer} -> $($r)

        For more information, see `libncurses` documentation.
        """
        $f($(argsj...)) where {Tc<:jlchtype,Ti<:Integer} = @_ccalln $f($(argsc...))::$r
        _precompile_func($f, $argst1)
        _precompile_func($f, $argst2)
    end
end

# == Functions that Depends on Arguments that Must Be `AbstractString` =====================

for (f, r, v, j, c) in
    (
        (
            :wprintw,
            Cvoid,
            ["win", "str"],
            ["Ptr{WINDOW}", "T"],
            ["Ptr{WINDOW}", "Cstring"]
        ),
        (
            :printw,
            Cvoid,
            ["str"],
            ["T"],
            ["Cstring"]
        ),
        (
            :waddstr,
            Cvoid,
            ["win", "str"],
            ["Ptr{WINDOW}", "T"],
            ["Ptr{WINDOW}", "Cstring"]
        ),
        (
            :addstr,
            Cvoid,
            ["str"],
            ["T"],
            ["Cstring"]
        ),
    )

    fb    = Meta.quot(f)
    argst = Meta.parse("(" * ([s == "T" ? "String," : s * "," for s in j]...) * ")")
    argsj = [Meta.parse(i * "::" * j) for (i,j) in zip(v,j)]
    argsc = [Meta.parse(i * "::" * j) for (i,j) in zip(v,c)]

    # Assemble the argument string to build the function documentation.
    args_str = ""
    for i = 1:length(v)
        args_str *= v[i] * "::" * j[i]

        if i != length(v)
            args_str *= ", "
        end
    end

    @eval begin
        """
            $($fb)($($args_str)) where T<:AbstractString -> $($r)

        For more information, see `libncurses` documentation.
        """
        $f($(argsj...)) where T<:AbstractString = @_ccalln $f($(argsc...))::$r
        _precompile_func($f, $argst)
    end
end

# == Functions that Arguments Must Be `AbstractString` and `Integer` =======================

for (f, r, v, j, c) in
    (
        (
            :mvprintw,
            Cvoid,
            ["y", "x", "str"],
            ["Ti", "Ti", "Ts"],
            ["Cint", "Cint", "Cstring"]
        ),
        (
            :mvwprintw,
            Cvoid,
            ["win", "y", "x", "str"],
            ["Ptr{WINDOW}", "Ti", "Ti", "Ts"],
            ["Ptr{WINDOW}", "Cint", "Cint", "Cstring"]
        ),
    )

    fb    = Meta.quot(f)
    argst = Meta.parse("(" * ([s == "Ts" ? "String," : s == "Ti" ? "Int," : s * "," for s in j]...) * ")")
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
            $($fb)($($args_str)) where {Ti<:Integer, Ts<:AbstractString} -> $($r)

        For more information, see `libncurses` documentation.
        """
        $f($(argsj...)) where {Ti<:Integer,Ts<:AbstractString} = @_ccalln $f($(argsc...))::$r
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
