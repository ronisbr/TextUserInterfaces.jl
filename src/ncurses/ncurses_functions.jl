# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains a wrapper of all libncurses functions that are used by
#   the package.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

################################################################################
#                                Private macros
################################################################################

"""
    macro _ccalln(expr)

Make a `ccall` to a `libncurses` function. The usage should be:

    @_ccalln function(arg1::Type1, arg2::Type2, ...)::TypeReturn

It uses the global constant structure `ncurses` to call the function. Hence, it
must be initialized.

"""
macro _ccalln(expr)
    !( expr.head == :(::) && expr.args[1].head == :call ) &&
    error("Invalid use of @_ccall")

    return_type   = expr.args[2]
    function_name = QuoteNode(expr.args[1].args[1])
    args          = expr.args[1].args[2:end]

    arglist  = []
    typeargs = :(())
    handler  = :(dlsym($(esc(ncurses)).libncurses, $(esc(function_name)) ))
    out = :( ccall( $(handler) , $(esc(return_type)), $(esc(typeargs)) ) )

    for arg in args
        !(arg.head == :(::)) && error("All arguments must have a type.")
        push!( out.args, :( $(esc(arg.args[1])) ) )
        push!( typeargs.args, arg.args[2] )
    end

    return out
end

################################################################################
#                              NCurses functions
################################################################################

# General functions
# ==============================================================================

# This code assembles the functions by using the following information:
#
# * `f`: Function name.
# * `r`: Return type.
# * `v`: Variable name.
# * `j`: Variable type in Julia.
# * `c`: Variable type in C.

