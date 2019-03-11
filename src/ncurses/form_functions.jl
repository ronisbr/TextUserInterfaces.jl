# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains a wrapper of all libform functions that are used by
#   the package.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

################################################################################
#                                Private macros
################################################################################

"""
    macro _ccallf(expr)

Make a `ccall` to a `libform` function. The usage should be:

    @_ccallf function(arg1::Type1, arg2::Type2, ...)::TypeReturn

It uses the global constant structure `ncurses` to call the function. Hence, it
must be initialized.

"""
macro _ccallf(expr)
    !( expr.head == :(::) && expr.args[1].head == :call ) &&
    error("Invalid use of @_ccall")

    return_type   = expr.args[2]
    function_name = QuoteNode(expr.args[1].args[1])
    args          = expr.args[1].args[2:end]

    arglist  = []
    typeargs = :(())
    handler  = :(dlsym($(esc(ncurses)).libform, $(esc(function_name)) ))
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

new_field(height::Int, width::Int, toprow::Int, leftcol::Int, offscreen::Int,
          nbuffers::Int) =
    @_ccallf new_field(height::Cint, width::Cint, toprow::Cint, leftcol::Cint,
                       offscreen::Cint, nbuffers::Cint)::Ptr{Cvoid}
export new_field

# This code assembles the functions by using the following information:
#
# * `f`: Function name.
# * `r`: Return type.
# * `v`: Variable name.
# * `j`: Variable type in Julia.
# * `c`: Variable type in C.

for (f,r,v,j,c) in
     (
     (:field_buffer,     Cstring,    ["field","buffer"],                                     ["Ptr{Cvoid}","Integer"],                                  ["Ptr{Cvoid}","Cint"]),
     (:form_driver,      Cint,       ["form","ch"],                                          ["Ptr{Cvoid}","Integer"],                                  ["Ptr{Cvoid}","Cint"]),
     (:free_field,       Cint,       ["field"],                                              ["Ptr{Cvoid}"],                                            ["Ptr{Cvoid}"]),
     (:free_form,        Cint,       ["form"],                                               ["Ptr{Cvoid}"],                                            ["Ptr{Cvoid}"]),
     (:new_form,         Ptr{Cvoid}, ["fields"],                                             ["Vector{Ptr{Cvoid}}"],                                    ["Ptr{Ptr{Cvoid}}"]),
     (:pos_form_cursor,  Cint,       ["form"],                                               ["Ptr{Cvoid}"],                                            ["Ptr{Cvoid}"]),
     (:post_form,        Cint,       ["form"],                                               ["Ptr{Cvoid}"],                                            ["Ptr{Cvoid}"]),
     (:set_field_back,   Cint,       ["field","value"],                                      ["Ptr{Cvoid}","Integer"],                                  ["Ptr{Cvoid}","Cuint"]),
     (:set_field_opts,   Cint,       ["field","field_options"],                              ["Ptr{Cvoid}","Integer"],                                  ["Ptr{Cvoid}","Cuint"]),
     (:set_field_just,   Cint,       ["field","justification"],                              ["Ptr{Cvoid}","Integer"],                                  ["Ptr{Cvoid}","Cint"]),
     (:set_field_type,   Cint,       ["field","type","arg"],                                 ["Ptr{Cvoid}","Ptr{Cvoid}","Integer"],                     ["Ptr{Cvoid}","Ptr{Cvoid}","Cint"]),
     (:set_field_type,   Cint,       ["field","type","padding","vmin","vmax"],               ["Ptr{Cvoid}","Ptr{Cvoid}","Integer","Integer","Integer"], ["Ptr{Cvoid}","Ptr{Cvoid}","Cint","Cint","Cint"]),
     (:set_field_type,   Cint,       ["field","type","padding","vmin","vmax"],               ["Ptr{Cvoid}","Ptr{Cvoid}","Integer","Float64","Float64"], ["Ptr{Cvoid}","Ptr{Cvoid}","Cint","Cdouble","Cdouble"]),
     (:set_field_type,   Cint,       ["field","type","regex"],                               ["Ptr{Cvoid}","Ptr{Cvoid}","String"],                      ["Ptr{Cvoid}","Ptr{Cvoid}","Cstring"]),
     (:set_field_type,   Cint,       ["field","type","valuelist","checkcase","checkunique"], ["Ptr{Cvoid}","Ptr{Cvoid}","Vector","Integer","Integer"],  ["Ptr{Cvoid}","Ptr{Cvoid}","Ptr{Cstring}","Cint","Cint"]),
     (:set_form_opts,    Cint,       ["form","form_options"],                                ["Ptr{Cvoid}","Integer"],                                  ["Ptr{Cvoid}","Cuint"]),
     (:set_form_win,     Cint,       ["form","win_form"],                                    ["Ptr{Cvoid}","Ptr{WINDOW}"],                              ["Ptr{Cvoid}","Ptr{WINDOW}"]),
     (:set_form_sub,     Cint,       ["form","win_form"],                                    ["Ptr{Cvoid}","Ptr{WINDOW}"],                              ["Ptr{Cvoid}","Ptr{WINDOW}"]),
     (:unpost_form,      Cint,       ["form"],                                               ["Ptr{Cvoid}"],                                            ["Ptr{Cvoid}"]),
    )

    fb    = Meta.quot(f)
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
            function $($fb)($($args_str))

        **Return type**: `$($r)`

        For more information, consult `libform` documentation.
        """
        $f($(argsj...)) = @_ccallf $f($(argsc...))::$r
    end
    @eval export $f
end

# Functions that depends on arguments that must be `AbstractString`
# ==============================================================================

for (f,r,v,j,c) in
    (
     (:set_field_buffer, Cint, ["field","buf","c"], ["Ptr{Cvoid}","Int","T"], ["Ptr{Cvoid}","Cint","Cstring"]),
    )

    fb    = Meta.quot(f)
    argsj = [Meta.parse(i * "::" * j) for (i,j) in zip(v,j)]
    argsc = [Meta.parse(i * "::" * j) for (i,j) in zip(v,c)]

    @eval $f($(argsj...)) where T<:AbstractString = @_ccallf $f($(argsc...))::$r
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

        For more information, consult `libform` documentation.
        """ $f
    end
end

# Global symbols
# ==============================================================================

for s in (:TYPE_ALNUM, :TYPE_ALPHA, :TYPE_ENUM, :TYPE_INTEGER, :TYPE_NUMERIC,
          :TYPE_REGEXP, :TYPE_IPV4, :TYPE_IPV6)

    sq = Meta.quot(s)

    @eval begin
        function $s()
            ptr = getfield(ncurses, $sq)
            if ptr == C_NULL
                pptr = cglobal( dlsym(ncurses.libform, $sq), Ptr{Cvoid})
                ptr  = unsafe_load(pptr)
                setfield!(ncurses, $sq, ptr)
            end

            return ptr
        end
        export $s
    end

    @eval begin
        @doc """
            function $($sq)()

        Return a pointer to the global symbol `$($sq)` of `libform`.

        """ $s
    end
end
