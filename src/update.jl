## Description #############################################################################
#
# Functions to update the text user interface.
#
############################################################################################

export tui_update

"""
    tui_update() -> Nothing

Update the entire TUI.
"""
function tui_update()
    update_all_windows()
    NCurses.update_panels()
    NCurses.doupdate()

    return nothing
end