for (f,r,v,j,c) in
    (
     (:attroff,       Cint,        ["attrs"],                                       ["Integer"],                                              ["Cint"]),
     (:attron,        Cint,        ["attrs"],                                       ["Integer"],                                              ["Cint"]),
     (:box,           Cvoid,       ["win","verch","horch"],                         ["Ptr{WINDOW}","jlchtype","jlchtype"],                    ["Ptr{WINDOW}","chtype","chtype"]),
     (:cbreak,        Cvoid,       [],                                              [],                                                       []),
     (:clear,         Cint,        [],                                              [],                                                       []),
     (:clrtobot,      Cint,        [],                                              [],                                                       []),
     (:clrtoeol,      Cint,        [],                                              [],                                                       []),
     (:curs_set,      Cint,        ["visibility"],                                  ["Integer"],                                              ["Cint"]),
     (:delwin,        Cvoid,       ["win",],                                        ["Ptr{WINDOW}",],                                         ["Ptr{WINDOW}",]),
     (:derwin,        Ptr{WINDOW}, ["win","nlines","ncols","begin_y","begin_x"],    ["Ptr{WINDOW}",["Integer" for _ = 1:4]...],               ["Ptr{WINDOW}",["Cint" for _ = 1:4]...]),
     (:doupdate,      Cvoid,       [],                                              [],                                                       []),
     (:endwin,        Cvoid,       [],                                              [],                                                       []),
     (:erase,         Cint,        [],                                              [],                                                       []),
     (:getch,         Cint,        [],                                              [],                                                       []),
     (:getbegx,       Cint,        ["win"],                                         ["Ptr{WINDOW}"],                                          ["Ptr{WINDOW} "]),
     (:getbegy,       Cint,        ["win"],                                         ["Ptr{WINDOW}"],                                          ["Ptr{WINDOW} "]),
     (:getcurx,       Cint,        ["win"],                                         ["Ptr{WINDOW}"],                                          ["Ptr{WINDOW} "]),
     (:getcury,       Cint,        ["win"],                                         ["Ptr{WINDOW}"],                                          ["Ptr{WINDOW} "]),
     (:getmaxx,       Cint,        ["win"],                                         ["Ptr{WINDOW}"],                                          ["Ptr{WINDOW} "]),
     (:getmaxy,       Cint,        ["win"],                                         ["Ptr{WINDOW}"],                                          ["Ptr{WINDOW} "]),
     (:has_colors,    Cbool,       [],                                              [],                                                       []),
     (:hline,         Cint,        ["ch","n"],                                      ["jlchtype","Integer"],                                   ["chtype","Cint"]),
     (:init_color,    Cint,        ["color","r","g","b"],                           ["Integer","Integer","Integer","Integer"],                ["Cshort","Cshort","Cshort","Cshort"]),
     (:init_pair,     Cint,        ["pair","f","b"],                                ["Integer","Integer","Integer"],                          ["Cshort","Cshort","Cshort"]),
     (:initscr,       Ptr{WINDOW}, [],                                              [],                                                       []),
     (:keypad,        Cvoid,       ["win","bf"],                                    ["Ptr{WINDOW}","Bool"],                                   ["Ptr{WINDOW}","Cuchar"]),
     (:leaveok,       Cvoid,       ["win","bf"],                                    ["Ptr{WINDOW}","Bool"],                                   ["Ptr{WINDOW}","Cuchar"]),
     (:mouseinterval, Cint,        ["n"],                                           ["Integer"],                                              ["Cint"]),
     (:mvhline,       Cint,        ["y","x","ch","n"],                              ["Integer","Integer","jlchtype","Integer"],               ["Cint","Cint","chtype","Cint"]),
     (:mvvline,       Cint,        ["y","x","ch","n"],                              ["Integer","Integer","jlchtype","Integer"],               ["Cint","Cint","chtype","Cint"]),
     (:mvwhline,      Cint,        ["win","y","x","ch","n"],                        ["Ptr{WINDOW}","Integer","Integer","jlchtype","Integer"], ["Ptr{WINDOW}","Cint","Cint","chtype","Cint"]),
     (:mvwvline,      Cint,        ["win","y","x","ch","n"],                        ["Ptr{WINDOW}","Integer","Integer","jlchtype","Integer"], ["Ptr{WINDOW}","Cint","Cint","chtype","Cint"]),
     (:newpad,        Ptr{WINDOW}, ["lines","cols"],                                ["Integer","Integer"],                                    ["Cint","Cint"]),
     (:newwin,        Ptr{WINDOW}, ["lines","cols","y","x"],                        ["Integer" for _ = 1:4],                                  ["Cint" for _ = 1:4]),
     (:nodelay,       Cvoid,       ["win","bf"],                                    ["Ptr{WINDOW}","Bool"],                                   ["Ptr{WINDOW}","Cuchar"]),
     (:noecho,        Cvoid,       [],                                              [],                                                       []),
     (:notimeout,     Cvoid,       ["win","bf"],                                    ["Ptr{WINDOW}","Bool"],                                   ["Ptr{WINDOW}","Cuchar"]),
     (:refresh,       Cvoid,       [],                                              [],                                                       []),
     (:resizeterm,    Cint,        ["lines","columns"],                             ["Integer","Integer"],                                    ["Cint","Cint"]),
     (:start_color,   Cint,        [],                                              [],                                                       []),
     (:subpad,        Ptr{WINDOW}, ["win","nlines","ncols","begin_y","begin_x"],    ["Ptr{WINDOW}",["Integer" for _ = 1:4]...],               ["Ptr{WINDOW}",["Cint" for _ = 1:4]...]),
     (:touchwin,      Cvoid,       ["win",],                                        ["Ptr{WINDOW}",],                                         ["Ptr{WINDOW}",]),
     (:vline,         Cint,        ["ch","n"],                                      ["jlchtype","Integer"],                                   ["chtype","Cint"]),
     (:waddch,        Cvoid,       ["win","ch"],                                    ["Ptr{WINDOW}","jlchtype"],                               ["Ptr{WINDOW}","chtype"]),
     (:wattroff,      Cint,        ["win","attrs"],                                 ["Ptr{WINDOW}","Integer"],                                ["Ptr{WINDOW}","Cint"]),
     (:wattron,       Cint,        ["win","attrs"],                                 ["Ptr{WINDOW}","Integer"],                                ["Ptr{WINDOW}","Cint"]),
     (:wborder,       Cvoid,       ["win","ls","rs","ts","bs","tl","tr","bl","br"], ["Ptr{WINDOW}",["jlchtype" for _ = 1:8]...],              ["Ptr{WINDOW}",["chtype" for _ = 1:8]...]),
     (:wclear,        Cvoid,       ["win",],                                        ["Ptr{WINDOW}",],                                         ["Ptr{WINDOW}",]),
     (:wclrtobot,     Cint,        ["win"],                                         ["Ptr{WINDOW}"],                                          ["Ptr{WINDOW}"]),
     (:wclrtoeol,     Cint,        ["win"],                                         ["Ptr{WINDOW}"],                                          ["Ptr{WINDOW}"]),
     (:werase,        Cvoid,       ["win",],                                        ["Ptr{WINDOW}",],                                         ["Ptr{WINDOW}",]),
     (:wgetch,        Cint,        ["win"],                                         ["Ptr{WINDOW}"],                                          ["Ptr{WINDOW}"]),
     (:whline,        Cint,        ["win","ch","n"],                                ["Ptr{WINDOW}","jlchtype","Integer"],                     ["Ptr{WINDOW}","chtype","Cint"]),
     (:wmove,         Cvoid,       ["win","y","x"],                                 ["Ptr{WINDOW}","Integer","Integer"],                      ["Ptr{WINDOW}","Cint","Cint"]),
     (:wnoutrefresh,  Cvoid,       ["win",],                                        ["Ptr{WINDOW}",],                                         ["Ptr{WINDOW}",]),
     (:wrefresh,      Cvoid,       ["win",],                                        ["Ptr{WINDOW}",],                                         ["Ptr{WINDOW}",]),
     (:wtimeout,      Cvoid,       ["win","delay"],                                 ["Ptr{WINDOW}","Integer"],                                ["Ptr{WINDOW}","Cint"]),
     (:wvline,        Cint,        ["win","ch","n"],                                ["Ptr{WINDOW}","jlchtype","Integer"],                     ["Ptr{WINDOW}","chtype","Cint"]),
     # Functions with very long arguments.
     (:copywin,      Cint, ["scr","dest","sminrow","smincol","dminrow","dmincol","dmaxrow","dmaxcol","overlay"], ["Ptr{WINDOW}","Ptr{WINDOW}",["Integer" for _ = 1:7]...], ["Ptr{WINDOW}","Ptr{WINDOW}",["Cint" for _ = 1:7]...]),
     (:prefresh,     Cint, ["win","pminrow","pmincol","sminrow","smincol","smaxrow","smaxcol"],                  ["Ptr{WINDOW}",["Integer" for _ = 1:6]...],               ["Ptr{WINDOW}",["Cint" for _ = 1:6]...]),
     (:pnoutrefresh, Cint, ["win","pminrow","pmincol","sminrow","smincol","smaxrow","smaxcol"],                  ["Ptr{WINDOW}",["Integer" for _ = 1:6]...],               ["Ptr{WINDOW}",["Cint" for _ = 1:6]...])
    )

    fb    = Meta.quot(f)
    argsj = [Meta.parse(i * "::" * j) for (i,j) in zip(v,j)]
    argsc = [Meta.parse(i * "::" * j) for (i,j) in zip(v,c)]

    @eval $f($(argsj...)) = @_ccalln $f($(argsc...))::$r
    @eval export $f

    # Assemble the argument string to build the function documentation.
    args_str = ""
    for i = 1:length(v)
        args_str *= v[i] * "::" * j[i]

        if i != length(v)
            args_str *= ", "
        end
    end

    @eval begin
        @doc """
            function $($fb)($($args_str))

        **Return type**: `$($r)`

        For more information, consult `libncurses` documentation.
        """ $f
    end
