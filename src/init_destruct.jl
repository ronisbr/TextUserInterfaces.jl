# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Description
#
#   Function related to initialization and destructions of the TUI.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export init_tui, destroy_tui

"""
    init_tui(dir::String = "")

Initialize the Text User Interface (TUI). The full-path of the ncurses directory
can be specified by `dir`. If it is empty or omitted, then it will look on the
default library directories.

"""
function init_tui(dir::String = "")
    tui.init && error("The text user interface was already initialized.")

    # Load the libraries
    # ==========================================================================

    load_ncurses(dir)

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
    destroy_tui()

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

    # Reset all colors definitions.
    empty!(_ncurses_colors)
    push!(_ncurses_colors, :black   => COLOR_BLACK,
                           :red     => COLOR_RED,
                           :green   => COLOR_GREEN,
                           :yellow  => COLOR_YELLOW,
                           :blue    => COLOR_BLUE,
                           :magenta => COLOR_MAGENTA,
                           :cyan    => COLOR_CYAN,
                           :white   => COLOR_WHITE)

    # Close log.
    if logger.file != nothing
        close(logger.file)
        logger.file = nothing
    end
end
