# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file defines the implementation of the functions required by the Object
#   API for the windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

get_left(win::Window)   = win.view != C_NULL ? Int(getbegx(win.view)) : -1
get_height(win::Window) = win.view != C_NULL ? Int(getmaxy(win.view)) : -1
get_width(win::Window)  = win.view != C_NULL ? Int(getmaxx(win.view)) : -1
get_top(win::Window)    = win.view != C_NULL ? Int(getbegy(win.view)) : -1

get_left_for_child(win::Window)   = win.buffer != C_NULL ? Int(getbegx(win.buffer)) : -1
get_height_for_child(win::Window) = win.buffer != C_NULL ? Int(getmaxy(win.buffer)) : -1
get_width_for_child(win::Window)  = win.buffer != C_NULL ? Int(getmaxx(win.buffer)) : -1
get_top_for_child(win::Window)    = win.buffer != C_NULL ? Int(getbegy(win.buffer)) : -1

@inline function reposition!(win::Window; force::Bool = false)
    return reposition!(win, win.layout; force = force)
end

function reposition!(win::Window, layout::ObjectLayout; force::Bool = false)
    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the anchors.
    horizontal = _process_horizontal_info(layout)
    vertical   = _process_vertical_info(layout)

    if vertical == :unknown
        layout.anchor_bottom = Anchor(rootwin, :bottom, 0)
        layout.anchor_top    = Anchor(rootwin, :top,    0)
    end

    if horizontal == :unknown
        layout.anchor_left   = Anchor(rootwin, :left,  0)
        layout.anchor_right  = Anchor(rootwin, :right, 0)
    end

    # Get the positioning information of the window.
    height, width, top, left = compute_object_layout(layout, rootwin)

    # Assign to the variables that will be used to create the window.
    begin_y = top
    begin_x = left
    nlines  = height
    ncols   = width

    # Check if we need to resize or move the window.
    win_resize = false
    win_move   = false

    if (nlines != get_height(win)) || (ncols != get_width(win)) || force
        win_resize = true
    end

    if (begin_y != get_top(win)) || (begin_x != get_left(win)) || force
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

    win.has_border && set_window_title!(
        win,
        win.title;
        title_color = win.title_color
    )

    # If the window size has changes, then we must reposition the widget as
    # well.
    (win_resize || force) && reposition!(win.widget)

    if win_resize || win_move || force
        refresh_window(win, force_redraw = true)
        return true
    else
        return false
    end
end
