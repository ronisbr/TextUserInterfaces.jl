#==# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains functions to refresh and update windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #==#

export refresh_window, refresh_all_windows, move_view, move_view_inc,
       update_view

"""
    function refresh_window(id::String)

Refresh the window with id `id` and all its parents windows except for the root
window.

"""
function refresh_window(id::String)
    idx = findfirst(x -> x.id == id, tui.wins)
    (idx == nothing) && error("The window id `$id` was not found.")
    return refresh_window(tui.wins[idx])
end

"""
    function refresh_window(win::Window; force_redraw = false)

Refresh the window `win` and its widget. If the view needs to be updated (see
`view_needs_update`) or if `force_redraw` is `true`, then the content of the
buffer will be copied to the view before updating.

"""
function refresh_window(win::Window; force_redraw = false)
    @unpack widget = win

    force_redraw && wclear(win.buffer)

    # Update the widget.
    if widget != nothing
        if update(widget; force_redraw = force_redraw)
            win.view_needs_update = true
        end
    end

    update_view(win)

    return nothing
end

"""
    function refresh_all_windows()

Refresh all the windows, including the root window.

"""
function refresh_all_windows()
    for win in tui.wins
        refresh_window(win)
    end

    return nothing
end

"""
    function request_update(win::Window)

Request update of the window `win` because its widget was updated.

"""
function request_update(win::Window)
    # TODO: This can be used to call refresh on demand!
    return nothing
end

"""
    function request_view_update(win::Window)

Request to update the view of window `win`. Notice that this must also request
update on all parent windows until the root window.

"""
function request_view_update(win::Window)
    win.parent != nothing && request_view_update(win.parent)
    win.view_needs_update = true

    return nothing
end

#                                     View
# ==============================================================================

"""
    function move_view(win::Window, y::Integer, x::Integer; update::Bool = true)

Move the origin of the view of window `win` to the position `(y,x)`. This
routine makes sure that the view will never reach positions outside the buffer.

"""
function move_view(win::Window, y::Integer, x::Integer; update::Bool = true)
    # This function only makes sense if the window has a buffer.
    win.buffer == C_NULL && return nothing

    # Make sure that the view rectangle will never exit the size of the buffer.
    blines, bcols = _get_window_dims(win.buffer)
    vlines, vcols = _get_window_dims(win.view)

    y + vlines >= blines && (y = blines - vlines)
    x + vcols  >= bcols  && (x = bcols  - vcols)

    win.orig = (y,x)

    # Since the origin has moved, then the view must be updated.
    win.view_needs_update = true

    # Update the view if required.
    if update
        update_view(win)
    end

    return nothing
end

"""
    function move_view_inc(win::Window; Δy::Integer, Δx::Integer; kwargs...)

Move the view of the window `win` to the position `(y+Δy, x+Δx)`. This function
has the same set of keywords of the function `move_view`.

"""
move_view_inc(win::Window, Δy::Integer, Δx::Integer; kwargs...) =
    move_view(win, win.orig[1]+Δy, win.orig[2]+Δx; kwargs...)

"""
    function update_view(win::Window; force::Bool = false)

Update the view of window `win` by copying the contents from the buffer. If the
view does not need to be updated (see `view_needs_update`), then nothing is
done. If the keyword `force` is `true`, then the copy will always happen.

# Return

It returns `true` if the view has been updated and `false` otherwise.

"""
function update_view(win::Window; force::Bool = false)
    @unpack has_border, buffer, view, orig = win

    if win.view_needs_update || force
        # Get view dimensions.
        maxy, maxx = _get_window_dims(win.view)

        # Copy contents.
        #
        # Notice that position of the copied rectangle depends on whether or not
        # the window has a border.
        dminrow = has_border ? 1      : 0
        dmincol = has_border ? 1      : 0
        dmaxrow = has_border ? maxy-2 : maxy-1
        dmaxcol = has_border ? maxx-2 : maxx-1
        copywin(buffer, view, orig..., dminrow, dmincol, dmaxrow, dmaxcol, 0)

        # Tell ncurses to update the entire window.
        # touchwin(win.view)

        # Mark that the buffer has been copied.
        win.view_needs_update = false

        @log verbose "update_view" "Window $(win.id): Buffer was copied to the view."

        return true
    else
        return false
    end
end
