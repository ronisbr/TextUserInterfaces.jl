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
    common::WidgetCommon

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
                       top::Union{Integer,Symbol} = 0,
                       left::Union{Integer,Symbol} = 0,
                       width::Number = 20,
                       hsize_policy::Symbol = :absolute,
                       border::Bool = false,
                       color::Int = 0,
                       color_highlight::Int = 0,
                       style::Symbol = :simple,
                       value::Integer = 0)

    # The height depends on the style.
    height  = style == :complete ? 2 : 1

    # Create the common parameters of the widget.
    common = create_widget_common(parent, top, left, height, width, :absolute,
                                  hsize_policy)

    # Create the widget.
    widget = WidgetProgressBar(common = common,
                               color  = color,
                               value  = value,
                               style  = style)

    # Add to the parent window widget list.
    push!(parent.widgets, widget)

    @log info "create_widget" """
    A progress bar was created in window $(parent.id).
        Size        = ($(common.height), $(common.width))
        Coordinate  = ($(common.top), $(common.left))
        Size policy = ($(common.vsize_policy), $(common.hsize_policy))
        Style       = $(string(style)),
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
    # Get the current size of the content window.
    ~, wsx = _get_window_dims(buffer)

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

    # Get the current size of the content window.
    ~, wsx = _get_window_dims(buffer)

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
