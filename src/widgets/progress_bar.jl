# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Widget: Progress bar.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetProgressBar, change_value

################################################################################
#                                     Type
################################################################################

@widget mutable struct WidgetProgressBar
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

function create_widget(::Val{:progress_bar},
                       opc::ObjectPositioningConfiguration;
                       border::Bool = false,
                       color::Int = _color_default,
                       color_highlight::Int = _color_highlight,
                       style::Symbol = :simple,
                       value::Int = 0)

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    horizontal = _process_horizontal_info(opc)
    vertical   = _process_vertical_info(opc)

    if vertical == :unknown
        opc.height = _progress_bar_height(style, border)
    end

    if horizontal == :unknown
        opc.width = 10
    end

    # Create the widget.
    widget = WidgetProgressBar(opc    = opc,
                               border = border,
                               color  = color,
                               value  = value,
                               style  = style)

    @log info "create_widget" """
    Progress bar created:
        Reference = $(obj_to_ptr(widget))
        Style     = $(string(style))
        Value     = $value"""

    # Return the created widget.
    return widget
end

function redraw(widget::WidgetProgressBar)
    @unpack buffer, color, style, value = widget

    wclear(buffer)

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
    change_value(widget::WidgetProgressBar, new_value::Int; color::Int = -1)

Change the value of the progress bar to `new_value`.

The color can be selected by the keyword `color`. It it is negative
(**default**), then the current color will not be changed.

"""
function change_value(widget::WidgetProgressBar, new_value::Int; color::Int = -1)

    # Set the new value.
    widget.value = new_value

    # Set the color.
    color >= 0 && (widget.color = color)

    @log verbose "change_value" "$(obj_to_ptr(widget)): Progress bar value changed to $new_value."

    request_update(widget)

    return nothing
end

# Private function
# ==============================================================================

function _draw_progress_bar_simple(widget::WidgetProgressBar)
    @unpack border, buffer, color, width, value = widget

    color > 0 && wattron(buffer, color)

    # Get the width of the progress bar.
    wsx = width

    # Check if the user wants a border.
    if border
        wborder(buffer)
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
    mvwprintw(buffer, y₀, x₀, "█"^num)

    color > 0 && wattroff(buffer, color)
end

function _draw_progress_bar_complete(widget::WidgetProgressBar)
    @unpack border, buffer, color, width, value = widget

    color > 0 && wattron(buffer, color)

    # Get the width of the progress bar.
    wsx = width

    # Check if the user wants a border.
    if border
        wborder(buffer)
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
    mvwprintw(buffer, y₀, x₀, "Progress: $value%%")

    # Print.
    mvwprintw(buffer, y₀+1, x₀, "█"^num)

    color > 0 && wattroff(buffer, color)
end

function _progress_bar_height(style::Symbol, border::Bool)
    height = 1

    border && (height += 2)
    (style == :complete) && (height += 1)

    return height
end
