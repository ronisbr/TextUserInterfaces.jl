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
    if NCurses.has_colors() == 1
        NCurses.start_color()
        NCurses.use_default_colors()
    end

    # Do not echo keystrokes.
    NCurses.noecho()

    # Open the log file.
    logger.file = open(logger.logfile, "w")

    @log DEBUG "initialize_tui" """
        TUI initialized.
        Terminal $(NCurses.has_colors() == 1 ? "" : "does not ")have colors."""

    # Reset all colors definitions.
    _reset_color_dict()
    empty!(tui.initialized_color_pairs)

    # Reset the default theme.
    empty!(tui.default_theme)
    _fill_with_default_theme!(tui.default_theme)

    # Set the default theme.
    set_window_theme!(tui.default_theme)

    return tui
end
