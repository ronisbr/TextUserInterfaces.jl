## Description #############################################################################
#
# Widget: Label.
#
############################################################################################

export WidgetLabel
export change_label!

############################################################################################
#                                        Structure                                         #
############################################################################################

@widget mutable struct WidgetLabel
    # Input label data from the user.
    alignment::Symbol
    fill::Bool
    label::String

    # == Private Fields ====================================================================

    # Variable to store the aligned text to save computational burden.
    _aligned_label::String = ""
end

############################################################################################
#                                        Object API                                        #
############################################################################################

function update_layout!(label::WidgetLabel; force::Bool = false)
    if update_widget_layout!(label; force = force)
        _widget_label__align_label!(label)
        return true
    end

    return false
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
    label::String = "Label",
    theme::Theme = Theme()
)
    # Check the text to create the layout hints.
    height = 1
    width  = textwidth(label) + 1

    # Create the widget.
    label = WidgetLabel(;
        id           = reserve_object_id(),
        alignment    = alignment,
        fill         = fill,
        label        = label,
        layout       = layout,
        theme        = theme,
        layout_hints = Dict(:height => height, :width  => width)
    )

    @log DEBUG "create_widget" """
    WidgetLabel created:
      ID        = $(label.id)
      Alignment = $(label.alignment)
      Fill      = $(label.fill)
      Label     = \"$(label.label)\""""

    # Return the created container.
    return label
end

function redraw!(widget::WidgetLabel)
    @unpack buffer, fill, theme, _aligned_label = widget
    NCurses.wclear(buffer)

    style = get_style(theme, :default)

    fill && set_background_style!(buffer, style)

    @nstyle style buffer begin
        NCurses.mvwprintw(buffer, 0, 0, _aligned_label)
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
    change_label!(widget::WidgetLabel, new_label::AbstractString; alignment = widget.alignment) -> Nothing

Change to label of the `widget` to `new_label`. The label alignment in the widget can be
selected by the keyword `alignment`, which can be:

- `:l`: left alignment);
- `:c`: Center alignment; or
- `:r`: Right alignment.

By default, it uses the current alignment of `widget`.
"""
function change_label!(
    widget::WidgetLabel,
    new_label::AbstractString;
    alignment = widget.alignment
)
    widget.label     = new_label
    widget.alignment = alignment

    _widget_label__align_label!(widget)

    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _widget_label__align_label!(widget::WidgetLabel) -> Nothing

This function gets the label in variable `label`, and apply the alignment. It is only called
when the widget layout is updated.
"""
function _widget_label__align_label!(widget::WidgetLabel)
    # If the widget does not has a container, then we cannot align the text.
    isnothing(widget.container) && return nothing

    @unpack alignment, label, width = widget

    widget._aligned_label = align_string(escape_string(label), width, alignment)

    request_update!(widget)

    return nothing
end