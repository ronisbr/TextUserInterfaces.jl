# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains a wrapper of all libpanel functions that are used by
#   the package.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

################################################################################
#                                Private macros
################################################################################

"""
    macro _ccallm(expr)

Make a `ccall` to a `libpanel` function. The usage should be:

    @_ccallf function(arg1::Type1, arg2::Type2, ...)::TypeReturn

It uses the global constant structure `ncurses` to call the function. Hence, it
must be initialized.

"""
macro _ccallp(expr)
    !( expr.head == :(::) && expr.args[1].head == :call ) &&
    error("Invalid use of @_ccall")

    return_type   = expr.args[2]
    function_name = QuoteNode(expr.args[1].args[1])
    args          = expr.args[1].args[2:end]

    arglist  = []
    typeargs = :(())
    handler  = :(dlsym($(esc(ncurses)).libpanel, $(esc(function_name)) ))
    out = :( ccall( $(handler) , $(esc(return_type)), $(esc(typeargs)) ) )

    for arg in args
        !(arg.head == :(::)) && error("All arguments must have a type.")
        push!( out.args, :( $(esc(arg.args[1])) ) )
        push!( typeargs.args, arg.args[2] )
    end

    return out
end

################################################################################
#                              libpanel functions
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
     (:bottom_panel,      Cint,       ["pan"],                     ["Ptr{Cvoid}"],                     ["Ptr{Cvoid}"]),
     (:del_panel,         Ptr{Cvoid}, ["panel"],                   ["Ptr{Cvoid}"],                     ["Ptr{Cvoid}"]),
     (:hide_panel,        Ptr{Cvoid}, ["panel"],                   ["Ptr{Cvoid}"],                     ["Ptr{Cvoid}"]),
     (:move_panel,        Cint,       ["panel","starty","startx"], ["Ptr{Cvoid}","Integer","Integer"], ["Ptr{Cvoid}","Cint","Cint"]),
     (:new_panel,         Ptr{Cvoid}, ["win"],                     ["Ptr{WINDOW}"],                    ["Ptr{WINDOW}"]),
     (:panel_userptr,     Ptr{Cvoid}, ["pan"],                     ["Ptr{Cvoid}"],                     ["Ptr{Cvoid}"]),
     (:set_panel_userptr, Cint,       ["pan","ptr"],               ["Ptr{Cvoid}","Ptr{Cvoid}"],        ["Ptr{Cvoid}","Ptr{Cvoid}"]),
     (:show_panel,        Ptr{Cvoid}, ["panel"],                   ["Ptr{Cvoid}"],                     ["Ptr{Cvoid}"]),
     (:top_panel,         Cint,       ["pan"],                     ["Ptr{Cvoid}"],                     ["Ptr{Cvoid}"]),
     (:update_panels,     Cvoid,      [],                          [],                                 []),
    )

    fb    = Meta.quot(f)
    argsj = [Meta.parse(i * "::" * j) for (i,j) in zip(v,j)]
    argsc = [Meta.parse(i * "::" * j) for (i,j) in zip(v,c)]

    @eval $f($(argsj...)) = @_ccallp $f($(argsc...))::$r
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

        For more information, consult `libmenu` documentation.
        """ $f
    end
end

