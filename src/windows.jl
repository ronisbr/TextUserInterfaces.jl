# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains functions related to windows handling.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export clear_window, create_window, create_window_layout, destroy_all_windows,
       destroy_window, hide_window, move_view, move_view_inc,
       move_window_to_top, refresh_all_windows, refresh_window,
       request_view_update, set_window_title!, show_window, window_print,
       window_println, update_view

# Functions related to window creation and destruction
# ==============================================================================

"""
    function create_window(parent::Union{Nothing,TUI_WINDOW}, nlines::Integer, ncols::Integer, begin_y::Integer, begin_x::Integer, id::String = ""; has_buffer::Bool = true, bcols::Integer = 0, blines::Integer = 0, border::Bool = true, border_color::Int = -1, title::String = "", title_color::Int = -1)

Create a window inside the parent window `parent`. If `parent` is `nothing` or
if it is omitted, then the root window will be used as the parent window. The
new window size will be `nlines × ncols` and the origin will be placed at
`(begin_y, begin_x)` coordinate of the parent window. The window ID `id` is used
to identify the new window in the global window list.

# Keyword

* `has_buffer`: If `true`, then the window will have a buffer.
                (**Default** = `false`)
* `bcols`: Number of columns in the window buffer. This will be automatically
           increased to, at least, fit the viewable part of the window
           (`ncols`). (**Default** = 0)
* `blines`: Number of lines in the window buffer. This will be automatically
            increased to, at least, fit the viewable part of the window
            (`nlines`). (**Default** = 0)
* `border`: If `true`, then the window will have a border. (**Default** =
            `true`)
* `border_color`: Color mask that will be used to print the border. See function
                  `ncurses_color`. If negative, then the color will not be
                  changed. (**Default** = -1)
* `title`: The title of the window, which will only be printed if `border` is
           `true`. (**Default** = "")
* `title_color`: Color mask that will be used to print the title. See
                 function `ncurses_color`. If negative, then the color will not
                 be changed. (**Default** = -1)

"""
create_window(vargs...; kwargs...) = create_window(nothing, vargs...; kwargs...)

function create_window(parent::Union{Nothing,TUI_WINDOW}, nlines::Integer,
                       ncols::Integer, begin_y::Integer, begin_x::Integer,
                       id::String = ""; has_buffer::Bool = false,
                       bcols::Integer = 0, blines::Integer = 0,
                       border::Bool = true, border_color::Int = -1,
                       title::String = "", title_color::Int = -1)

    # Check if the TUI has been initialized.
    !tui.init && error("The text user interface was not initialized.")

    # If the user does not specify an `id`, then we choose based on the number
    # of available windows.
    length(id) == 0 && ( id = string(length(tui.wins)) )

    # Check what will be the parent window.
    if parent != nothing
        win_parent = parent.ptr
    else
        win_parent = Ptr{WINDOW}(0)
    end

    # If the user wants a border, then we create two windows: one to store the
    # borders and other to store the elements.
    if border
        win_border = (parent == nothing) ? newwin(            nlines, ncols, begin_y, begin_x) :
                                           derwin(win_parent, nlines, ncols, begin_y, begin_x)
        border_color >= 0 && wattron(win_border, border_color)
        wborder(win_border)
        border_color >= 0 && wattroff(win_border, border_color)

        # In this case, the coordinate of the beginning of the view with respect
        # to the parent window must be corrected due to the border.
        begin_y += 1
        begin_x += 1

        # Get buffer size.
        if has_buffer
            blines < nlines-2 && (blines = nlines-2)
            bcols  < ncols-2  && (bcols  = ncols-2)
        end

        # Create the window view.
        view = derwin(win_border, nlines-2, ncols-2, 1, 1)

        # Set the foremost element.
        foremost = win_border

        # Create the panels.
        panel_border = new_panel(win_border)
        panel_view   = new_panel(view)
        panel        = panel_border
    else
        # In this case, we do not have a window to hold a border.
        win_border = Ptr{WINDOW}(0)

        # Get buffer size.
        if has_buffer
            blines < nlines && (blines = nlines)
            bcols  < ncols  && (bcols  = ncols)
        end

        # Create the window view.
        view = (parent == nothing) ? newwin(            nlines, ncols, begin_y, begin_x) :
                                     derwin(win_parent, nlines, ncols, begin_y, begin_x)

        # Set the foremost element.
        foremost = view

        # Create the panels.
        panel_border = Ptr{Cvoid}(0)
        panel_view   = new_panel(view)
        panel        = panel_view
    end

    # Create the buffer if necessary.
    buffer = has_buffer ? newpad(blines, bcols) : Ptr{Cvoid}(0)

    # Pointer to the container that must handler the children elements.
    ptr = has_buffer ? buffer : view

    # Compute the window coordinate with respect to the screen.
    coord = (begin_y, begin_x)
    if parent != nothing
        coord = coord .+ parent.coord
    end

    # Create the window object and add to the global list.
    win = TUI_WINDOW(id = id, title = title, coord = coord, parent = parent,
                     border = win_border, ptr = ptr, foremost = foremost,
                     buffer = buffer, view = view, panel = panel,
                     panel_border = panel_border, panel_view = panel_view)
    border && set_window_title!(win, title; title_color = title_color)
    push!(tui.wins, win)
    parent != nothing && push!(parent.children, win)

    # Return the pointer to the window.
    return win
