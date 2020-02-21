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

@with_kw mutable struct WidgetProgressBar{T<:WidgetParent} <: Widget

    # API
    # ==========================================================================
    common::WidgetCommon{T}

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

function create_widget(::Type{Val{:progress_bar}}, parent::WidgetParent;
                       border::Bool = false,
                       color::Int = 0,
                       color_highlight::Int = 0,
                       style::Symbol = :simple,
                       value::Int = 0,
                       kwargs...)

    # Positioning configuration.
    opc = object_positioning_conf(; kwargs...)

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    if opc.vertical == :unknown
        opc.height = _progress_bar_height(style, border)
    end

    if opc.horizontal == :unknown
        opc.width = 10
    end

    # Create the common parameters of the widget.
    common = create_widget_common(parent, opc)

    # Create the widget.
    widget = WidgetProgressBar(common = common,
                               border = border,
                               color  = color,
                               value  = value,
                               style  = style)

    # Add the new widget to the parent widget list.
    add_widget(parent, widget)

    @log info "create_widget" """
    A progress bar was created in $(obj_desc(parent)).
        Size        = ($(common.height), $(common.width))
        Coordinate  = ($(common.top), $(common.left))
        Positioning = ($(common.opc.vertical),$(common.opc.horizontal))
        Style       = $(string(style))
        Value       = $value
        Reference   = $(obj_to_ptr(widget))"""

    # Return the created widget.
    return widget
end

function redraw(widget::WidgetProgressBar)
    @unpack common, color, value, style = widget
    @unpack buffer = common

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
    @unpack common, border, color, value = widget
    @unpack buffer = common

    color > 0 && wattron(buffer, color)

    # Get the width of the progress bar.
    wsx = common.width

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
    @unpack common, border, color, value = widget
    @unpack buffer = common

    color > 0 && wattron(buffer, color)

    # Get the width of the progress bar.
    wsx = common.width

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

