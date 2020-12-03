# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Widget: Label.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetLabel, change_text

################################################################################
#                                     Type
################################################################################

@widget mutable struct WidgetLabel
    # Input label data from the user.
    alignment::Symbol
    color::Int
    fill_color::Bool
    text₀::AbstractString

    # Variable to store the aligned text to save computational burden.
    text::AbstractString
end

################################################################################
#                                     API
################################################################################

# Labels cannot accept focus.
accept_focus(widget::WidgetLabel) = false

function create_widget(::Val{:label},
                       opc::ObjectPositioningConfiguration;
                       alignment = :l,
                       color::Int = 0,
                       fill_color::Bool = false,
                       text::AbstractString = "Text")

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    horizontal = _process_horizontal_info(opc)
    vertical   = _process_vertical_info(opc)

    vertical   == :unknown && (opc.height = length(split(text, '\n')))
    horizontal == :unknown && (opc.width  = maximum(length.(split(text, '\n')))+1)

    # Create the widget.
    widget = WidgetLabel(opc        = opc,
                         alignment  = alignment,
                         text₀      = text,
                         text       = text,
                         color      = color,
                         fill_color = fill_color)

    @log info "create_widget" """
    Label created:
        Reference  = $(obj_to_ptr(widget))
        Alignment  = $alignment
        Color      = $color
        Fill color = $fill_color
        Text       = \"$text\""""

    # Return the created widget.
    return widget
end

function redraw(widget::WidgetLabel)
    @unpack buffer, color, text = widget

    wclear(buffer)
    color > 0 && wattron(buffer, color)
    mvwprintw(buffer, 0, 0, widget.text)
    color > 0 && wattroff(buffer, color)
    return nothing
end

function reposition!(widget::WidgetLabel; force::Bool = false)
    # Call the default repositioning function.
    if invoke(reposition!, Tuple{Widget}, widget; force = force)
        _align_text!(widget)

        return true
    else
        return false
    end
end

################################################################################
#                           Custom widget functions
################################################################################

"""
    change_text(widget::WidgetLabel, new_text::AbstractString; alignment = :l, color::Int = -1)

Change to text of the label widget `widget` to `new_text`.

The text alignment in the widget can be selected by the keyword `alignment`,
which can be:

* `:l`: left alignment (**default**);
* `:c`: Center alignment; or
* `:r`: Right alignment.

The text color can be selected by the keyword `color`. It it is negative
(**default**), then the current color will not be changed.

"""
function change_text(widget::WidgetLabel, new_text::AbstractString;
                     alignment = :l, color::Int = -1)

    widget.text₀ = text
    color > 0 && (widget.color = color)
    _align_text!(widget)

    @log verbose "change_text" "$(obj_desc(widget)): Label text changed to \"$new_text\"."

    return nothing
end

################################################################################
#                              Private functions
################################################################################

# This function gets the text in variable `text₀`, and apply the alignment. It
# is only called when the widget is repositioned.
function _align_text!(widget::WidgetLabel)
    # If the widget does not has a parent, then we cannot align the text.
    isnothing(widget.parent) && return nothing

    @unpack alignment, buffer, fill_color, parent, text₀, width = widget

    # Split the string in each line.
    tokens = split(text₀, "\n")

    # Formatted text.
    text = ""

    for line in tokens
        text_i = ""

        # Check the alignment and print accordingly.
        if alignment == :r
            col     = width - length(line) - 1
            text_i *= " "^col * line
        elseif alignment == :c
            col     = div(width - length(line), 2)
            text_i *= " "^col * line
        else
            text_i *= line
        end

        # If `fill_color` is `true`, then fill the remaining spaces up to the
        # widget width.
        if fill_color
            rem     = clamp(width - length(text_i), 0, width)
            text_i *= " "^rem
        end

        text *= text_i * "\n"
    end

    widget.text = text

    request_update(widget)

    return nothing
end