end

"""
    function create_window_layout(parent::TUI_WINDOW, vert::Vector{T1}, horz::Vector{T2}) where {T1<:Number, T2<:Number}

Create a window layout inside the parent window `parent`. If it is omitted, then
the root window will be used as parent.

The layout dimensions is obtained from the vectors `vert` and `horz`. They will
be interpreted as a percentage of the total size. For example, if `vert =
[50,25,25]`, then the layout will have three lines in each the first will have
50% of the total size, and the second and third 25%. The same applies for the
`horz` vector for the columns size of the layout.

This function return a matrix with the windows references.

"""
function create_window_layout(vert::Vector{T1}, horz::Vector{T2}) where {T1<:Number, T2<:Number}
    create_window_layout(tui.wins[1], vert, horz)
end

function create_window_layout(parent::TUI_WINDOW, vert::Vector{T1},
                              horz::Vector{T2}) where {T1<:Number, T2<:Number}

    vert  = abs.(vert)
    vert /= sum(vert)
    horz  = abs.(horz)
    horz /= sum(horz)
    nv    = length(vert)
    nh    = length(horz)

    # Get the dimensions of the parent window.
    wsy, wsx = _get_window_dims(parent)

    # Compute the horizontal and vertical sizes of the grid.
    sy = Vector{Int}(undef, nv)
    sx = Vector{Int}(undef, nh)

    acc = 0
    for i = 1:nv
        sy[i]  = i != nv ? round(Int, vert[i]*wsy) : wsy - acc
        acc   += sy[i]
    end

    acc = 0
    for i = 1:nh
        sx[i]  = i != nv ? round(Int, horz[i]*wsx) : wsx - acc
        acc   += sx[i]
    end

    # Create the windows.
    win_grid = Matrix{TUI_WINDOW}(undef,nv,nh)

    beg_x = 0
    beg_y = 0

    for i = 1:nv
        for j = 1:nh
            win_grid[i,j] = create_window(parent, sy[i], sx[j], beg_y, beg_x)
            beg_x += sx[j]
        end

        beg_x  = 0
        beg_y += sy[i]
    end

    return win_grid
end

"""
    function destroy_window(win::TUI_WINDOW)

Destroy the window `win`.

"""
function destroy_window(win::TUI_WINDOW)
    # Delete everything.
    if win.panel_border != C_NULL
        del_panel(win.panel_border)
        win.panel_border = Ptr{Cvoid}(0)
    end

    if win.panel_view != C_NULL
        del_panel(win.panel_view)
        win.panel_view = Ptr{Cvoid}(0)
    end

    win.panel = Ptr{WINDOW}(0)

    if win.buffer != C_NULL
        delwin(win.buffer)
        win.buffer  = Ptr{WINDOW}(0)
    end

    if win.view != C_NULL
        delwin(win.view)
        win.view = Ptr{WINDOW}(0)
    end

    if win.border != C_NULL
        delwin(win.border)
        win.border = Ptr{WINDOW}(0)
    end

    # Remove the window from the global list.
    idx = findall(x->x == win, tui.wins)
    deleteat!(tui.wins, idx)

    return nothing
