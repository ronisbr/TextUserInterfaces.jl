## Description #############################################################################
#
# Widget: Text.
#
############################################################################################

export WidgetText
export change_text!

############################################################################################
#                                        Structure                                         #
############################################################################################

@widget mutable struct WidgetText
    # Input label data from the user.
    alignment::Symbol
    auto_wrap::Bool
    fill::Bool
    text::String

    # == Private Fields ====================================================================

    # Variable to store the aligned text to save computational burden.
    _aligned_text::Vector{String} = String[]
end

############################################################################################
#                                        Object API                                        #
############################################################################################

function update_layout!(label::WidgetText; force::Bool = false)
    if update_widget_layout!(label; force = force)
        label.auto_wrap && _widget_text__auto_wrap_text!(label)
        _widget_text__align_text!(label)
        return true
    end

    return false
end

############################################################################################
#                                        Widget API                                        #
############################################################################################

can_accept_focus(::WidgetText) = false

function create_widget(
    ::Val{:text},
    layout::ObjectLayout;
    alignment = :l,
    auto_wrap::Bool = false,
    fill::Bool = false,
    text::String = "Text",
    theme::Theme = Theme()
)
    esc_text = escape_string(text; keep = ('\n'))

    # Check the text to create the layout hints.
    tokens = split(esc_text, '\n')
    height = length(tokens)
    width  = maximum(textwidth.(tokens)) + 1

    # Create the widget.
    label = WidgetText(;
        id           = reserve_object_id(),
        alignment    = alignment,
        auto_wrap    = auto_wrap,
        fill         = fill,
        layout       = layout,
        text         = esc_text,
        theme        = theme,
        layout_hints = Dict(:height => height, :width  => width),
    )

    @log DEBUG "create_widget" """
    WidgetText created:
      ID        = $(label.id)
      Alignment = $(label.alignment)
      Auto wrap = $(label.auto_wrap)
      Fill      = $(label.fill)
      Text      = \"$(label.text)\""""

    # Return the created container.
    return label
end

function redraw!(widget::WidgetText)
    @unpack buffer, fill, theme, _aligned_text = widget
    NCurses.wclear(buffer)

    style = get_style(theme, :default)

    fill && set_background_style!(buffer, style)

    @nstyle style buffer begin
        for (i, line) in enumerate(_aligned_text)
            NCurses.mvwprintw(buffer, i - 1, 0, line)
        end
    end

    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper text

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    change_text(widget::WidgetText, new_text::AbstractString; alignment = widget.alignment) -> Nothing

Change to text of the `widget` to `new_text`. The text alignment in the widget can be
selected by the keyword `alignment`, which can be:

- `:l`: left alignment);
- `:c`: Center alignment; or
- `:r`: Right alignment.

By default, it uses the current alignment of `widget`.
"""
function change_text!(
    widget::WidgetText,
    new_text::AbstractString;
    alignment = widget.alignment
)
    widget.text      = new_text
    widget.alignment = alignment

    _widget_text__align_text!(widget)

    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _widget_text__align_text!(widget::WidgetText) -> Nothing

This function gets the text in variable `text`, and apply the alignment. It is only called
when the widget layout is updated.
"""
function _widget_text__align_text!(widget::WidgetText)
    # If the widget does not has a container, then we cannot align the text.
    isnothing(widget.container) && return nothing

    @unpack alignment, text, width = widget
    widget._aligned_text = split(align_string_per_line(text, width, alignment), '\n')

    request_update!(widget)

    return nothing
end

function _widget_text__auto_wrap_text!(widget::WidgetText)
    # If the widget does not has a container, we do not have size information.
    isnothing(widget.container) && return nothing

    @unpack text, width = widget

    # Buffers.
    buf      = IOBuffer(sizehint = length(text)) # ......... Buffer to store the entire text
    line_buf = IOBuffer(sizehint = length(text)) # ........ Buffer to store the current line

    # Auxiliary variables.
    state          = :text # .................................................. String state
    c_id           = 0     # ................................... ID of the current character
    line_width     = 0     # .................................... Total line printable width
    last_space     = 0     # ................................ ID of the last space character
    lw_after_space = 0     # ..................... Line width after the last space character

    for c in text
        state = StringManipulation._next_string_state(c, state)
        ctw = textwidth(c)

        if state != :text
            write(line_buf, c)
            c_id += ncodeunits(c)
            continue
        end

        line_overflow = line_width + ctw > width

        @views if (c == '\n') || (line_overflow && ((last_space == 0) || (c == ' ')))
            # If the character is a line break, if we have a line overflow and we do not
            # have any space in this line, or if we have a line overflow and this character
            # is a space, we only flush the current line buffer to the output buffer.
            write(buf, take!(line_buf))
            write(buf, '\n')

            c_id       = 0
            line_width = 0
            last_space = 0

            (c ∈ (' ', '\n')) && continue

        elseif line_overflow
            line = take!(line_buf)

            # If we have a last space in this line, break the line at that position, and
            # move the rest to another line.
            l₀ = line[1:last_space - 1]
            l₁ = line[last_space + 1:end]

            write(buf, l₀)
            write(buf, '\n')
            write(line_buf, l₁)

            c_id       = length(l₁)
            line_width = lw_after_space
            last_space = 0
        end

        write(line_buf, c)
        c_id += ncodeunits(c)

        line_width     += textwidth(c)
        lw_after_space += ctw

        if c == ' '
            last_space     = c_id
            lw_after_space = 0
        end
    end

    # Flush the rest of the line.
    write(buf, take!(line_buf))

    widget.text = String(take!(buf))

    return nothing
end