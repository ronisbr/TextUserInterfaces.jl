## Description #############################################################################
#
# This file contains functions to create windows.
#
############################################################################################

export create_window

"""
    function create_window(;  kwargs...) -> Window

Create a window.

# Keyword

- `bcols::Int`: Number of columns in the window buffer. This will be automatically increased
    to, at least, fit the viewable part of the window.
    (**Default** = 0)
- `blines::Int`: Number of lines in the window buffer. This will be automatically increased
    to, at least, fit the viewable part of the window.
    (**Default** = 0)
- `border::Bool`: If `true`, the window will have a border.
    (**Default** = `true`)
- `border_style::Symbol`: Style of the border. It can be `:default`, `:rounded`, or
    `:double`.
    (**Default** = `:default`)
- `buffer_size::Tuple{Int, Int}`: Number of rows and columns in the window buffer. This will
    be automatically increased to, at least, fit the viewable part of the window.
    (**Default** = `(0, 0)`)
- `focusable::Bool`: If `true`, the window can have focus. Otherwise, all focus request will
    be rejected.
    (**Default** = `true`)
- `layout::ObjectLayout`: Layout configuration of the window.
    (**Default** = `ObjectLayout()`)
- `horizontal_hints::Dict{Symbol, Any}`: Horizontal layout hints for the window.
    (**Default** = `_WINDOW_HORIZONTAL_LAYOUT_HINTS`)
- `title::String`: Title of the window, which will only be printed if `border` is
    `true`.
    (**Default** = "")
- `title_alignment::Symbol`: Title alignment. It can be `:l`, `:c`, or `:r`.
    (**Default** = `:c`)
- `vertical_hints::Dict{Symbol, Any}`: Vertical layout hints for the window.
    (**Default** = `_WINDOW_VERTICAL_LAYOUT_HINTS`)
"""
function create_window(;
    border::Bool = true,
    border_style::Symbol = :default,
    buffer_size::Tuple{Int, Int} = (0, 0),
    focusable::Bool = true,
    layout::ObjectLayout = ObjectLayout(),
    horizontal_hints::Dict{Symbol, Any} = _WINDOW_HORIZONTAL_LAYOUT_HINTS,
    theme::Theme = tui.default_theme,
    title::String = "",
    title_alignment::Symbol = :c,
    vertical_hints::Dict{Symbol, Any} = _WINDOW_VERTICAL_LAYOUT_HINTS,
)
    # Check if the TUI has been initialized.
    !tui.initialized && error("The text user interface was not initialized.")

    # Get the layout information of the window.
    height, width, top, left = process_object_layout(
        layout,
        ROOT_WINDOW;
        horizontal_hints = horizontal_hints,
        vertical_hints = vertical_hints
    )

    # Assign to the variables that will be used to create the window.
    begin_y = top
    begin_x = left
    nlines  = height
    ncols   = width

    # Create the window.
    view = NCurses.newwin(nlines, ncols, begin_y, begin_x)

    # Check if the user wants a border.
    border && @ncolor theme.border view begin
        draw_border!(view; style = border_style)
    end

    # Create the buffer.
    buffer_view_locked = false
    blines = buffer_size[1]
    bcols = buffer_size[2]

    if (blines <= 0) && (bcols <= 0)
        buffer_view_locked = true
    end

    if blines <= 0
        blines = border ? nlines - 2 : nlines
    end

    if bcols <= 0
        bcols  = border ? ncols - 2  : ncols
    end

    buffer = NCurses.newpad(blines, bcols)

    # Set the window theme.
    NCurses.wbkgd(buffer, theme.default)

    # Create the panel.
    panel = NCurses.new_panel(view)

    # Compute the window coordinate with respect to the screen.
    position = (begin_y, begin_x)

    # Create the widget container.
    widget_container = create_widget(
        Val(:container),
        _WINDOW_CONTAINER_OBJECT_LAYOUT;
        border = false,
        title = ""
    )

    # Create the window object and add to the global list.
    win = Window(;
        buffer             = buffer,
        buffer_view_locked = buffer_view_locked,
        focusable          = focusable,
        has_border         = border,
        border_style       = border_style,
        id                 = reserve_object_id(),
        layout             = layout,
        horizontal_hints   = horizontal_hints,
        vertical_hints     = vertical_hints,
        panel              = panel,
        position           = position,
        title              = title,
        title_alignment    = title_alignment,
        theme              = theme,
        widget_container   = widget_container,
        view               = view,
    )

    # Update the widget container layout.
    widget_container.window = win
    update_layout!(widget_container)

    set_window_theme!(win, theme)

    border && set_window_title!(win, title, title_alignment)
    push!(tui.windows, win)

    # We need to update the window to update the container.
    update!(win)

    @log DEBUG "create_window" """
    Window created:
      ID                 = $(win.id)
      Buffer size        = ($blines, $bcols)
      Buffer view locked = $(win.buffer_view_locked)
      Coordinate         = ($begin_y, $begin_x)
      Focusable          = $(win.focusable)
      Has border         = $(win.has_border)
      Physical size      = ($nlines, $ncols)
      Title              = \"$(win.title)\"
      Title alignment    = $(win.title_alignment)"""

    # Return the pointer to the window.
    return win
end