end

"""
    function destroy_all_windows()

Destroy all windows managed by the TUI.

"""
function destroy_all_windows()
    # Notice that we must not delete the root window, which is the first one in
    # the array.
    while length(tui.wins) > 1
        destroy_window(tui.wins[end])
    end

    return nothing
end

# Functions related to window refresh and updating
# ==============================================================================

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
    function refresh_window(win::TUI_WINDOW; update = true, backpropagation = true)

Refresh the window `win` and all its child windows. If the view needs to be
updated (see `view_needs_update`), then the content of the buffer will be copied
to the view before updating.

If `update` is `true`, then `doupdate()` is called and the physical screen is
updated.

If `backpropagation` is `true`, then all the parents windows (except from the
root window) will also be refreshed.

"""
function refresh_window(win::TUI_WINDOW; update = false, backpropagation = true)
    # We must first update all children windows, because the content in the
    # buffer must be updated to the view if required.
    for child in win.children
        if typeof(child) == TUI_WINDOW
            refresh_window(child; update = false, backpropagation = false)
        end
    end

    while true
        # Update the view if necessary.
        update_view(win)

        # If back propagation is required, then go to the parent and refresh.
        if backpropagation
            win = win.parent
            win == nothing && break
        else
            break
        end
    end

    update && doupdate()

    return nothing
end

"""
    function refresh_all_windows()

Refresh all the windows, including the root window.

"""
function refresh_all_windows()
    for win in tui.wins
        refresh_window(win; update = false)
    end

    return nothing
end

"""
    function request_view_update(win::TUI_WINDOW)

Request to update the view of window `win`. Notice that this must also request
update on all parent windows until the root window.

"""
function request_view_update(win::TUI_WINDOW)
    win.parent != nothing && request_view_update(win.parent)
    win.view_needs_update = true

    return nothing
end

# Functions related to the view
# ==============================================================================

"""
    function move_view(win::TUI_WINDOW, y::Integer, x::Integer; update::Bool = true)

Move the origin of the view of window `win` to the position `(y,x)`. This
routine makes sure that the view will never reach positions outside the buffer.

"""
function move_view(win::TUI_WINDOW, y::Integer, x::Integer; update::Bool = true)
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
    function move_view_inc(win::TUI_WINDOW; Δy::Integer, Δx::Integer; kwargs...)

Move the view of the window `win` to the position `(y+Δy, x+Δx)`. This function
has the same set of keywords of the function `move_view`.

"""
move_view_inc(win::TUI_WINDOW, Δy::Integer, Δx::Integer; kwargs...) =
    move_view(win, win.orig[1]+Δy, win.orig[2]+Δx; kwargs...)

"""
    function update_view(win::TUI_WINDOW; force::Bool = false)

Update the view of window `win` by copying the contents from the buffer. If the
view does not need to be updated (see `view_needs_update`), then nothing is
done. If the keyword `force` is `true`, then the copy will always happen.

# Return

It returns `true` if the view has been updated and `false` otherwise.

"""
function update_view(win::TUI_WINDOW; force::Bool = false)
    win.buffer == C_NULL && return true

    if win.view_needs_update || force
        # Auxiliary variables to make the code simpler.
        buffer = win.buffer
        view   = win.view
        orig   = win.orig

        # Get view dimensions.
        maxy, maxx = _get_window_dims(win.view)

        # Copy contents.
        copywin(buffer, view, orig..., 0, 0, maxy-1, maxx-1, 0)

        # Mark that the buffer has been copied.
        win.view_needs_update = false

        return true
    else
        return false
    end
end

# Functions related to the cursors
# ==============================================================================

"""
    function update_cursor(win::TUI_WINDOW)

Update the cursor position so that the physical cursor matches the cursor of the
window `win`.

"""
function update_cursor(win::TUI_WINDOW)
    y,x = _get_window_cur_pos(win.ptr)

    # Compute the coordinates of the cursor with respect to the screen.
    ys = y + win.coord[1]
    xs = x + win.coord[2]

    # If the window has a border, then we must take this into account when
    # updating the cursor coordinates.
    if win.border != C_NULL
        y += 1
        x += 1
    end

    wmove(win.foremost, y, x)
    win = win.parent

    while win != nothing
        # If the window has a border, then we must take this into account when
        # updating the cursor coordinates.
        if win.border != C_NULL
            Δy = Δx = 1
        else
            Δy = Δx = 0
        end

        wmove(win.foremost, (ys+Δy,xs+Δx) .- win.coord...)
        win = win.parent
    end

    return nothing
