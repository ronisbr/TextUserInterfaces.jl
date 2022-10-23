
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file defines the implementation of the functions required by the Object
#   API for the windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

can_accept_focus(win::Window) = win.focusable
can_release_focus(win::Window) = true

function destroy!(win::Window)
    @log INFO "destroy!" "$(obj_desc(win)) will be destroyed."
    @log_ident 1

    # Destroy the widget container.
    destroy!(win.widget_container)

    # Delete everything.
    if win.panel != C_NULL
        del_panel(win.panel)
        win.panel = Ptr{Cvoid}(0)
    end

    if win.buffer != C_NULL
        delwin(win.buffer)
        win.buffer = Ptr{WINDOW}(0)
    end

    if win.view != C_NULL
        delwin(win.view)
        win.view = Ptr{WINDOW}(0)
    end

    # Remove the window from the global list.
    idx = findall(x -> x === win, tui.windows)
    deleteat!(tui.windows, idx)

    @log_ident 0
    @log INFO "destroy!" "Window destroyed: $(win.id)."

    return nothing
end

get_left(win::Window)   = win.view != C_NULL ? Int(getbegx(win.view)) : -1
get_height(win::Window) = win.view != C_NULL ? Int(getmaxy(win.view)) : -1
get_width(win::Window)  = win.view != C_NULL ? Int(getmaxx(win.view)) : -1
get_top(win::Window)    = win.view != C_NULL ? Int(getbegy(win.view)) : -1

get_inner_left(win::Window)   = win.buffer != C_NULL ? Int(getbegx(win.buffer)) : -1
get_inner_height(win::Window) = win.buffer != C_NULL ? Int(getmaxy(win.buffer)) : -1
get_inner_width(win::Window)  = win.buffer != C_NULL ? Int(getmaxx(win.buffer)) : -1
get_inner_top(win::Window)    = win.buffer != C_NULL ? Int(getbegy(win.buffer)) : -1

function process_keystroke!(win::Window, k::Keystroke)
    process_keystroke!(win.widget_container, k)
    return :keystroke_processed
end

function release_focus!(win::Window)
    container = win.widget_container

    if !isnothing(container)
        release_focus!(container)
    end

    return nothing
end

function request_update!(win::Window)
    win.view_needs_update = true
    return nothing
end

function update!(win::Window; force::Bool = false)
    @unpack buffer, has_border, widget_container, view, theme, title = win

    force && wclear(buffer)

    # Update the widget container. If it was updated, then we must mark that the
    # view in this window needs update.
    if update!(widget_container; force = force)
        request_update!(win)
    end

    _update_view!(win)

    # Update the border and the title since the theme might change.
    has_border && @ncolor theme.border view begin
        wborder(view)
        set_window_title!(win, title)
    end

    return nothing
end

function update_layout!(win::Window; force::Bool = false)
    @unpack layout, theme = win

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
    win.has_border && @ncolor theme.border win.view begin
        wborder(win.view)
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

    win.has_border && set_window_title!(win, win.title)

    if win_resize || win_move || force
        # Here, we need to update the layout of the container because the window
        # changed.
        update_layout!(win.widget_container; force = true)

        # Now, we update the window.
        update!(win, force = true)
        return true
    else
        return false
    end
end
