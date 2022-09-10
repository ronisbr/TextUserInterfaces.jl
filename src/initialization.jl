# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Function related to the initialization of TUI.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export initialize_tui

"""
    initialize_tui(dir::String = "")

Initialize the text user interface (TUI). The full-path of the ncurses directory
can be specified by `dir`. If it is empty or omitted, then it will look on the
default library directories.
"""
function initialize_tui(dir::String = "")
    # If the TUI is already initialized, we must destroy it first.
    tui.initialized && destroy_tui()

    # Load the libraries
    # ==========================================================================

    load_ncurses(dir)

    # Initialize ncurses
    # ==========================================================================

    tui.stdscr = initscr()
    tui.initialized = true
    has_colors() == 1 && start_color()

    # Do not echo keystrokes.
    noecho()

    @log INFO "initialize_tui" """
    TUI initialized.
    Terminal $(has_colors() == 1 ? "" : "does not ")have colors."""

    return tui
end
