# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains functions to create windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export create_window, create_window_with_container

"""
    function create_window(opc::ObjectPositioningConfiguration = newopc(), id::String = "";  kwargs...)

Create a window. The window ID `id` is used to identify the new window in the
global window list. The size and location of the window is configured by the
object `opc`.

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
function create_window(opc::ObjectPositioningConfiguration = newopc(),
                       id::String = "";
                       bcols::Int = 0,
                       blines::Int = 0,
                       border::Bool = true,
                       border_color::Int = -1,
                       focusable::Bool = true,
                       title::String = "",
                       title_color::Int = -1)

    # Check if the TUI has been initialized.
    !tui.init && error("The text user interface was not initialized.")

    # If the user does not specify an `id`, then we choose based on the number
    # of available windows.
    length(id) == 0 && ( id = string(length(tui.wins)) )

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the anchors.
    vertical   = _process_horizontal_info(opc)
    horizontal = _process_vertical_info(opc)

    if vertical == :unknown
        opc.anchor_bottom = Anchor(:parent, :bottom, 0)
        opc.anchor_top    = Anchor(:parent, :top,    0)
    end

    if horizontal == :unknown
        opc.anchor_left   = Anchor(:parent, :left,  0)
        opc.anchor_right  = Anchor(:parent, :right, 0)
    end

    # Get the positioning information of the window.
    height, width, top, left = compute_object_positioning(opc, rootwin)

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
    Window created:
       ID            = $id
       Physical size = ($nlines, $ncols)
       Buffer size   = ($blines, $bcols)
       Coordinate    = ($begin_y, $begin_x)
       Title         = \"$title\" """

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
    con = create_widget(Val(:container), newopc())
    add_widget!(win, con)

    return win, con
end
