# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Description
#
#   Function related to initialization and destructions of the TUI.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export init_tui, destroy_tui

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

    # Initialize ncurses
    # ==========================================================================

    tui.stdscr = initscr()
    tui.init   = true
    has_colors() == 1 && start_color()

    @log info "init_tui" """
    TUI initialized.
    Terminal $(has_colors() == 1 ? "" : "does not ")have colors.
    """
    return tui
end

"""
    function destroy_tui()

Destroy the Text User Interface (TUI).

"""
function destroy_tui()
    @log info "destroy_tui" "TUI will be destroyed."
    if tui.init
        @log info "destroy_tui" "TUI destroying windows."
        destroy_all_windows()
        endwin()

        # Mark the TUI as not initialized.
        tui.stdscr = Ptr{WINDOW}(0)
        tui.init = false
    end
    @log info "destroy_tui" "TUI has been destroyed."

    # Close log.
    if logger.file != nothing
        close(logger.file)
        logger.file = nothing
    end
end
