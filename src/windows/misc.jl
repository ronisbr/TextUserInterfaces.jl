#==# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains miscellaneous functions related to windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #==#

export get_buffer, get_height, get_width, set_window_title

"""
    function get_buffer(win::Window)

Return the buffer of the window `win`.

"""
get_buffer(win::Window) = win.buffer

"""
    function get_height(win::Window)

Return the height of the buffer of the window `win`.

"""
function get_height(win::Window)
    if win.buffer != C_NULL
        return getmaxy(win.buffer)
    else
        return -1
    end
end

"""
    function get_width(win::Window)

Return the width of the buffer of the window `win`.

"""
function get_width(win::Window)
    if win.buffer != C_NULL
        return getmaxx(win.buffer)
    else
        return -1
    end
end

"""
    function set_window_title(win::Window, title::AbstractString; ...)

Set the title of the window `win` to `title`.

# Keywords

* `title_color`: Color mask that will be used to print the title. See
                 function `ncurses_color`. If negative, then the color will not
                 be changed. (**Default** = -1)

"""
function set_window_title(win::Window, title::AbstractString;
                         title_color::Int = -1)
    win.title = title

    if win.has_border
        # Save the current cursor position.
        cury, curx = _get_window_cur_pos(win.view)

        # Get the dimensions of the border window.
        ~, wsx = _get_window_dims(win.view)

        # Escape the string to avoid problems.
        title_esc = escape_string(title)

        # Print the title if there is any character.
        length_title_esc = length(title_esc)

        if length_title_esc > 0
            col = div(wsx - length(title_esc), 2)
            title_color > 0 && wattron(win.view, title_color)
            mvwprintw(win.view, 0, col, title_esc)
            title_color > 0 && wattroff(win.view, title_color)
        end

        # Move the cursor to the original position.
        wmove(win.view, cury, curx)
    end

    return nothing
end

################################################################################
#                              Private Functions
################################################################################

"""
    function _get_window_dims(win::Ptr{WINDOW})

Get the dimensions of the window `win` and return it on a tuple `(dim_y,dim_x)`.
If the window is not initialized, then this function returns `(-1,-1)`.

"""
function _get_window_dims(win::Ptr{WINDOW})
    if win != C_NULL
        wsy = getmaxy(win)
        wsx = getmaxx(win)

        return wsy, wsx
    else
        return -1, -1
    end
end

"""
    function _get_window_cur_pos(win::Ptr{WINDOW})

Get the cursor position of the window `win` and return it on a tuple
`(cur_y,cur_x)`.  If the window is not initialized, then this function returns
`(-1,-1)`.

"""
function _get_window_cur_pos(win::Ptr{WINDOW})
    if win != C_NULL
        cury = getcury(win)
        curx = getcurx(win)

        return cury, curx
    else
        return -1, -1
    end
end

function _get_window_coord(win::Ptr{WINDOW})
    if win != C_NULL
        begy = getbegy(win)
        begx = getbegx(win)

        return begy, begx
    else
        return -1, -1
    end
end
