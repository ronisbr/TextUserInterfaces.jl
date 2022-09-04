# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions to update the text user interface.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export tui_update

"""
    tui_update()

Update the entire TUI.
"""
function tui_update()
    refresh_all_windows()
    update_panels()
    doupdate()

    return nothing
end
