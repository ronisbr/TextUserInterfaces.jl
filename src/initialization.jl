## Description #############################################################################
#
# Function related to the initialization of TUI.
#
############################################################################################

export initialize_tui

"""
    initialize_tui()

Initialize the text user interface (TUI).
"""
function initialize_tui()
    # If the TUI is already initialized, we must destroy it first.
    tui.initialized && destroy_tui()

    # == Initialize NCurses ================================================================

    tui.stdscr = NCurses.initscr()
    tui.initialized = true
    NCurses.has_colors() == 1 && NCurses.start_color()

    # Do not echo keystrokes.
    NCurses.noecho()

    # Open the log file.
    logger.file = open(logger.logfile, "w")

    @log DEBUG "initialize_tui" """
    TUI initialized.
    Terminal $(NCurses.has_colors() == 1 ? "" : "does not ")have colors."""

    # Set the default theme.
    tui.default_theme = _create_default_theme()

    return tui
end
