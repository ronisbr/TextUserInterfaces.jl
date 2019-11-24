module NCurses

using Libdl
using Parameters

################################################################################
#                                    Types
################################################################################

include("./types.jl")

################################################################################
#                                   Includes
################################################################################

include("./ncurses_functions.jl")
include("./form/form_functions.jl")
include("./menu/menu_functions.jl")
include("./panel/panel_functions.jl")

################################################################################
#                                Initialization
################################################################################

export load_ncurses

"""
    function load_ncurses(dir::String = "")

Load ncurses libraries. The full-path of the ncurses directory can be specified
by `dir`. If it is empty or omitted, then it will look on the default library
directories.

"""
function load_ncurses(dir::String = "")
    # Load the libraries
    # ==========================================================================

    l = nothing

    # libncurses
    # --------------------------------------------------------------------------

    try
        l = Libdl.dlopen(dir * "libncursesw")
    catch
        try
            l = Libdl.dlopen(dir * "libncursesw.so.6")
        catch
            try
                l = Libdl.dlopen(dir * "libncursesw.so.5")
            catch
                try
                    l = Libdl.dlopen(dir * "libncurses")
                catch
                    try
                        l = Libdl.dlopen(dir * "libncurses.so.6")
                    catch
                        try
                            l = Libdl.dlopen(dir * "libncurses.so.5")
                        catch
                            error("Could not load libncurses. Check your installation.")
                        end
                    end
                end
            end
        end
    end
    ncurses.libncurses = l

    # Find if ncurses was compiled with `NCURSES_REENTRANT` option.
    try
        cglobal( dlsym(ncurses.libncurses, :stdscr) )
    catch
        ncurses.NCURSES_REENTRANT = true
    end

    # libpanel
    # --------------------------------------------------------------------------

    try
        l = Libdl.dlopen(dir * "libpanelw")
    catch
        try
            l = Libdl.dlopen(dir * "libpanel")
        catch
            try
                l = Libdl.dlopen(dir * "libpanelw.so.6")
            catch
                try
                    l = Libdl.dlopen(dir * "libpanel.so.6")
                catch
                    try
                        l = Libdl.dlopen(dir * "libpanelw.so.5")
                    catch
                        try
                            l = Libdl.dlopen(dir * "libpanel.so.5")
                        catch
                            error("Could not load libpanel. Check your installation.")
                        end
                    end
                end
            end
        end
    end
    ncurses.libpanel = l

    # libform
    # --------------------------------------------------------------------------

    try
        l = Libdl.dlopen(dir * "libformw")
    catch
        try
            l = Libdl.dlopen(dir * "libform")
        catch
            try
                l = Libdl.dlopen(dir * "libformw.so.6")
            catch
                try
                    l = Libdl.dlopen(dir * "libform.so.6")
                catch
                    try
                        l = Libdl.dlopen(dir * "libformw.so.5")
                    catch
                        try
                            l = Libdl.dlopen(dir * "libform.so.5")
                        catch
                            error("Could not load libform. Check your installation.")
                        end
                    end
                end
            end
        end
    end
    ncurses.libform = l

    # libmenu
    # --------------------------------------------------------------------------

    try
        l = Libdl.dlopen(dir * "libmenuw")
    catch
        try
            l = Libdl.dlopen(dir * "libmenu")
        catch
            try
                l = Libdl.dlopen(dir * "libmenuw.so.6")
            catch
                try
                    l = Libdl.dlopen(dir * "libmenu.so.6")
                catch
                    try
                        l = Libdl.dlopen(dir * "libmenuw.so.5")
                    catch
                        try
                            l = Libdl.dlopen(dir * "libmenu.so.5")
                        catch
                            error("Could not load libmenu. Check your installation.")
                        end
                    end
                end
            end
        end
    end
    ncurses.libmenu = l
end

end # module
