# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains functions to refresh and update windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export refresh_window, refresh_all_windows, move_view!, move_view_inc!
export update_view!

"""
    refresh_window(id::String)

Refresh the window with `id`.
"""
function refresh_window(id::String)
    idx = findfirst(x -> x.id == id, tui.windows)
    idx === nothing && error("The window `$id` was not found.")
    return refresh_window(tui.windows[idx])
end

"""
    refresh_window(win::Window; force_redraw = false)

Refresh the window `win`. If the view needs to be updated (see
`view_needs_update`) or if `force_redraw` is `true`, then the content of the
buffer will be copied to the view before updating.
"""
function refresh_window(win::Window; force_redraw::Bool = false)
    force_redraw && wclear(win.buffer)
    update_view!(win)

    return nothing
end

"""
    refresh_all_windows()

Refresh all the windows.
"""
function refresh_all_windows()
    for win in tui.windows
        refresh_window(win)
    end

    return nothing
end

"""
    request_view_update!(win::Window)

Request to update the view of window `win`.
"""
function request_view_update!(win::Window)
    win.view_needs_update = true
    return nothing
end

#                                     View
# ==============================================================================

"""
    move_view!(win::Window, y::Int, x::Int; update::Bool = true)

Move the origin of the view of window `win` to the position `(y, x)`. This
routine makes sure that the view will never reach positions outside the buffer.
"""
function move_view!(win::Window, y::Int, x::Int; update::Bool = true)
    # This function only makes sense if the window has a buffer.
    win.buffer == C_NULL && return nothing

    # Make sure that the view rectangle will never exit the size of the buffer.
    blines, bcols = _get_window_dimensions(win.buffer)
    vlines, vcols = _get_window_dimensions(win.view)

    if y + vlines >= blines
        y = blines - vlines
    end

    if x + vcols  >= bcols
        x = bcols  - vcols
    end

    win.origin = (y, x)

    # Since the origin has moved, then the view must be updated.
    win.view_needs_update = true

    # Update the view if required.
    update && update_view!(win)

    return nothing
end

"""
    update_view!(win::Window; force::Bool = false)

Update the view of window `win` by copying the contents from the buffer. If the
view does not need to be updated (see `view_needs_update`), then nothing is
done. If the keyword `force` is `true`, then the copy will always happen.

# Return

It returns `true` if the view has been updated and `false` otherwise.
"""
function update_view!(win::Window; force::Bool = false)
    @unpack has_border, buffer, view, origin = win

    if win.view_needs_update || force
        # We need to save the cursor position to restore later.
        cy, cx = _get_window_cursor_position(view)

        # Get view dimensions.
        maxy, maxx = _get_window_dimensions(win.view)

        # Copy contents.
        #
        # Notice that position of the copied rectangle depends on whether or not
        # the window has a border.
        dminrow = has_border ? 1        : 0
        dmincol = has_border ? 1        : 0
        dmaxrow = has_border ? maxy - 2 : maxy - 1
        dmaxcol = has_border ? maxx - 2 : maxx - 1
        copywin(buffer, view, origin..., dminrow, dmincol, dmaxrow, dmaxcol, 0)

        # Tell ncurses to update the entire window.
        # touchwin(win.view)

        # Mark that the buffer has been copied.
        win.view_needs_update = false

        # Move the cursor back to the original position.
        wmove(view, cy, cx)

        @log VERBOSE "update_view!" "Window $(win.id): Buffer was copied to the view."

        return true
    else
        return false
    end
end
