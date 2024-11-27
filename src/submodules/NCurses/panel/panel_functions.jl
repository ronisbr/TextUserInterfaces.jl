## Description #############################################################################
#
# This file contains a wrapper of all libpanel functions that are used by the package.
#
############################################################################################

############################################################################################
#                                   `libpanel` functions                                   #
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
            :bottom_panel,
            Cint,
            ["pan"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]
        ),
        (
            :del_panel,
            Ptr{Cvoid},
            ["panel"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]
        ),
        (
            :hide_panel,
            Ptr{Cvoid},
            ["panel"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]
        ),
        (
            :move_panel,
            Cint,
            ["panel", "starty", "startx"],
            ["Ptr{Cvoid}", "Integer", "Integer"],
            ["Ptr{Cvoid}", "Cint", "Cint"]
        ),
        (
            :new_panel,
            Ptr{Cvoid},
            ["win"],
            ["Ptr{WINDOW}"],
            ["Ptr{WINDOW}"]
        ),
        (
            :panel_userptr,
            Ptr{Cvoid},
            ["pan"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]
        ),
        (
            :set_panel_userptr,
            Cint,
            ["pan", "ptr"],
            ["Ptr{Cvoid}", "Ptr{Cvoid}"],
            ["Ptr{Cvoid}", "Ptr{Cvoid}"]
        ),
        (
            :show_panel,
            Ptr{Cvoid},
            ["panel"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]
        ),
        (
            :top_panel,
            Cint,
            ["pan"],
            ["Ptr{Cvoid}"],
            ["Ptr{Cvoid}"]
        ),
        (
            :update_panels,
            Cvoid,
            [],
            [],
            []
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

        For more information, see `libmenu` documentation.
        """
        $f($(argsj...)) = @ccall $f($(argsc...))::$r
        _precompile_func($f, $argst)
    end
end
