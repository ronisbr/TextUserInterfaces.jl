## Description #############################################################################
#
# Widget: ANSI label.
#
############################################################################################

export WidgetAnsiLabel
export change_text!

############################################################################################
#                                        Structure                                         #
############################################################################################

@widget mutable struct WidgetAnsiLabel
    # Input label data from the user.
    alignment::Symbol
    text::String

    # Variables to store the parsed text and color to reduce the computational burden.
    aligned_text::Vector{Vector{Pair{String, NCursesStyle}}} = Vector{Pair{String, NCursesStyle}}[]
end

############################################################################################
#                                        Object API                                        #
############################################################################################

function update_layout!(label::WidgetAnsiLabel; force::Bool = false)
    if update_widget_layout!(label; force = force)
        _widget_ansi_label__parse_ansi_text!(label)
        return true
    end

    return false
end

############################################################################################
#                                        Widget API                                        #
############################################################################################

can_accept_focus(::WidgetAnsiLabel) = false

function create_widget(
    ::Val{:ansi_label},
    layout::ObjectLayout;
    alignment = :l,
    theme::Theme = Theme(),
    text::String = "Label"
)
    # Check the text to create the layout hints.
    lines  = split(text, '\n')
    height = length(lines)
    width  = maximum(printable_textwidth.(lines))

    # Create the widget.
    label = WidgetAnsiLabel(;
        id               = reserve_object_id(),
        alignment        = alignment,
        layout           = layout,
        text             = text,
        theme            = theme,
        horizontal_hints = Dict(:width  => width),
        vertical_hints   = Dict(:height => height)
    )

    @log DEBUG "create_widget" """
    WidgetAnsiLabel created:
      ID        = $(label.id)
      Alignment = $(label.alignment)
      Text      = \"$(label.text)\""""

    # Return the created container.
    return label
end

function redraw!(widget::WidgetAnsiLabel)
    @unpack buffer, aligned_text = widget
    NCurses.wclear(buffer)

    NCurses.mvwprintw(buffer, 0, 0, "")

    @inbounds for l in eachindex(aligned_text)
        line = aligned_text[l]
        line_number = l - firstindex(aligned_text) + 1

        NCurses.mvwprintw(buffer, line_number - 1, 0, "")

        for (text, style) in line
            @nstyle style buffer begin
                NCurses.wprintw(buffer, text)
            end
        end
    end

    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper ansi_label

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    change_text!(widget::WidgetAnsiLabel, new_text::AbstractString; alignment = widget.alignment) -> Nothing

Change to text of the ANSI label `widget` to `new_text`. The text alignment in the widget
can be selected by the keyword `alignment`, which can be:

- `:l`: left alignment;
- `:c`: Center alignment; or
- `:r`: Right alignment.

By default, it uses the current alignment of `widget`.
"""
function change_text!(
    widget::WidgetAnsiLabel,
    new_text::AbstractString;
    alignment::Symbol = widget.alignment
)
    widget.text      = new_text
    widget.alignment = alignment

    _widget_ansi_label__parse_ansi_text!(widget)

    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _widget_ansi_label__parse_ansi_text!(widget::WidgetAnsiLabel) -> Nothing

This function gets the `text` in `widget` and converts the ANSI escape sequences to NCurse
colors. It is only called when the widget layout is updated.
"""
function _widget_ansi_label__parse_ansi_text!(widget::WidgetAnsiLabel)
    # If the widget does not has a container, then we cannot align the text.
    isnothing(widget.container) && return nothing

    @unpack alignment, buffer, text, width, aligned_text = widget

    # First, we align the string in available width.
    aligned_str = align_string_per_line(text, width, alignment)

    # Split the string in each line.
    tokens = split(aligned_str, '\n')

    # Empty the vectors with the string and decorations.
    empty!(aligned_text)

    # Variable that will store the previous decoration.
    pd = Decoration()

    for line in tokens
        parsed_line = parse_ansi_string(line)

        line_decoration = Pair{String, NCursesStyle}[]

        for (t, d) in parsed_line
            pd = update_decoration(pd, d)

            if pd.reset
                # Reset the decoration to default values.
                pd = Decoration()
            end

            # We are updating the decoration since the beginning. Hence, the properties
            # `bold`, `underline`, and `reversed` are only on if they are active.
            style = tui_style(
                ansi_foreground_to_colorant(pd.foreground),
                ansi_background_to_colorant(pd.background);
                bold      = pd.bold      == StringManipulation.active,
                underline = pd.underline == StringManipulation.active,
                reversed  = pd.reversed  == StringManipulation.active
            )

            push!(line_decoration, t => style)
        end

        push!(aligned_text, line_decoration)
    end

    update_layout!(widget)
    request_update!(widget)

    return nothing
end