end

# Functions related to the panels
# ==============================================================================

function hide_window(win::TUI_WINDOW; update::Bool = false)
    # Search for the top window.
    while win.parent != nothing
        win = win.parent
    end

    win.panel_border != C_NULL && hide_panel(win.panel_border)
    hide_panel(win.panel_view)

    update && update_panels()

    return nothing
end

function move_window_to_top(win::TUI_WINDOW; update::Bool = false)
    # Search for the top window.
    while win.parent != nothing
        win = win.parent
    end

    top_panel(win.panel)
    update && update_panels()

    return nothing
end

function show_window(win::TUI_WINDOW; update::Bool = false)
    # Search for the top window.
    while win.parent != nothing
        win = win.parent
    end

    win.panel_border != C_NULL && show_panel(win.panel_border)
    show_panel(win.panel_view)

    update && update_panels()

    return nothing
end

# Functions to draw on the window
# ==============================================================================

"""
    function clear_window(win::TUI_WINDOW; clear_type = :all)

Clear the window `win` according the to clearing type in `clear_type`:

* `:all`: Clears the entire window.
* `:to_screen_bottom`: Clears everything from the cursor position to the bottom
                       of the screen.
* `:to_eol`: Clear everything from the cursor position to the end of line.

"""
function clear_window(win::TUI_WINDOW; clear_type = :all)
    if clear_type == :to_screen_bottom
        wclrtobot(win.ptr)
    elseif clear_type == :to_eol
        wclrtoeol(win.ptr)
    else
        wclear(win.ptr)
    end

    request_view_update(win)
    return nothing
end

"""
    function set_window_title!(win::TUI_WINDOW, title::AbstractString; ...)

Set the title of the window `win` to `title`.

# Keywords

* `title_color`: Color mask that will be used to print the title. See
                 function `ncurses_color`. If negative, then the color will not
                 be changed. (**Default** = -1)

"""
function set_window_title!(win::TUI_WINDOW, title::AbstractString;
                          title_color::Int = -1)
    win.title = title

    if win.border != C_NULL
        # Save the current cursor position.
        cury, curx = _get_window_cur_pos(win.border)

        # Get the dimensions of the border window.
        win_obj = unsafe_load(win.border)
        wsx     = win_obj.maxx + 1

        # Escape the string to avoid problems.
        title_esc = escape_string(title)

        # Print the title if there is any character.
        length_title_esc = length(title_esc)

        if length_title_esc > 0
            col = div(wsx - length(title_esc), 2)
            title_color > 0 && wattron(win.border, title_color)
            mvwprintw(win.border, 0, col, title_esc)
            title_color > 0 && wattroff(win.border, title_color)
        end

        # Move the cursor to the original position.
        wmove(win.border, cury, curx)
    end

    return nothing
end

"""
    function window_print(win::TUI_WINDOW, [row::Integer,] str::AbstractString; ...)

Print the string `str` at the window `win` in the row `row`. If the `row` is
negative or omitted, then the current row will be used.


# Keywords

* `alignment`: Text alignemnt: `:r` for left, `:c` for center`, and `:l` for
               left. (**Default** = `:l`)
* `pad`: Padding to print the text. (**Default** = 0)

# Remarks

If `str` has multiple lines, then all the lines will be aligned.

"""
window_print(win::TUI_WINDOW, str::AbstractString; kwargs...) =
    window_print(win, -1, str; kwargs...)

function window_print(win::TUI_WINDOW, row::Integer, str::AbstractString;
                      alignment::Symbol = :l, pad::Integer = 0)

    # Check if we need to get the cursor position.
    if row < 0
        row, _ = _get_window_cur_pos(win.ptr)
    end

    # Get the dimensions of the window.
    _, wsx = _get_window_dims(win.ptr)

    # Split the string in each line.
    tokens = split(str, "\n")

    for line in tokens
        # Check the alignment and print accordingly.
        if alignment == :r
            col = wsx - length(line) - pad
            window_print(win, row, col, line)
        elseif alignment == :c
            col = div(wsx - length(line) + pad, 2)
            window_print(win, row, col, line)
        else
            window_print(win, row, pad, line)
        end

        row += 1
    end

    return nothing
