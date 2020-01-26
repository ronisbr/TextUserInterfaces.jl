# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file defines the implementation of the functions required by the Object
#   API for the windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

get_left(win::T)   where T<:Window = win.view   != C_NULL ? Int(getbegx(win.view)) : -1
get_height(win::T) where T<:Window = win.buffer != C_NULL ? Int(getmaxy(win.buffer)) : -1
get_width(win::T)  where T<:Window = win.buffer != C_NULL ? Int(getmaxx(win.buffer)) : -1
get_top(win::T)    where T<:Window = win.view   != C_NULL ? Int(getbegy(win.view)) : -1

get_visible_height(win::T) where T<:Window = win.view != C_NULL ? Int(getmaxy(win.view)) : -1
get_visible_width(win::T)  where T<:Window = win.view != C_NULL ? Int(getmaxx(win.view)) : -1

function reposition!(win::Window; kwargs...)
    # Compute the window positioning.
    opc = object_positioning_conf(;kwargs...)

    return reposition!(win, opc)
end

function reposition!(win::Window, opc::ObjectPositioningConfiguration)
    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    if opc.vertical == :unknown
        opc.top    = 0
        opc.height = LINES()
    end

    if opc.horizontal == :unknown
        opc.left  = 0
        opc.width = COLS()
    end

    # Get the positioning information of the window.
    height, width, top, left = compute_object_positioning(opc, nothing)

    # Assign to the variables that will be used to create the window.
    begin_y = top
    begin_x = left
    nlines  = height
    ncols   = width

    # Check if we need to resize or move the window.
    win_resize = false
    win_move   = false

    if (nlines != get_visible_height(win)) || (ncols != get_visible_width(win))
        win_resize = true
    end

    if (begin_y != get_top(win)) || (begin_x != get_left(win))
        win_move = true
    end

    # If we need to resize or move window, we must clear the border first.
    # Otherwise, it will left a glitch on screen.
    if win_resize || win_move
        wclear(win.view)
        wrefresh(win.view)
    end

    # Resize window if necessary.
    win_resize && wresize(win.view, nlines, ncols)

    # Move window if necessary.
    if win_move
        mvwin(win.view, begin_y, begin_x)
        win.coord = (begin_y, begin_x)
    end

    # Check if the user wants a border.
    if win.has_border
        win.border_color >= 0 && wattron(view, win.border_color)
        wborder(win.view)
        win.border_color >= 0 && wattroff(view, win.border_color)
    end

    # Recompute the required buffer size if the user wants a border in the
    # window.
    if win.has_border
        nlines -= 2
        ncols  -= 2
    end

    # We must verify if the user initially wanted the buffer as the same size of
    # view. If so, we need to reduce the view we also must reduce the buffer.
    if win.buffer_view_locked
        blines = nlines
        bcols  = ncols
    else
        blines = maximum(nlines, get_height(win))
        bcols  = maximum(ncols,  get_width(win))
    end

    win_resize && wresize(win.buffer, blines, bcols)

    win.has_border && set_window_title(win, win.title;
                                       title_color = win.title_color)

    # If the window size has changes, then we must reposition the widget as
    # well.
    win_resize && reposition!(win.widget)

    # Refresh the window.
    refresh_window(win, force_redraw = true)

    return nothing
end
