# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains functions to create windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export create_window

"""
    function create_window(;  kwargs...)

Create a window.

# Keyword

- `bcols::Int`: Number of columns in the window buffer. This will be
    automatically increased to, at least, fit the viewable part of the window.
    (**Default** = 0)
- `blines::Int`: Number of lines in the window buffer. This will be
    automatically increased to, at least, fit the viewable part of the window.
    (**Default** = 0)
- `border::Bool`: If `true`, then the window will have a border.
    (**Default** = `true`)
- `border_color::Int`: Color mask that will be used to print the border. See
    function `ncurses_color`. If negative, then the color will not be changed.
    (**Default** = -1)
- `buffer_size::Tuple{Int, Int}`: Number of rows and columns in the window
    buffer. This will be automatically increased to, at least, fit the viewable
    part of the window. (**Default** = `(0, 0)`)
- `focusable::Bool`: If `true`, then the window can have focus. Otherwise, all
    focus request will be rejected. (**Default** = `true`)
- `layout::ObjectLayout`: The layout configuration of the window.
    (**Default** = `ObjectLayout()`)
- `title::String`: The title of the window, which will only be printed if
    `border` is `true`. (**Default** = "")
- `title_color::Int`: Color mask that will be used to print the title. See
    function `ncurses_color`. If negative, then the color will not be changed.
    (**Default** = -1)
"""
function create_window(;
    border::Bool = true,
    border_color::Int = -1,
    buffer_size::Tuple{Int, Int} = (0, 0),
    focusable::Bool = true,
    layout::ObjectLayout = ObjectLayout(),
    theme::Theme = tui.default_theme,
    title::String = "",
    title_color::Int = -1
)
    # Check if the TUI has been initialized.
    !tui.initialized && error("The text user interface was not initialized.")

    # Get the layout information of the window.
    height, width, top, left = process_object_layout(
        layout,
        ROOT_WINDOW;
        horizontal_hints = _WINDOW_HORIZONTAL_LAYOUT_HINTS,
        vertical_hints = _WINDOW_VERTICAL_LAYOUT_HINTS
    )

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
    blines = buffer_size[1]
    bcols = buffer_size[2]

    blines <= 0 && bcols <= 0 && (buffer_view_locked = true)
    blines <= 0 && (blines = border ? nlines - 2 : nlines)
    bcols  <= 0 && (bcols  = border ? ncols - 2  : ncols)
    buffer = newpad(blines, bcols)

    # Set the window theme.
    wbkgd(buffer, theme.default)

    # Create the panel.
    panel = new_panel(view)

    # Compute the window coordinate with respect to the screen.
    position = (begin_y, begin_x)

    # Create the widget container.
    widget_container = create_widget(
        Val(:container),
        _WINDOW_CONTAINER_OBJECT_LAYOUT,
        border = true,
        title = "TITLE"
    )

    # Create the window object and add to the global list.
    win = Window(
        border_color       = border_color,
        buffer             = buffer,
        buffer_view_locked = buffer_view_locked,
        focusable          = focusable,
        has_border         = border,
        id                 = reserve_object_id(),
        layout             = layout,
        panel              = panel,
        position           = position,
        title              = title,
        title_color        = title_color,
        theme              = theme,
        widget_container   = widget_container,
        view               = view,
    )

    # Update the widget container layout.
    widget_container.window = win
    update_layout!(widget_container)

    border && set_window_title!(win, title; title_color = title_color)
    push!(tui.windows, win)

    # We need to update the window to update the container.
    update!(win)

    @log INFO "create_window" """
    Window created:
      ID                 = $(win.id)
      Buffer size        = ($blines, $bcols)
      Buffer view locked = $(win.buffer_view_locked)
      Coordinate         = ($begin_y, $begin_x)
      Focusable          = $(win.focusable)
      Has border         = $(win.has_border)
      Physical size      = ($nlines, $ncols)
      Title              = \"$(win.title)\"
      Title color        = $(win.title_color)"""

    # Return the pointer to the window.
    return win
end
