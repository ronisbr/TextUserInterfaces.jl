# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions to update the objects.
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
