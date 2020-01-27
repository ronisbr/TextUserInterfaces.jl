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

function reposition!(win::Window; force::Bool = false, kwargs...)
    if !isempty(kwargs)
        # Compute the window positioning.
        opc = object_positioning_conf(;kwargs...)
    else
        opc = win.opc
    end

    return reposition!(win, opc, force = force)
end

function reposition!(win::Window, opc::ObjectPositioningConfiguration;
                     force::Bool = false)

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the anchors.
    if opc.vertical == :unknown
        # TODO: Make this recreation easier.
        opc = ObjectPositioningConfiguration(
                anchor_bottom = Anchor(rootwin, :bottom, 0),
                anchor_left   = opc.anchor_left,
                anchor_right  = opc.anchor_right,
                anchor_top    = Anchor(rootwin, :top,    0),
                anchor_center = opc.anchor_center,
                anchor_middle = opc.anchor_middle,
                top           = opc.top,
                left          = opc.left,
                height        = opc.height,
                width         = opc.width
               )
    end

    if opc.horizontal == :unknown
        opc = ObjectPositioningConfiguration(
                anchor_bottom = opc.anchor_bottom,
                anchor_left   = Anchor(rootwin, :left,  0),
                anchor_right  = Anchor(rootwin, :right, 0),
                anchor_top    = opc.anchor_top,
                anchor_center = opc.anchor_center,
                anchor_middle = opc.anchor_middle,
                top           = opc.top,
                left          = opc.left,
                height        = opc.height,
                width         = opc.width
               )
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

    if (nlines != get_visible_height(win)) || (ncols != get_visible_width(win)) || force
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

    win.has_border && set_window_title(win, win.title;
                                       title_color = win.title_color)

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
