#==# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains functions to create and destroy windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #==#

export create_window, destroy_window, destroy_all_windows

"""
    function create_window(nlines::Integer, ncols::Integer, begin_y::Integer, begin_x::Integer, id::String = ""; bcols::Integer = 0, blines::Integer = 0, border::Bool = true, border_color::Int = -1, title::String = "", title_color::Int = -1)

Create a window. The new window size will be `nlines × ncols` and the origin
will be placed at `(begin_y, begin_x)` coordinate of the root window. The window
ID `id` is used to identify the new window in the global window list.

# Keyword

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
* `focusable`: If `true`, then the window can have focus. Otherwise, all focus
               request will be rejected. (**Default** = `true`)
* `title`: The title of the window, which will only be printed if `border` is
           `true`. (**Default** = "")
* `title_color`: Color mask that will be used to print the title. See
                 function `ncurses_color`. If negative, then the color will not
                 be changed. (**Default** = -1)

"""
function create_window(nlines::Integer, ncols::Integer, begin_y::Integer,
                       begin_x::Integer, id::String = "";
                       bcols::Integer = 0, blines::Integer = 0,
                       border::Bool = true, border_color::Int = -1,
                       focusable::Bool = true, title::String = "",
                       title_color::Int = -1)

    # Check if the TUI has been initialized.
    !tui.init && error("The text user interface was not initialized.")

    # If the user does not specify an `id`, then we choose based on the number
    # of available windows.
    length(id) == 0 && ( id = string(length(tui.wins)) )

    # Create the window.
    view = newwin(nlines, ncols, begin_y, begin_x)

    # Check if the user wants a border.
    if border
        border_color >= 0 && wattron(view, border_color)
        wborder(view)
        border_color >= 0 && wattroff(view, border_color)
    end

    # Create the buffer.
    blines <= 0 && (blines = border ? nlines-2 : nlines)
    bcols  <= 0 && (bcols  = border ? ncols-2  : ncols)
    buffer = newpad(blines, bcols)

    # Create the panel.
    panel = new_panel(view)

    # Compute the window coordinate with respect to the screen.
    coord = (begin_y, begin_x)

    # Create the window object and add to the global list.
    win = Window(id = id, title = title, coord = coord,
                     has_border = border, view = view, buffer = buffer,
                     panel = panel, focusable = focusable)
    border && set_window_title(win, title; title_color = title_color)
    push!(tui.wins, win)

    @log info "create_window" """
    Window $id was created.
       Physical size = ($nlines, $ncols)
       Buffer size   = ($bcols, $blines)
       Coordinate    = ($begin_y, $begin_x)
       Title         = \"$title\""""

    # Return the pointer to the window.
    return win
end

"""
    function destroy_window(win::Window)

Destroy the window `win`.

"""
function destroy_window(win::Window)
    @log info "destroy_window" "Window $(win.id) and its $(length(win.widgets)) widgets will be destroyed."
    @log_ident 1

    win.focus_id = 0

    # Destroy all widgets.
    for widget in win.widgets
        # In this case, we do not need to refresh the window.
        destroy_widget(widget; refresh = false)
    end

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
    idx = findall(x->x == win, tui.wins)
    deleteat!(tui.wins, idx)

    @log_ident 0
    @log info "destroy_window" "Window $(win.id) was destroyed."

    return nothing
end

"""
    function destroy_all_windows()

Destroy all windows managed by the TUI.

"""
function destroy_all_windows()
    @log info "destroy_all_windows" "All windows will be destroyed."
    while length(tui.wins) > 0
        destroy_window(tui.wins[end])
    end

    return nothing
end
