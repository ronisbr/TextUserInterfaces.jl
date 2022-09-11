
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

get_inner_left(win::Window)   = win.buffer != C_NULL ? Int(getbegx(win.buffer)) : -1
get_inner_height(win::Window) = win.buffer != C_NULL ? Int(getmaxy(win.buffer)) : -1
get_inner_width(win::Window)  = win.buffer != C_NULL ? Int(getmaxx(win.buffer)) : -1
get_inner_top(win::Window)    = win.buffer != C_NULL ? Int(getbegy(win.buffer)) : -1

request_focus(win::Window) = win.focusable

function process_keystroke(win::Window, k::Keystroke)
    return :keystroke_processed
end

@inline function update_layout!(win::Window; force::Bool = false)
    return update_layout!(win, win.layout; force = force)
end

function update_layout!(win::Window, layout::ObjectLayout; force::Bool = false)
    # Get the layout information of the window.
    height, width, top, left = process_object_layout(
        layout,
        ROOT_WINDOW;
        horizontal_hints = (
            anchor_left   = Anchor(:parent, :left,   0),
            anchor_right  = Anchor(:parent, :right,  0),
        ),
        vertical_hints = (
            anchor_bottom = Anchor(:parent, :bottom, 0),
            anchor_top    = Anchor(:parent, :top,    0),
        )
    )

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
        win.position = (begin_y, begin_x)
    end

    # Check if the user wants a border.
    if win.has_border
        win.border_color >= 0 && wattron(win.view, win.border_color)
        wborder(win.view)
        win.border_color >= 0 && wattroff(win.view, win.border_color)
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

    if win_resize || win_move || force
        refresh_window(win, force_redraw = true)
        return true
    else
        return false
    end
end
