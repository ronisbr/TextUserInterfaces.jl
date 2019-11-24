# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Widget: Radio button.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetRadioButton, get_selected

################################################################################
#                                     Type
################################################################################

@with_kw mutable struct WidgetRadioButton{T<:WidgetParent} <: Widget

    # API
    # ==========================================================================
    common::WidgetCommon{T}

    # Parameters related to the widget
    # ==========================================================================
    button::WidgetButton
    label::AbstractString
    group_name::AbstractString
    glyph_deselected::AbstractString
    glyph_selected::AbstractString
    selected::Bool = false
end

_radio_buttons_groups = Dict{String,Vector{WidgetRadioButton}}()

################################################################################
#                                     API
################################################################################

accept_focus(widget::WidgetRadioButton) = accept_focus(widget.button)

function create_widget(::Type{Val{:radio_button}}, parent::WidgetParent;
                       label::AbstractString = "Button",
                       color::Int = 0,
                       color_highlight::Int = 0,
                       glyph_selected = "[X]",
                       glyph_deselected = "[ ]",
                       group_name = "group",
                       kwargs...)

    # Create the button widget.
    button = create_widget(Val{:button}, parent;
                           label = glyph_deselected * " " * label,
                           color = color, color_highlight = color_highlight,
                           style = :none, _derive = true, kwargs...)

    # Create the widget.
    widget = WidgetRadioButton(common           = button.common,
                               button           = button,
                               label            = label,
                               glyph_deselected = glyph_deselected,
                               glyph_selected   = glyph_selected,
                               group_name       = group_name)

    # Function to be executed on return pressed.
    button.vargs_on_return_pressed = (widget,)
    button.on_return_pressed = (widget)->_select_radio_button(widget)

    # Add the new widget to the parent widget list.
    add_widget(parent, widget)

    common = widget.common
    @log info "create_widget" """
    A radio button was created in $(obj_desc(parent)).
        Size        = ($(common.height), $(common.width))
        Coordinate  = ($(common.top), $(common.left))
        Positioning = ($(common.posconf.vertical),$(common.posconf.horizontal))
        Label       = \"$label\"
        Group name  = $group_name
        Reference   = $(obj_to_ptr(widget))"""

    # Add the button to the desired group.
    if !haskey(_radio_buttons_groups, group_name)
        _radio_buttons_groups[group_name] = WidgetRadioButton[widget]
        _select_radio_button(widget)

        @log info "create_widget" """
        The radio button group \"$group_name\" was created with the radio button \"$label\" in it.
        """
    else
        push!(_radio_buttons_groups[group_name], widget)

        @log info "create_widget" """
        The radio button \"$label\" was added to the group \"$group_name\".
        """
    end

    # Return the created widget.
    return widget
end

process_focus(widget::WidgetRadioButton, k::Keystroke) = process_focus(widget.button, k)
redraw(widget::WidgetRadioButton) = redraw(widget.button, has_focus(widget.common.parent, widget))
release_focus(widget::WidgetRadioButton) = release_focus(widget.button)

################################################################################
#                           Custom widget functions
################################################################################

"""
    function get_selected(group_name::AbstractString)

Return the `WidgetRadioButton` that is selected in group with name `group_name`.
If the `group_name` does not exists or if no button is selected, then `nothing`
is returned.

"""
function get_selected(group_name::AbstractString)

    if !haskey(_radio_buttons_groups, group_name)
        @log warning "get_selected" """
        The radio button group named $group_name was not found!
        """

        return nothing
    else
        for b in _radio_buttons_groups[group_name]
            b.selected && return b
        end
    end
end

################################################################################
#                              Private functions
################################################################################

"""
    function _select_radio_button(rb::WidgetRadioButton)

Select the radio button `rb` in its group name.

"""
function _select_radio_button(rb::WidgetRadioButton)
    group_name = rb.group_name

    if !haskey(_radio_buttons_groups, group_name)
        @log warning "_select_radio_button" """
        The radio button group named $group_name was not found!
        """
    else
        for b in _radio_buttons_groups[group_name]
            _deselect_radio_button(b)
        end
    end

    change_label(rb.button, rb.glyph_selected * " " * rb.label)
    rb.selected = true
end

"""
    function _select_radio_button(rb::WidgetRadioButton)

Deselect the radio button `rb` in its group name.

"""
function _deselect_radio_button(rb::WidgetRadioButton)
    if rb.selected
        change_label(rb.button, rb.glyph_deselected * " " * rb.label)
        rb.selected = false
    end
end

