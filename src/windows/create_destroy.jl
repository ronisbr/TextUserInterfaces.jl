#==# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains functions to create and destroy windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #==#

export create_window, create_window_with_container, destroy_window,
       destroy_all_windows

"""
function create_window(id::String = ""; bcols::Int = 0, blines::Int = 0, border::Bool = true, border_color::Int = -1, focusable::Bool = true, title::String = "", title_color::Int = -1, kwargs...)

Create a window. The window ID `id` is used to identify the new window in the
global window list. The size and location of the window can be configured by
passing to `kwargs...` the arguments used in the function
`object_positioning_conf`.

# Keyword

* `bcols`: Number of columns in the window buffer. This will be automatically
           increased to, at least, fit the viewable part of the window.
           (**Default** = 0)
* `blines`: Number of lines in the window buffer. This will be automatically
            increased to, at least, fit the viewable part of the window.
            (**Default** = 0)
* `border`: If `true`, then the window will have a border.
            (**Default** = `true`)
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
function create_window(id::String = ""; bcols::Int = 0, blines::Int = 0,
                       border::Bool = true, border_color::Int = -1,
                       focusable::Bool = true, title::String = "",
                       title_color::Int = -1, kwargs...)

    # Check if the TUI has been initialized.
    !tui.init && error("The text user interface was not initialized.")

    # If the user does not specify an `id`, then we choose based on the number
    # of available windows.
    length(id) == 0 && ( id = string(length(tui.wins)) )

    # Compute the window positioning.
    opc = object_positioning_conf(;kwargs...)

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

    # Create the window.
    view = newwin(nlines, ncols, begin_y, begin_x)

    # Check if the user wants a border.
    if border
        border_color >= 0 && wattron(view, border_color)
        wborder(view)
        border_color >= 0 && wattroff(view, border_color)
    end

    # Create the buffer.
    buffer_view_locked = false
    (blines <= 0 && bcols <= 0) && (buffer_view_locked = true)

    blines <= 0 && (blines = border ? nlines-2 : nlines)
    bcols  <= 0 && (bcols  = border ? ncols-2  : ncols)
    buffer = newpad(blines, bcols)

    # Create the panel.
    panel = new_panel(view)

    # Compute the window coordinate with respect to the screen.
    coord = (begin_y, begin_x)

    # Create the window object and add to the global list.
    win = Window(id = id, title = title, title_color = title_color,
                 coord = coord, has_border = border,
                 border_color = border_color, opc = opc, view = view,
                 buffer = buffer, panel = panel, focusable = focusable,
                 buffer_view_locked = buffer_view_locked)
    border && set_window_title(win, title; title_color = title_color)
    push!(tui.wins, win)

    @log info "create_window" """
    Window $id was created.
       Physical size = ($nlines, $ncols)
       Buffer size   = ($blines, $bcols)
       Coordinate    = ($begin_y, $begin_x)
       Title         = \"$title\""""

    # Return the pointer to the window.
    return win
end

"""
    create_window_with_container(vargs...; kwargs...)

Create a window with a container as its widget. The arguments and keywords are
the same ones of the function `create_window`. The container will have the same
size of the window buffer.

# Return

* The created window.
* The created container.

"""
function create_window_with_container(vargs...; kwargs...)
    win = create_window(vargs...; kwargs...)
    con = create_widget(Val{:container}, win)
    return win, con
end

"""
    destroy_window(win::Window)

Destroy the window `win`.

"""
function destroy_window(win::Window)
    @log info "destroy_window" "$(obj_desc(win)) will be destroyed."
    @log_ident 1

    # Destroy the widget.
    if win.widget != nothing
        # In this case, we do not need to refresh the window.
        destroy_widget(win.widget; refresh = false)
        win.widget = nothing
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
    destroy_all_windows()

Destroy all windows managed by the TUI.

"""
function destroy_all_windows()
    @log info "destroy_all_windows" "All windows will be destroyed."
    while length(tui.wins) > 0
        destroy_window(tui.wins[end])
    end

    return nothing
end
