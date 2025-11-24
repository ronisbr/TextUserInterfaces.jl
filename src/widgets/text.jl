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
    fill::Bool = false,
    text::String = "Text",
    theme::Theme = tui.default_theme,
)
    # Check the text to create the layout hints.
    tokens = split(text, '\n')
    height = length(tokens)
    width  = maximum(textwidth.(tokens)) + 1

    # Create the widget.
    label = WidgetText(;
        id               = reserve_object_id(),
        alignment        = alignment,
        fill             = fill,
        layout           = layout,
        text             = text,
        theme            = theme,
        horizontal_hints = Dict(:width  => width),
        vertical_hints   = Dict(:height => height)
    )

    @log DEBUG "create_widget" """
    WidgetText created:
      ID        = $(label.id)
      Alignment = $(label.alignment)
      Fill      = $(label.fill)
      Text      = \"$(label.text)\""""

    # Return the created container.
    return label
end

function redraw!(widget::WidgetText)
    @unpack buffer, fill, theme, _aligned_text = widget
    NCurses.wclear(buffer)

    fill && NCurses.wbkgd(buffer, theme.default)

    @ncolor theme.default buffer begin
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
