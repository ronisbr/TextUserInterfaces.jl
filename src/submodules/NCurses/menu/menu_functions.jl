# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains a wrapper of all libmenu functions that are used by
#   the package.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

################################################################################
#                                Private macros
################################################################################

"""
    @_ccallm expr

Make a `ccall` to a `libmenu` function. The usage should be:

    @_ccallm function(arg1::Type1, arg2::Type2, ...)::TypeReturn

It uses the global constant structure `ncurses` to call the function. Hence, it
must be initialized.
"""
macro _ccallm(expr)
    !( expr.head == :(::) && expr.args[1].head == :call ) &&
    error("Invalid use of @_ccall")

    return_type   = expr.args[2]
    function_name = QuoteNode(expr.args[1].args[1])
    args          = expr.args[1].args[2:end]

    arglist  = []
    typeargs = :(())
    handler  = :(dlsym($(esc(ncurses)).libmenu, $(esc(function_name)) ))
    out = :( ccall( $(handler) , $(esc(return_type)), $(esc(typeargs)) ) )

    for arg in args
        !(arg.head == :(::)) && error("All arguments must have a type.")
        push!( out.args, :( $(esc(arg.args[1])) ) )
        push!( typeargs.args, arg.args[2] )
    end

    return out
end

################################################################################
#                              libform functions
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

for (f, r, v, j, c) in
    (
        (
            :current_item,
            Ptr{Cvoid},
            ["menu"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]),
        (
            :free_item,
            Cint,
            ["item"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]),
        (
            :free_menu,
            Cint,
            ["menu"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]),
        (
            :item_description,
            Cstring,
            ["menu"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]),
        (
            :item_index,
            Cint,
            ["menu"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]),
        (
            :item_name,
            Cstring,
            ["menu"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]),
        (
            :item_value,
            Cint,
            ["item"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]),
        (
            :new_menu,
            Ptr{Cvoid},
            ["items"],
            ["Vector{Ptr{Cvoid}}"],
            ["Ptr{Ptr{Cvoid}}"]),
        (
            :pos_menu_cursor,
            Cint,
            ["menu"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]),
        (
            :post_menu,
            Cint,
            ["menu"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]),
        (
            :set_menu_sub,
            Cint,
            ["menu", "win"],
            ["Ptr{Cvoid}", "Ptr{WINDOW}"],
            ["Ptr{Cvoid}", "Ptr{WINDOW}"]),
        (
            :set_menu_win,
            Cint,
            ["menu", "win"],
            ["Ptr{Cvoid}", "Ptr{WINDOW}"],
            ["Ptr{Cvoid}", "Ptr{WINDOW}"]),
        (
            :unpost_menu,
            Cint,
            ["menu"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]
        ),
    )

    fb = Meta.quot(f)
    argst = Meta.parse("(" * ([s * "," for s in j]...) * ")")
    argsj = [Meta.parse(i * "::" * j) for (i, j) in zip(v, j)]
    argsc = [Meta.parse(i * "::" * j) for (i, j) in zip(v, c)]

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
            function $($fb)($($args_str))

        **Return type**: `$($r)`

        For more information, see `libmenu` documentation.
        """
        $f($(argsj...)) = @_ccallm $f($(argsc...))::$r
        export $f
        _precompile_func($f, $argst)
    end
end

# Functions that depends on arguments that must be `Integer`
# ==============================================================================

for (f, r, v, j, c) in
    (
        (
            :menu_driver,
            Cint,
            ["menu", "c"],
            ["Ptr{Cvoid}", "T"],
            ["Ptr{Cvoid}", "Cint"]),
        (
            :set_menu_format,
            Cint,
            ["menu", "rows", "cols"],
            ["Ptr{Cvoid}", "T", "T"],
            ["Ptr{Cvoid}", "Cint", "Cint"]),
        (
            :set_menu_opts,
            Cint,
            ["menu", "opts"],
            ["Ptr{Cvoid}", "T"],
            ["Ptr{Cvoid}", "Cint"]
        ),
    )

    fb = Meta.quot(f)
    argst = Meta.parse("(" * ([s == "T" ? "Int," : s * "," for s in j]...) * ")")
    argsj = [Meta.parse(i * "::" * j) for (i, j) in zip(v, j)]
    argsc = [Meta.parse(i * "::" * j) for (i, j) in zip(v, c)]

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
            function $($fb)($($args_str)) where T<:Integer

        **Return type**: `$($r)`

        For more information, see `libmenu` documentation.
        """
        $f($(argsj...)) where {T<:Integer} = @_ccallm $f($(argsc...))::$r
        export $f
        _precompile_func($f, $argst)
    end
end

# Functions that depends on arguments that must be `AbstractString`
# ==============================================================================

for (f, r, v, j, c) in
    (
        (
            :new_item,
            Ptr{Cvoid},
            ["name", "description"],
            ["T", "T"],
            ["Cstring", "Cstring"]),
        (
            :set_menu_mark,
            Cint,
            ["menu", "mark"],
            ["Ptr{Cvoid}", "T"],
            ["Ptr{Cvoid}", "Cstring"]
        ),
    )

    fb = Meta.quot(f)
    argst = Meta.parse("(" * ([s == "T" ? "String," : s * "," for s in j]...) * ")")
    argsj = [Meta.parse(i * "::" * j) for (i, j) in zip(v, j)]
    argsc = [Meta.parse(i * "::" * j) for (i, j) in zip(v, c)]

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
            function $($fb)($($args_str)) where T<:AbstractString

        **Return type**: `$($r)`

        For more information, see `libmenu` documentation.
        """
        $f($(argsj...)) where {T<:AbstractString} = @_ccallm $f($(argsc...))::$r
        export $f
        _precompile_func($f, $argst)
    end
end
