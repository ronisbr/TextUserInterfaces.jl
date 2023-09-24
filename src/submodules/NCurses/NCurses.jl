module NCurses

using Libdl
using Ncurses_jll
using Parameters

############################################################################################
#                                          Types
############################################################################################

include("./types.jl")

############################################################################################
#                                      Precompilation
############################################################################################

# Precompile the NCurses exported functions.
@inline function _precompile_func(func, args)
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    return precompile(func, args)
end

############################################################################################
#                                         Includes
############################################################################################

include("./ncurses_functions.jl")
include("./form/form_functions.jl")
include("./menu/menu_functions.jl")
include("./panel/panel_functions.jl")

############################################################################################
#                                      Initialization
############################################################################################

export load_ncurses, init_ncurses

"""
    load_ncurses([dir::String]) -> Nothing

Load ncurses libraries at directory `dir`. If it is omitted or if it is empty, then the
bundled Ncurses version in the package `Ncurses_jll` will be used.
"""
function load_ncurses()
    ncurses.libncurses        = Ncurses_jll.libncurses_handle
    ncurses.libmenu           = Ncurses_jll.libmenu_handle
    ncurses.libpanel          = Ncurses_jll.libpanel_handle
    ncurses.libform           = Ncurses_jll.libform_handle
    ncurses.NCURSES_REENTRANT = false

    # If we use the ncurses from `Ncurses_jll`, we must tell its terminfo directory as
    # stated in:
    #
    #   https://github.com/JuliaPackaging/Yggdrasil/issues/455
    #
    # TODO: Maybe we can set this directory locally. As pointed out by @giordano, this can
    # break other packages that uses they own ncurses instances.
    ENV["TERMINFO_DIRS"] = joinpath(
        Ncurses_jll.artifact_dir,
        "share",
        "terminfo"
    )

    return nothing
end

function load_ncurses_library(dir::AbstractString, key::Symbol, candidates)
    for lib in candidates
        l = dlopen(joinpath(dir, lib); throw_error=false)
        if l !== nothing
            setfield!(ncurses, key, l)
            return nothing
        end
    end

    error("Could not load $key. Check your installation.")
end

function load_ncurses(dir::String)
    # Load the Libraries
    # ======================================================================================

    isempty(dir) && return load_ncurses()

    # libncurses
    # --------------------------------------------------------------------------------------

    candidates = (
        "libncursesw",
        "libncursesw.so.6",
        "libncursesw.so.5",
        "libncurses",
        "libncursesw",
        "libncurses.so.6",
        "libncurses.so.5",
    )

    load_ncurses_library(dir, :libncurses, candidates)

    # Find if ncurses was compiled with `NCURSES_REENTRANT` option.
    try
        cglobal(dlsym(ncurses.libncurses, :stdscr))
    catch
        ncurses.NCURSES_REENTRANT = true
    end

    # libpanel
    # --------------------------------------------------------------------------------------

    candidates = (
        "libpanelw",
        "libpanel",
        "libpanelw.so.6",
        "libpanel.so.6",
        "libpanelw.so.5",
        "libpanel.so.5"
    )

    load_ncurses_library(dir, :libpanel, candidates)

    # libform
    # --------------------------------------------------------------------------------------

    candidates = (
        "libformw",
        "libform",
        "libformw.so.6",
        "libform.so.6",
        "libformw.so.5",
        "libform.so.5"
    )

    load_ncurses_library(dir, :libform, candidates)

    # libmenu
    # --------------------------------------------------------------------------------------

    candidates = (
        "libmenuw",
        "libmenu",
        "libmenuw.so.6",
        "libmenu.so.6",
        "libmenuw.so.5",
        "libmenu.so.5"
    )

    load_ncurses_library(dir, :libmenu, candidates)

    return nothing
end

end # module
