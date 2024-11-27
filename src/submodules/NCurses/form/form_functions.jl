## Description #############################################################################
#
# This file contains a wrapper of all libform functions that are used by the package.
#
############################################################################################

############################################################################################
#                                   `libform` Functions                                    #
############################################################################################

# == General Functions =====================================================================

function new_field(
    height::Int,
    width::Int,
    toprow::Int,
    leftcol::Int,
    offscreen::Int,
    nbuffers::Int
)
    @ccall new_field(
        height::Cint,
        width::Cint,
        toprow::Cint,
        leftcol::Cint,
        offscreen::Cint,
        nbuffers::Cint
    )::Ptr{Cvoid}
end

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
            :field_buffer,
            Cstring,
            ["field", "buffer"],
            ["Ptr{Cvoid}", "Integer"],
            ["Ptr{Cvoid}", "Cint"]
        ),
        (
            :form_driver,
            Cint,
            ["form", "ch"],
            ["Ptr{Cvoid}", "Integer"],
            ["Ptr{Cvoid}", "Cint"]
        ),
        (
            :free_field,
            Cint,
            ["field"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]
        ),
        (
            :free_form,
            Cint,
            ["form"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]
        ),
        (
            :new_form,
            Ptr{Cvoid},
            ["fields"],
            ["Vector{Ptr{Cvoid}}"],
            ["Ptr{Ptr{Cvoid}}"]
        ),
        (
            :pos_form_cursor,
            Cint,
            ["form"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]
        ),
        (
            :post_form,
            Cint,
            ["form"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]
        ),
        (
            :set_field_back,
            Cint,
            ["field", "value"],
            ["Ptr{Cvoid}", "Integer"],
            ["Ptr{Cvoid}", "Cuint"]
        ),
        (
            :set_field_buffer,
            Cint,
            ["field", "buf", "c"],
            ["Ptr{Cvoid}", "Integer", "AbstractString"],
            ["Ptr{Cvoid}", "Cint", "Cstring"]
        ),
        (
            :set_field_opts,
            Cint,
            ["field", "field_options"],
            ["Ptr{Cvoid}", "Integer"],
            ["Ptr{Cvoid}", "Cuint"]
        ),
        (
            :set_field_just,
            Cint,
            ["field", "justification"],
            ["Ptr{Cvoid}", "Integer"],
            ["Ptr{Cvoid}", "Cint"]
        ),
        (
            :set_field_type,
            Cint,
            ["field", "type", "arg"],
            ["Ptr{Cvoid}", "Ptr{Cvoid}", "Integer"],
            ["Ptr{Cvoid}", "Ptr{Cvoid}", "Cint"]
        ),
        (
            :set_field_type,
            Cint,
            ["field", "type", "padding", "vmin", "vmax"],
            ["Ptr{Cvoid}", "Ptr{Cvoid}", "Integer", "Integer", "Integer"],
            ["Ptr{Cvoid}", "Ptr{Cvoid}", "Cint", "Cint", "Cint"]
        ),
        (
            :set_field_type,
            Cint,
            ["field", "type", "padding", "vmin", "vmax"],
            ["Ptr{Cvoid}", "Ptr{Cvoid}", "Integer", "Float64", "Float64"],
            ["Ptr{Cvoid}", "Ptr{Cvoid}", "Cint", "Cdouble", "Cdouble"]
        ),
        (
            :set_field_type,
            Cint,
            ["field", "type", "valuelist", "checkcase", "checkunique"],
            ["Ptr{Cvoid}", "Ptr{Cvoid}", "Vector", "Integer", "Integer"],
            ["Ptr{Cvoid}", "Ptr{Cvoid}", "Ptr{Cstring}", "Cint", "Cint"]
        ),
        (
            :set_field_type,
            Cint,
            ["field", "type", "regex"],
            ["Ptr{Cvoid}", "Ptr{Cvoid}", "String"],
            ["Ptr{Cvoid}", "Ptr{Cvoid}", "Cstring"]
        ),
        (
            :set_form_opts,
            Cint,
            ["form", "form_options"],
            ["Ptr{Cvoid}", "Integer"],
            ["Ptr{Cvoid}", "Cuint"]
        ),
        (
            :set_form_win,
            Cint,
            ["form", "win_form"],
            ["Ptr{Cvoid}", "Ptr{WINDOW}"],
            ["Ptr{Cvoid}", "Ptr{WINDOW}"]
        ),
        (
            :set_form_sub,
            Cint,
            ["form", "win_form"],
            ["Ptr{Cvoid}", "Ptr{WINDOW}"],
            ["Ptr{Cvoid}", "Ptr{WINDOW}"]
        ),
        (
            :unpost_form,
            Cint,
            ["form"],
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
    for i in 1:length(v)
        args_str *= v[i] * "::" * j[i]

        if i != length(v)
            args_str *= ", "
        end
    end

    @eval begin
        """
            $($fb)($($args_str)) -> $($r)

        For more information, see `libform` documentation.
        """
        $f($(argsj...)) = @ccall $f($(argsc...))::$r
        _precompile_func($f, $argst)
    end
end

# == Global Symbols ========================================================================

for s in (
    :TYPE_ALNUM,
    :TYPE_ALPHA,
    :TYPE_ENUM,
    :TYPE_INTEGER,
    :TYPE_NUMERIC,
    :TYPE_REGEXP,
    :TYPE_IPV4,
    :TYPE_IPV6
)
    sq = Meta.quot(s)

    @eval begin
        """
            $($sq)() -> Pointer

        Return a pointer to the global symbol `$($sq)` of `libform`.
        """
        function $s()
            ptr = getfield(ncurses, $sq)
            if ptr == C_NULL
                pptr = cglobal(dlsym(ncurses.libform, $sq), Ptr{Cvoid})
                ptr  = unsafe_load(pptr)
                setfield!(ncurses, $sq, ptr)
            end

            return ptr
        end
    end
end
