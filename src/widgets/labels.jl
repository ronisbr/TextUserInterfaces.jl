# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Widget: Label.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetLabel, change_text

################################################################################
#                                     Type
################################################################################

@widget mutable struct WidgetLabel
    color::Int
    fill_color::Bool
    text::AbstractString
end

################################################################################
#                                     API
################################################################################

# Labels cannot accept focus.
accept_focus(widget::WidgetLabel) = false

function create_widget(::Val{:label},
                       parent::WidgetParent,
                       opc::ObjectPositioningConfiguration;
                       alignment = :l,
                       color::Int = 0,
                       fill_color::Bool = false,
                       text::AbstractString = "Text")

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    _process_horizontal_info!(opc)
    _process_vertical_info!(opc)

    opc.vertical   == :unknown && (opc.height = length(split(text, '\n')))
    opc.horizontal == :unknown && (opc.width  = maximum(length.(split(text, '\n')))+1)

    # Create the widget.
    widget = WidgetLabel(parent     = parent,
                         opc        = opc,
                         text       = "",
                         color      = color,
                         fill_color = fill_color)

    # Initialize the internal variables of the widget.
    init_widget!(widget)

    # Update the text.
    change_text(widget, text; alignment = alignment)

    # Add the new widget to the parent widget list.
    add_widget(parent, widget)

    @log info "create_widget" """
    A label was created in $(obj_desc(parent)).
        Size        = ($(widget.height), $(widget.width))
        Coordinate  = ($(widget.top), $(widget.left))
        Positioning = ($(widget.opc.vertical),$(widget.opc.horizontal))
        Text        = \"$text\"
        Reference   = $(obj_to_ptr(widget))"""

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

    @unpack buffer, fill_color, parent, width = widget

    # Split the string in each line.
    tokens = split(new_text, "\n")

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

        # If `fill_color` is `true`, then fill the remaning spaces up to the
        # widget width.
        if fill_color
            rem     = clamp(width - length(text_i), 0, width)
            text_i *= " "^rem
        end

        text *= text_i * "\n"
    end

    widget.text = text

    # Set the color.
    color >= 0 && (widget.color = color)

    @log verbose "change_text" "$(obj_desc(widget)): Label text changed to \"$new_text\"."

    request_update(widget)

    return nothing
end
