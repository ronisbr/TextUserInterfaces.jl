## Description #############################################################################
#
# This file contains functions to refresh and update windows.
#
############################################################################################

export update_window, refresh_all_windows, move_view!, move_view_inc!

"""
    update_window(id::String)

Update the window with `id`.
"""
function update_window(id::String)
    idx = findfirst(x -> x.id == id, tui.windows)
    isnothing(idx) && error("The window `$id` was not found.")
    return update!(tui.windows[idx])
end

"""
    update_all_windows(; kwargs...) -> Nothing

Update all the windows.

# Keywords

- `force::Bool`: If `true`, force the update of all windows, even if they do not require it.
    (**Default**: `false`)
"""
function update_all_windows(; force::Bool = false)
    for win in tui.windows
        update!(win; force = force)
    end

    return nothing
end

############################################################################################
#                                           View                                           #
############################################################################################

"""
    move_view!(win::Window, y::Int, x::Int; update::Bool = true) -> Nothing

Move the origin of the view of window `win` to the position `(y, x)`. This routine makes
sure that the view will never reach positions outside the buffer.
"""
function move_view!(win::Window, y::Int, x::Int; update::Bool = true)
    # This function only makes sense if the window has a buffer.
    win.buffer == C_NULL && return nothing

    # Make sure that the view rectangle will never exit the size of the buffer.
    blines, bcols = _get_window_dimensions(win.buffer)
    vlines, vcols = _get_window_dimensions(win.view)

    # We must remove the space for the border if required.
    if win.has_border
        vlines -= 2
        vcols -= 2
    end

    # Clamp values.
    y = clamp(y, 0, max(blines - vlines, 0))
    x = clamp(x, 0, max(bcols  - vcols, 0))

    win.origin = (y, x)

    # Since the origin has moved, then the view must be updated.
    request_update!(win)

    # Update the view if required.
    update && _window__update_view!(win)

    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _window__update_view!(win::Window; kwargs...) -> Bool

Update the view of window `win` by copying the contents from the buffer. If the view does
not need to be updated (see `view_needs_update`), nothing is done. If the keyword `force` is
`true`, the copy will always happen.

It returns `true` if the view has been updated or `false` otherwise.

# Keywords

- `force::Bool`: Keyword description
    (**Default**: `false`)
"""
function _window__update_view!(win::Window; force::Bool = false)
    if win.view_needs_update || force
        @unpack has_border, buffer, view, origin, theme, title, title_alignment = win
        @unpack border_style, has_border = win

        # We need to save the cursor position to restore later.
        cy, cx = _get_window_cursor_position(view)

        # Get view dimensions.
        vlines, vcols = _get_window_dimensions(win.view)

        # Get buffer dimensions.
        blines, bcols = _get_window_dimensions(win.buffer)

        # Amount of buffer that is visible at origin.
        availabel_lines = blines - origin[1]
        availabel_cols  = bcols  - origin[2]

        # Number of lines to be copied.
        copy_lines = min(vlines - (has_border ? 2 : 0), availabel_lines)
        copy_cols  = min(vcols  - (has_border ? 2 : 0), availabel_cols)

        # Copy contents.
        #
        # Notice that position of the copied rectangle depends on whether or not the window
        # has a border.
        dminrow = has_border ? 1 : 0
        dmincol = has_border ? 1 : 0
        dmaxrow = dminrow + copy_lines - 1
        dmaxcol = dmincol + copy_cols - 1

        NCurses.wclear(view)
        NCurses.copywin(
            buffer,
            view,
            origin[1],
            origin[2],
            dminrow,
            dmincol,
            dmaxrow,
            dmaxcol,
            0
        )

        # Update the border and the title since the theme might change.
        if has_border
            draw_border!(
                view;
                style           = border_style,
                theme           = theme,
                title           = title,
                title_alignment = title_alignment,
            )
            _draw_scrollbar!(win)
        end

        # Mark that the buffer has been copied.
        win.view_needs_update = false

        # Move the cursor back to the original position.
        NCurses.wmove(view, cy, cx)

        @log DEBUG "_update_view!" "Window $(win.id): Buffer was copied to the view."

        return true
    end

    return false
end
