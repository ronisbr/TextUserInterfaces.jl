## Description #############################################################################
#
# This file contains miscellaneous functions related to windows.
#
############################################################################################

export hide!, unhide!

"""
    hide!(win::Window) -> Nothing

Hide the window `win`. When the window is hidden, it is not visible on the screen and cannot
gain focus. If `win` has focus, the focus is moved to the next available window.
"""
function hide!(win::Window)
    # If the window has focus, move the focus to the next available window.
    focused_win = get_focused_window()
    win === focused_win && move_focus_to_next_window()

    win.hidden = true
    NCurses.hide_panel(win.panel)

    return nothing
end

"""
    unhide!(win::Window) -> Nothing

Unhide the window `win`.
"""
function unhide!(win::Window)
    win.hidden = false
    NCurses.show_panel(win.panel)

    return nothing
end

"""
    resize_buffer_to_fit_contents!(window::Window) -> Nothing

Resize the buffer of the `window` to fit the contents of its widget container.
"""
function resize_buffer_to_fit_contents!(window::Window)
    @unpack widget_container = window

    isnothing(widget_container) && return nothing

    max_height, max_width = content_dimension_limits(widget_container)

    blines, bcols = _get_window_dimensions(window.buffer)

    new_height = max(blines, max_height)
    new_width  = max(bcols,  max_width)

    if (new_height != blines) || (new_width != bcols)
        window.buffer_view_locked = false
        NCurses.wresize(window.buffer, new_height, new_width)
        update_layout!(window; force = true)
    end

    return nothing
end

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

            @ncolor get_color(theme, :title) win.view begin
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
    _draw_scrollbar!(window::Window) -> Nothing

Draw the scrollbars for the `window` if it has a border.
"""
function _draw_scrollbar!(window::Window)
    @unpack view, buffer, origin, has_border = window

    !has_border && return nothing

    # Save the current cursor position.
    cury, curx = _get_window_cursor_position(window.view)

    # Get the dimensions of the window.
    nlines, ncols = _get_window_dimensions(view)
    blines, bcols = _get_window_dimensions(buffer)

    # Remove the borders.
    nlines -= 2
    ncols  -= 2

    # Compute the size and position of the horizontal scrollbar.
    hsb_size = max(1, round(Int, ncols * ncols / bcols))
    hsb_pos  = round(Int, origin[2] * ncols / bcols)

    # Compute the size and position of the vertical scrollbar.
    vsb_size = max(1, round(Int, nlines * nlines / blines))
    vsb_pos  = round(Int, origin[1] * nlines / blines)

    # If the entire buffer fits in the view, no need to draw scrollbars.
    draw_hsb = hsb_size < ncols
    draw_vsb = vsb_size < nlines

    # Draw the horizontal scrollbar.
    draw_hsb && @ncolor get_color(window.theme, :border) view begin
        for x in 1:hsb_size
            NCurses.mvwprintw(
                view,
                nlines + 1,
                hsb_pos + x,
                "▄"
            )
        end
    end

    # Draw the vertical scrollbar.
    draw_vsb && @ncolor get_color(window.theme, :border) view begin
        for y in 1:vsb_size
            NCurses.mvwprintw(
                view,
                vsb_pos + y,
                ncols + 1,
                "▐"
            )
        end
    end

    # Move the cursor to the original position.
    NCurses.wmove(window.view, cury, curx)

    return nothing
end

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
