## Description #############################################################################
#
# This file contains code related to dialogs.
#
############################################################################################

export get_window, get_returned_value, show_dialog

############################################################################################
#                                           API                                            #
############################################################################################

"""
    get_returned_value(dialog::Dialog) -> Symbol

Get the returned value of the `dialog`.
"""
get_returned_value(dialog::Dialog) = dialog.return_value

"""
    get_window(dialog::Dialog) -> Window

Return the window associated with the `dialog`.
"""
get_window(dialog::Dialog) = dialog.window

"""
    process_keystroke!(d::Dialog, k::Keystroke) -> Symbol

Process the keystroke `k` for the dialog `d`. If the dialog should be closed, return
`:close_dialog`. Any other return value will be ignored by the dialog loop in `show_dialog`.
"""
function process_keystroke!(d::Dialog, k::Keystroke)
    k.ktype == :esc && return :close_dialog
    return process_keystroke!(d.window, k)
end

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    show_dialog(dialog::Dialog) -> Symbol

Show the `dialog` and block until it is closed. This function returns a symbol with the
returned value of the dialog.
"""
function show_dialog(dialog::Dialog)
    # Store the current focused window to move it back later.
    current_window = get_focused_window()
    dialog_window  = get_window(dialog)

    unhide!(dialog_window)

    move_focus_to_window(dialog_window)

    tui_update()

    while true
        k = getkey()
        process_keystroke!(dialog, k) == :close_dialog && break
        tui_update()
    end

    hide!(dialog_window)

    @emit dialog dialog_closed

    if isnothing(current_window)
        move_focus_to_next_window()
    else
        move_focus_to_window(current_window)
    end

    tui_update()

    return get_returned_value(dialog)
end