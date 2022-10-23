# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Widget: Label.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetLabel

################################################################################
#                                  Structure
################################################################################

@widget mutable struct WidgetLabel
    # Input label data from the user.
    alignment::Symbol
    fill::Bool
    text::AbstractString

    # Variable to store the aligned text to save computational burden.
    _text::AbstractString
end

################################################################################
#                                  Object API
################################################################################

function update_layout!(label::WidgetLabel; force::Bool = false)
    if invoke(update_layout!, Tuple{Widget}, label; force = force)
        _align_text!(label)
        return true
    else
        return false
    end
end

################################################################################
#                                  Widget API
################################################################################

can_accept_focus(::WidgetLabel) = false

function create_widget(
    ::Val{:label},
    layout::ObjectLayout;
    alignment = :l,
    fill::Bool = false,
    theme::Theme = tui.default_theme,
    text::AbstractString = "Label"
)
    # Check the text to create the layout hints.
    tokens = split(text, '\n')
    height = length(tokens)
    width  = maximum(length.(tokens)) + 1

    # Create the widget.
    label = WidgetLabel(
        id               = reserve_object_id(),
        alignment        = alignment,
        fill             = fill,
        layout           = layout,
        text             = text,
        theme            = theme,
        _text            = text,
        horizontal_hints = (; width = width),
        vertical_hints   = (; height = height)
    )

    @log INFO "create_widget" """
    WidgetLabel created:
        ID = $(label.id)
        Alignment = $(label.alignment)
        Fill color = $(label.fill)
        Text = \"$(label.text)\""""

    # Return the created container.
    return label
end

function redraw!(widget::WidgetLabel)
    @unpack buffer, theme, _text = widget
    wclear(buffer)

    @ncolor theme.default buffer begin
        mvwprintw(buffer, 0, 0, _text)
    end

    return nothing
end

################################################################################
#                                   Helpers
################################################################################

@create_widget_helper label

################################################################################
#                              Private functions
################################################################################

# This function gets the text in variable `text`, and apply the alignment. It
# is only called when the widget layout is updated.
function _align_text!(widget::WidgetLabel)
    # If the widget does not has a container, then we cannot align the text.
    isnothing(widget.container) && return nothing

    @unpack alignment, buffer, fill, text, width = widget

    # Split the string in each line.
    tokens = split(text, "\n")

    # Buffers to store the formatted text and line.
    buf  = IOBuffer()
    bufl = IOBuffer()

    for line in tokens

        # Check the alignment and print accordingly.
        if alignment == :r
            col = width - textwidth(line) - 1
            write(bufl, " " ^ col, line)
        elseif alignment == :c
            col = div(width - textwidth(line), 2)
            write(bufl, " " ^ col, line)
        else
            write(bufl, line)
        end

        # If `fill` is `true`, then fill the remaining spaces up to the
        # widget width.
        if fill
            formatted_line = String(take!(bufl))
            rem = clamp(width - textwidth(formatted_line) - 1, 0, width)
            write(buf, formatted_line, " " ^ rem, '\n')
        else
            write(buf, take!(bufl), '\n')
        end
    end

    widget._text = String(take!(buf))

    request_update!(widget)

    return nothing
end
