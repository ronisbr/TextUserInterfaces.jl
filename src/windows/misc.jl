## Description #############################################################################
#
# This file contains miscellaneous functions related to windows.
#
############################################################################################

"""
    set_window_title!(win::Window, title::AbstractString, alignment::Symbol) -> Nothing

Set the title of the window `win` to `title` considering the `alignment`.
"""
function set_window_title!(win::Window, title::AbstractString, alignment::Symbol)
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
        tw_esc_title = textwidth(title_esc)

        if tw_esc_title > 0
            if alignment == :c
                Δx = div(wsx - tw_esc_title, 2)
            elseif alignment == :r
                Δx = wsx - tw_esc_title - 1
            else
                Δx = 1
            end

            @ncolor theme.title win.view begin
                NCurses.mvwprintw(win.view, 0, Δx, title_esc)
            end
        end

        # Move the cursor to the original position.
        NCurses.wmove(win.view, cury, curx)
    end

    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _get_window_coordinates(win::Ptr{WINDOW}) -> Int, Int

Get the coordinates of the window `win` and return it on a tuple `(begy, begx)`. If the
window is not initialized, this function returns `(-1, -1)`.
"""
function _get_window_coordinates(win::Ptr{WINDOW})
    if win != C_NULL
        begy = Int(NCurses.getbegy(win))
        begx = Int(NCurses.getbegx(win))

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
        wsy = Int(NCurses.getmaxy(win))
        wsx = Int(NCurses.getmaxx(win))

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
        cury = Int(NCurses.getcury(win))
        curx = Int(NCurses.getcurx(win))

        return cury, curx
    else
        return -1, -1
    end
end
