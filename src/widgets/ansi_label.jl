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
    aligned_text::Vector{Vector{String}} = Vector{String}[]
    aligned_text_colors::Vector{Vector{Int}} = Int[]
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
    theme::Theme = tui.default_theme,
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
        horizontal_hints = Dict(:width => width),
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
    @unpack buffer, theme, aligned_text, aligned_text_colors = widget
    NCurses.wclear(buffer)

    NCurses.mvwprintw(buffer, 0, 0, "")

    @inbounds for l in 1:length(aligned_text)
        line = aligned_text[l]
        line_colors = aligned_text_colors[l]

        NCurses.mvwprintw(buffer, l - 1, 0, "")

        for i in 1:length(line)
            @ncolor line_colors[i - 1 + begin] buffer begin
                NCurses.wprintw(buffer, line[i - 1 + begin])
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
    alignment = widget.alignment
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

    @unpack alignment, buffer, text, width, aligned_text, aligned_text_colors = widget

    # Split the string in each line.
    tokens = split(text, "\n")

    # Empty the vectors with the string and decorations.
    empty!(aligned_text)
    empty!(aligned_text_colors)

    # Variable that will store the decorations of the previous line.
    vd = nothing

    for line in tokens
        # Formatted text.
        text = ""

        # Notice that if the ANSI escape sequence is not valid, the alignment will not be
        # correct. This regex remove all ANSI escape sequences to count for the printable
        # characters.
        if (alignment == :r) || (alignment == :c)
            printable_line = remove_decorations(line)
            line_width     = textwidth(printable_line)
        else
            line_width = 0
        end

        # Align the current line accordingly.
        if alignment == :r
            col   = width - line_width - 1
            text *= " "^col * line
        elseif alignment == :c
            col   = div(width - line_width, 2)
            text *= " "^col * line
        else
            text *= line
        end

        # Get the decoration of the last line, if it exists.
        decoration = (!isnothing(vd) && !isempty(vd)) ?
            last(vd) :
            ParseAnsiColors.Decoration()

        # Now, we need to parse ANSI escape sequences and build the decorations for this
        # line.
        vstr, vd = parse_ansi_string(text, decoration)
        num_decorations = length(vd)

        colors = Vector{Int}(undef, num_decorations)

        @inbounds for i in 1:num_decorations
            d = vd[i - 1 + begin]
            c = ncurses_color(
                d.foreground,
                d.background;
                bold      = d.bold,
                underline = d.underline
            )
            colors[i - 1 + begin] = c
        end

        push!(aligned_text, vstr)
        push!(aligned_text_colors, colors)
    end

    update_layout!(widget)
    request_update!(widget)

    return nothing
end
