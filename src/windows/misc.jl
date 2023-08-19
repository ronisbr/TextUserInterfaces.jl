# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   This file contains miscellaneous functions related to windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

"""
    set_window_title!(win::Window, title::AbstractString) -> Nothing

Set the title of the window `win` to `title`.
"""
function set_window_title!(win::Window, title::AbstractString)
    win.title = title

    if win.has_border
        theme = win.theme

        # Save the current cursor position.
        cury, curx = _get_window_cursor_position(win.view)

        # Get the dimensions of the border window.
        ~, wsx = _get_window_dimensions(win.view)

        # Escape the string to avoid problems.
        title_esc = escape_string(title)

        # Print the title if there is any character.
        length_title_esc = length(title_esc)

        if length_title_esc > 0
            col = div(wsx - length(title_esc), 2)

            @ncolor theme.title win.view begin
                mvwprintw(win.view, 0, col, title_esc)
            end
        end

        # Move the cursor to the original position.
        wmove(win.view, cury, curx)
    end

    return nothing
end

############################################################################################
#                                    Private Functions
############################################################################################

"""
    _get_window_coordinates(win::Ptr{WINDOW}) -> Int, Int

Get the coordinates of the window `win` and return it on a tuple `(begy, begx)`. If the
window is not initialized, this function returns `(-1, -1)`.
"""
function _get_window_coordinates(win::Ptr{WINDOW})
    if win != C_NULL
        begy = Int(getbegy(win))
        begx = Int(getbegx(win))

        return begy, begx
    else
        return -1, -1
    end
end

"""
    _get_window_dimensions(win::Ptr{WINDOW}) -> Int, Int

Get the dimensions of the window `win` and return it on a tuple `(dim_y, dim_x)`. If the
window is not initialized, this function returns `(-1, -1)`.
"""
function _get_window_dimensions(win::Ptr{WINDOW})
    if win != C_NULL
        wsy = Int(getmaxy(win))
        wsx = Int(getmaxx(win))

        return wsy, wsx
    else
        return -1, -1
    end
end

"""
    _get_window_cursor_position(win::Ptr{WINDOW}) -> Int, Int

Get the cursor position of the window `win` and return it on a tuple `(cur_y, cur_x)`. If
the window is not initialized, then this function returns `(-1, -1)`.
"""
function _get_window_cursor_position(win::Ptr{WINDOW})
    if win != C_NULL
        cury = Int(getcury(win))
        curx = Int(getcurx(win))

        return cury, curx
    else
        return -1, -1
    end
end