end

# Functions that depends on arguments that must be `AbstractString`
# ==============================================================================

for (f,r,v,j,c) in
    (
     (:mvprintw,  Cvoid, ["y","x","str"],       ["Integer","Integer","T"],               ["Cint","Cint","Cstring"]),
     (:mvwprintw, Cvoid, ["win","y","x","str"], ["Ptr{WINDOW}","Integer","Integer","T"], ["Ptr{WINDOW}","Cint","Cint","Cstring"]),
     (:wprintw,   Cvoid, ["win","str"],         ["Ptr{WINDOW}","T"],                     ["Ptr{WINDOW}","Cstring"]),
     (:printw,    Cvoid, ["str"],               ["T"],                                   ["Cstring"]),
    )

    fb    = Meta.quot(f)
    argsj = [Meta.parse(i * "::" * j) for (i,j) in zip(v,j)]
    argsc = [Meta.parse(i * "::" * j) for (i,j) in zip(v,c)]

    @eval $f($(argsj...)) where T<:AbstractString = @_ccalln $f($(argsc...))::$r
    @eval export $f

    # Assemble the argument string to build the function documentation.
    args_str = ""
    for i = 1:length(v)
        args_str *= v[i] * "::" * j[i]

        if i != length(v)
            args_str *= ", "
        end
    end

    @eval begin
        @doc """
            function $($fb)($($args_str)) where T<:AbstractString

        **Return type**: `$($r)`

        For more information, consult `libncurses` documentation.
        """ $f
    end
end

# Other functions
# ==============================================================================

"""
    function ACS_(s::Symbol)

Return the symbol `s` of the `acs_map`. For example, `ACS_HLINE` can be obtained
from `ACS_(:HLINE)`.

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
export ACS_

"""
    function COLS()

Return the number of columns in the root window. It must be called after
`initscr()`.

For more information, consult `libncurses` documentation.

"""
function COLS()
    if !ncurses.NCURSES_REENTRANT
        ncurses.COLS == C_NULL && ( ncurses.COLS = cglobal( dlsym(ncurses.libncurses, :COLS), Cint) )
        return unsafe_load(ncurses.COLS)
    else
        return ccall(dlsym(ncurses.libncurses, :_nc_COLS), Cint, ())
    end
end
export COLS

"""
    function LINES()

Return the number of lines in the root window. It must be called after
`initscr()`.

For more information, consult `libncurses` documentation.

"""
function LINES()
    if !ncurses.NCURSES_REENTRANT
        ncurses.LINES == C_NULL && ( ncurses.LINES = cglobal( dlsym(ncurses.libncurses, :LINES), Cint) )
        return unsafe_load(ncurses.LINES)
    else
        return ccall(dlsym(ncurses.libncurses, :_nc_LINES), Cint, ())
    end
end
export LINES

# Specialization
# ==============================================================================

"""
    function wborder(win::Ptr{WINDOW})

Call the function `wborder(win, 0, 0, 0, 0, 0, 0, 0, 0)`.

"""
wborder(win::Ptr{WINDOW}) = wborder(win, 0, 0, 0, 0, 0, 0, 0, 0)

# NCurses version
# ==============================================================================

"""
    function curses_version()

Return the NCurses version in a named tuple with the following fields:

* `major`: Major version.
* `minor`: Minor version.
* `patch`: Patch version.

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
export curses_version
