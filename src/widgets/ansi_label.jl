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
    aligned_text::Vector{String} = String[]
    aligned_text_colors::Vector{Int} = Int[]
end

############################################################################################
#                                        Object API                                        #
############################################################################################

function update_layout!(label::WidgetAnsiLabel; force::Bool = false)
    if update_widget_layout!(label; force = force)
        _parse_ansi_text!(label)
        return true
    else
        return false
    end
end

############################################################################################
#                                        Widget API                                        #
############################################################################################

can_accept_focus(::WidgetAnsiLabel) = false

function create_widget(
    ::Val{:ansi_label},
    layout::ObjectLayout;
    alignment = :l,
    fill::Bool = false,
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
      ID = $(label.id)
      Alignment = $(label.alignment)
      Text = \"$(label.text)\""""

    # Return the created container.
    return label
end

function redraw!(widget::WidgetAnsiLabel)
    @unpack buffer, theme, aligned_text, aligned_text_colors = widget
    wclear(buffer)

    mvwprintw(buffer, 0, 0, "")

    for i in 1:length(aligned_text)
        @ncolor aligned_text_colors[i] buffer begin
            wprintw(buffer, aligned_text[i])
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
    change_text!(widget::WidgetAnsiLabel, new_text::AbstractString; alignment = :l) -> Nothing

Change to text of the ANSI label `widget` to `new_text`. The text alignment in the widget
can be selected by the keyword `alignment`, which can be:

- `:l`: left alignment (**default**);
- `:c`: Center alignment; or
- `:r`: Right alignment.
"""
function change_text!(
    widget::WidgetAnsiLabel,
    new_text::AbstractString;
    alignment = :l
)
    widget.text = new_text
    widget.alignment = alignment

    _parse_ansi_text!(widget)

    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

# This function gets the text in the variable `text`, and converts the ANSI escape sequences
# to NCurse colors. It is only called when the widget layout is updated.
function _parse_ansi_text!(widget::WidgetAnsiLabel)
    # If the widget does not has a container, then we cannot align the text.
    isnothing(widget.container) && return nothing

    @unpack alignment, buffer, text, width = widget

    # Split the string in each line.
    tokens = split(text, "\n")

    # Formatted text.
    text = ""

    for line in tokens
        # Notice that if the ANSI escape sequence is not valid, then the alignment will not
        # be correct. This regex remove all ANSI escape sequences to count for the printable
        # characters.
        if alignment ∈ [:r, :c]
            printable_line = remove_decorations(line)
            line_width     = textwidth(printable_line)
        else
            line_width = 0
        end

        # Check the alignment and print accordingly.
        if alignment === :r
            col   = width - line_width - 1
            text *= " "^col * line * "\n"
        elseif alignment === :c
            col   = div(width - line_width, 2)
            text *= " "^col * line * "\n"
        else
            text *= line * "\n"
        end
    end

    # Parse the ANSI escape sequences.
    vstr, vd = parse_ansi_string(text)
    num_decorations = length(vd)

    colors = Vector{Int}(undef, num_decorations)

    @inbounds for i in 1:num_decorations
        d = vd[i]
        c = ncurses_color(
            d.foreground,
            d.background;
            bold      = d.bold,
            underline = d.underline
        )
        colors[i] = c
    end

    widget.aligned_text = vstr
    widget.aligned_text_colors = colors

    update_layout!(widget)
    request_update!(widget)

    return nothing
end
