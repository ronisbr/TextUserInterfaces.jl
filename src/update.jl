## Description #############################################################################
#
# Functions to update the text user interface.
#
############################################################################################

export tui_update

"""
    tui_update(; kwargs...) -> Nothing

Update the entire TUI.

# Keywords

- `force::Bool`: If `true`, force the update of all windows, even if they do not require it.
    (**Default**: `false`)
"""
function tui_update(; force::Bool = false)
    update_all_windows(; force = force)
    NCurses.update_panels()
    NCurses.doupdate()

    return nothing
end
