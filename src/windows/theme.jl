## Description #############################################################################
#
# This file constains functions to manage the window theme.
#
############################################################################################

export set_window_theme!

"""
    set_window_theme!(window::Window, theme::Theme) -> Nothing

Change the `theme` of the `window`. This function marks that the `window` view needs update,
but it does not perform an update.
"""
function set_window_theme!(window::Window, theme::Theme)
    window.theme = theme
    NCurses.wbkgd(window.buffer, theme.default)
    request_update!(window)
    return nothing
end