end

function window_print(win::TUI_WINDOW, row::Integer, col::Integer,
                      str::AbstractString)

    mvwprintw(win.ptr, row, col, str)
    request_view_update(win)

    return nothing
end

"""
    function window_println(win::TUI_WINDOW, [row::Integer,] str::AbstractString; ...)

Print the string `str` at the window `win` in the row `row` adding a break line
character at the end. If the `row` is negative or omitted, then the current row
will be used.

# Keywords

* `alignment`: Text alignemnt: `:r` for left, `:c` for center`, and `:l` for
               left. (**Default** = `:l`)
* `pad`: Padding to print the text. (**Default** = 0)

# Remarks

If `str` has multiple lines, then all the lines will be aligned.

"""
window_println(win::TUI_WINDOW, str::AbstractString; kwargs...) =
    window_print(win, str * "\n"; kwargs...)

window_println(win::TUI_WINDOW, row::Integer, str::AbstractString; kwargs...) =
    window_print(win, row, str * "\n"; kwargs...)

################################################################################
#                                     API
################################################################################

# Focus manager
# ==============================================================================


"""
    function accept_focus(win::TUI_WINDOW)

Command executed when window `win` must state whether or not it accepts the
focus. If the focus is accepted, then this function returns `true`. Otherwise,
it returns `false`.

"""
function accept_focus(win::TUI_WINDOW)
    # Move the window to the top so that it can be seen.
    move_window_to_top(win)

    # Search for a child that can accept the focus.
    for i = 1:length(win.children)
        if accept_focus(win.children[i])
            win.focus_id  = i
            win.focus_ptr = win.children[i]
            win.has_focus = true
            win.on_focus_acquired(win)
            return true
        end
    end

    return false
end

"""
    function process_focus(win::TUI_WINDOW, k::Keystroke)

Process the actions when the window `win` is in focus and the keystroke `k` was
issued by the user.

"""
function process_focus(win::TUI_WINDOW, k::Keystroke)
    num_children = length(win.children)
    num_children == 0 && return false

    if win.focus_ptr != nothing
        return process_focus(win.focus_ptr, k)
    else
        return false
    end
end

"""
    function release_focus(win::TUI_WINDOW)

Release the focus from the window `win`.

"""
function release_focus(win::TUI_WINDOW)
    if win.focus_ptr != nothing
        release_focus(win.focus_ptr)
    end

    win.focus_id  = 1
    win.focus_ptr = nothing
    win.has_focus = false

    win.on_focus_released(win)

    return nothing
end

"""
    function request_focus_change(win::TUI_WINDOW)

Request to change the focus of the children elements in window `win`. If all the
children has already been cycled, then this function returns `true` to state
that the focus should be released from the window.

"""
function request_focus_change(win::TUI_WINDOW)
    # If we have not child, than just allow focus change.
    num_children = length(win.children)
    num_children == 0 && return true

    # Otherwise, move to the next child until hit the last one.
    win.focus_ptr != nothing && release_focus(win.focus_ptr)

    # Loop the children to find one that can accept the focus.
    for i = win.focus_id+1:num_children
        if accept_focus(win.children[i])
            win.focus_id  = i
            win.focus_ptr = win.children[i]
            win.has_focus = true

            return false
        end
    end

    release_focus(win)

    return true
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
        win_obj = unsafe_load(win)
        wsx     = win_obj.maxx
        wsy     = win_obj.maxy

        return wsy + 1, wsx + 1
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
        win_obj = unsafe_load(win)
        cury    = win_obj.cury
        curx    = win_obj.curx

        return cury, curx
    else
        return -1, -1
    end
end

function _get_window_coord(win::Ptr{WINDOW})
    if win != C_NULL
        win_obj = unsafe_load(win)
        begy    = win_obj.begy
        begx    = win_obj.begx

        return begy, begx
    else
        return -1, -1
    end
end
