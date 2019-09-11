module TextUserInterfaces

using Libdl
using LinearAlgebra
using Parameters

################################################################################
#                                    Types
################################################################################

include("types.jl")

const tui = TUI()

################################################################################
#                                   Includes
################################################################################

# Ncurses bindings
# ==============================================================================

include("./ncurses/ncurses_functions.jl")
include("./ncurses/form_functions.jl")
include("./ncurses/menu_functions.jl")
include("./ncurses/panel_functions.jl")

# Other includes
# ==============================================================================

include("colors.jl")
include("focus_manager.jl")
include("forms.jl")
include("input.jl")
include("menus.jl")
include("panels.jl")
include("windows.jl")

################################################################################
#                        Initialization and destruction
################################################################################

"""
    function init_tui(dir::String = "")

Initialize the Text User Interface (TUI). The full-path of the ncurses directory
can be specified by `dir`. If it is empty or omitted, then it will look on the
default library directories.

"""
function init_tui(dir::String = "")
    tui.init && error("The text user interface was already initialized.")

    # Load the libraries
    # ==========================================================================

    l = nothing

    # libncurses
    # --------------------------------------------------------------------------

    try
        l = Libdl.dlopen(dir * "libncursesw")
    catch
        try
            l = Libdl.dlopen(dir * "libncurses")
        catch
            try
                l = Libdl.dlopen(dir * "libncursesw.so.6")
            catch
                try
                    l = Libdl.dlopen(dir * "libncurses.so.6")
                catch
                    try
                        l = Libdl.dlopen(dir * "libncursesw.so.5")
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

    # Initialize ncurses
    # ==========================================================================

    rootwin  = initscr()
    tui.init = true
    push!(tui.wins, TUI_WINDOW(id = "rootwin", parent = nothing, ptr = rootwin))
    has_colors() == 1 && start_color()

    return tui
end
export init_tui

"""
    function destroy_tui()

Destroy the Text User Interface (TUI).

"""
function destroy_tui()
    if tui.init
        destroy_all_panels()
        destroy_all_windows()
        endwin()

        # After `endwin`, we can remove the root window from the list.
        pop!(tui.wins)

        # Mark the TUI as not initialized.
        tui.init = false
    end
end
export destroy_tui

end # module
