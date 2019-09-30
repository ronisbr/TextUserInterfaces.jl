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

@with_kw mutable struct WidgetLabel <: Widget

    # API
    # ==========================================================================
    parent::TUI_WINDOW = nothing
    cwin::Ptr{WINDOW}  = Ptr{WINDOW}(0)
    update_needed::Bool = true

    # Parameters related to the widget
    # ==========================================================================
    color::Int
    text::String
end

################################################################################
#                                     API
################################################################################

function create_widget(::Type{Val{:label}}, parent::TUI_WINDOW,
                       begin_y::Integer, begin_x::Integer, nlines::Integer,
                       ncols::Integer, text::AbstractString; alignment = :l,
                       color::Int = 0)

    # Create the window that will hold the contents.
    cwin = subpad(parent.buffer, nlines, ncols, begin_y, begin_x)

    # Create the widget.
    widget = WidgetLabel(parent = parent, text = "", cwin = cwin, color = color)

    # Update the text.
    change_text(widget, text; alignment = alignment)

    # Add to the parent window widget list.
    push!(parent.widgets, widget)

    # Return the created widget.
    return widget
end

function redraw(widget::WidgetLabel)
    @unpack cwin, color, text = widget
    wclear(cwin)
    color > 0 && wattron(cwin, color)
    mvwprintw(cwin, 0, 0, widget.text)
    color > 0 && wattroff(cwin, color)
    return nothing
end

################################################################################
#                           Custom widget functions
################################################################################

"""
    function change_text(widget::WidgetLabel, new_text::AbstractString; alignment = :l, color::Int = -1)

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

    @unpack cwin = widget

    # Get the dimensions of the window.
    _, wsx = _get_window_dims(cwin)

    # Split the string in each line.
    tokens = split(new_text, "\n")

    # Formatted text.
    text = ""

    for line in tokens
        # Check the alignment and print accordingly.
        if alignment == :r
            col   = wsx - length(line) - 1
            text *= " "^col * line * "\n"
        elseif alignment == :c
            col   = div(wsx - length(line), 2)
            text *= " "^col * line * "\n"
        else
            text *= line * "\n"
        end
    end

    widget.text = text

    # Set the color.
    color >= 0 && (widget.color = color)

    request_update(widget)

    return nothing
end
