## Description #############################################################################
#
# Widget: Label.
#
############################################################################################

export WidgetLabel
export change_text!

############################################################################################
#                                        Structure                                         #
############################################################################################

@widget mutable struct WidgetLabel
    # Input label data from the user.
    alignment::Symbol
    fill::Bool
    text::String

    # Variable to store the aligned text to save computational burden.
    aligned_text::Vector{String}
end

############################################################################################
#                                        Object API                                        #
############################################################################################

function update_layout!(label::WidgetLabel; force::Bool = false)
    if update_widget_layout!(label; force = force)
        _align_text!(label)
        return true
    else
        return false
    end
end

############################################################################################
#                                        Widget API                                        #
############################################################################################

can_accept_focus(::WidgetLabel) = false

function create_widget(
    ::Val{:label},
    layout::ObjectLayout;
    alignment = :l,
    fill::Bool = false,
    theme::Theme = tui.default_theme,
    text::String = "Label"
)
    # Check the text to create the layout hints.
    tokens = split(text, '\n')
    height = length(tokens)
    width  = maximum(length.(tokens)) + 1

    # Create the widget.
    label = WidgetLabel(;
        id               = reserve_object_id(),
        alignment        = alignment,
        fill             = fill,
        layout           = layout,
        text             = text,
        theme            = theme,
        aligned_text     = tokens,
        horizontal_hints = Dict(:width => width),
        vertical_hints   = Dict(:height => height)
    )

    @log DEBUG "create_widget" """
    WidgetLabel created:
      ID        = $(label.id)
      Alignment = $(label.alignment)
      Fill      = $(label.fill)
      Text      = \"$(label.text)\""""

    # Return the created container.
    return label
end

function redraw!(widget::WidgetLabel)
    @unpack buffer, theme, aligned_text = widget
    NCurses.wclear(buffer)

    @ncolor theme.default buffer begin
        @inbounds for l in 1:length(aligned_text)
            NCurses.mvwprintw(buffer, l - 1, 0, aligned_text[l])
        end
    end

    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper label

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    change_text!(widget::WidgetLabel, new_text::AbstractString; alignment = widget.alignment) -> Nothing

Change to text of the label `widget` to `new_text`. The text alignment in the widget can be
selected by the keyword `alignment`, which can be:

- `:l`: left alignment);
- `:c`: Center alignment; or
- `:r`: Right alignment.

By default, it uses the current alignment of `widget`.

The text color can be selected by the keyword `color`. It it is negative (**default**), the
current color will not be changed.
"""
function change_text!(
    widget::WidgetLabel,
    new_text::AbstractString;
    alignment = widget.alignment
)
    widget.text = new_text
    widget.alignment = alignment

    _align_text!(widget)

    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

# This function gets the text in variable `text`, and apply the alignment. It is only called
# when the widget layout is updated.
function _align_text!(widget::WidgetLabel)
    # If the widget does not has a container, then we cannot align the text.
    isnothing(widget.container) && return nothing

    @unpack alignment, buffer, fill, text, width, aligned_text = widget

    # Split the string in each line.
    tokens = split(text, "\n")

    # Buffers to store the line.
    bufl = IOBuffer()

    empty!(aligned_text)
    sizehint!(aligned_text, length(tokens))

    for line in tokens
        # Check the alignment and print accordingly.
        if alignment == :r
            col = width - textwidth(line)
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
            rem = clamp(width - textwidth(formatted_line), 0, width)
            push!(aligned_text, formatted_line * " " ^ rem)
        else
            push!(aligned_text, String(take!(bufl)))
        end
    end

    request_update!(widget)

    return nothing
end
