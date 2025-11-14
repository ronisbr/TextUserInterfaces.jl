## Description #############################################################################
#
# This file constains functions to manage the window theme.
#
############################################################################################

export set_window_theme!

"""
    set_window_theme!([window::Window, ]theme::Theme) -> Nothing

Change the `theme` of the `window`. If `window` is not provided, this function only changes
the background of the root window.

!!! note

    This function marks that the `window` view needs update, but it does not perform an
    update.
"""
function set_window_theme!(theme::Theme)
    NCurses.bkgd(theme.default)
    return nothing
end

function set_window_theme!(window::Window, theme::Theme)
    window.theme = theme
    NCurses.wbkgd(window.buffer, theme.default)
    request_update!(window)
    return nothing
end
