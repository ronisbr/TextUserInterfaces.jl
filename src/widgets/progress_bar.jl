# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Widget: Progress bar.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetProgressBar, change_value

################################################################################
#                                     Type
################################################################################

@with_kw mutable struct WidgetProgressBar <: Widget

    # API
    # ==========================================================================
    parent::Window  = nothing
    cwin::Ptr{WINDOW}   = Ptr{WINDOW}(0)
    update_needed::Bool = true

    # Parameters related to the widget
    # ==========================================================================
    border::Bool = false
    color::Int = 0
    value::Int = 0
    style::Symbol = :simple
end

################################################################################
#                                     API
################################################################################

# Progress bar cannot accept focus.
accept_focus(widget::WidgetProgressBar) = false

function create_widget(::Type{Val{:progress_bar}}, parent::Window,
                       begin_y::Integer, begin_x::Integer, ncols::Integer,
                       value::Integer = 0; border::Bool = false, color::Int = 0,
                       style = :simple)

    # The number of lines depends on the style.
    nlines  = style == :complete ? 2 : 1
    nlines += border ? 2 : 0

    # Create the window that will hold the contents.
    cwin = subpad(parent.buffer, nlines, ncols, begin_y, begin_x)

    # Create the widget.
    widget = WidgetProgressBar(parent = parent, cwin = cwin, border = border,
                               color = color, value = value, style = style)

    # Add to the parent window widget list.
    push!(parent.widgets, widget)

    @log info "create_widget" """
    A progress bar was created in window $(parent.id).
        Size       = ($nlines, $ncols)
        Coordinate = ($begin_y, $begin_x)
        Border     = $border
        Style      = \"$(string(style))\""""

    # Return the created widget.
    return widget
end

function redraw(widget::WidgetProgressBar)
    @unpack cwin, color, value, style = widget
    wclear(cwin)

    if style == :complete
        _draw_progress_bar_complete(widget)
    else
        _draw_progress_bar_simple(widget)
    end

    return nothing
end

################################################################################
#                           Custom widget functions
################################################################################

# Public functions
# ==============================================================================

"""
    function change_value(widget::WidgetProgressBar, new_value::Integer; color::Int = -1)

Change the value of the progress bar to `new_value`.

The color can be selected by the keyword `color`. It it is negative
(**default**), then the current color will not be changed.

"""
function change_value(widget::WidgetProgressBar, new_value::Integer;
                      color::Int = -1)

    # Set the new value.
    widget.value = new_value

    # Set the color.
    color >= 0 && (widget.color = color)

    @log verbose "change_value" "Window $(widget.parent.id): Progress bar value changed to $new_value."

    request_update(widget)

    return nothing
end

# Private function
# ==============================================================================

function _draw_progress_bar_simple(widget::WidgetProgressBar)
    @unpack cwin, border, color, value = widget

    color > 0 && wattron(cwin, color)
    # Get the current size of the content window.
    ~, wsx = _get_window_dims(cwin)

    # Check if the user wants a border.
    if border
        wborder(cwin)
        wsx -= 4
        y₀ = 1
        x₀ = 2
    else
        y₀ = 0
        x₀ = 0
    end

    # Compute how many squares we must drawn.
    value = clamp(value, 0, 100)
    num   = round(Int, wsx*value/100)

    # Print.
    mvwprintw(cwin, y₀, x₀, "█"^num)

    color > 0 && wattroff(cwin, color)
end

function _draw_progress_bar_complete(widget::WidgetProgressBar)
    @unpack cwin, border, color, value = widget

    color > 0 && wattron(cwin, color)

    # Get the current size of the content window.
    ~, wsx = _get_window_dims(cwin)

    # Check if the user wants a border.
    if border
        wborder(cwin)
        wsx -= 4
        y₀ = 1
        x₀ = 2
    else
        y₀ = 0
        x₀ = 0
    end

    # Compute how many squares we must drawn.
    value = clamp(value, 0, 100)
    num   = round(Int, wsx*value/100)

    # Print the text.
    mvwprintw(cwin, y₀, x₀, "Progress: $value%%")

    # Print.
    mvwprintw(cwin, y₀+1, x₀, "█"^num)

    color > 0 && wattroff(cwin, color)
end
