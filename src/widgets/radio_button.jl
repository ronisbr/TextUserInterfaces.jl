# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Widget: Radio button.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetRadioButton, get_selected

################################################################################
#                                     Type
################################################################################

@derived_widget mutable struct WidgetRadioButton
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

accept_focus(widget::WidgetRadioButton) = accept_focus(widget.base)

function create_widget(::Val{:radio_button},
                       opc::ObjectPositioningConfiguration;
                       label::AbstractString = "Button",
                       color::Int = _color_default,
                       color_highlight::Int = _color_highlight,
                       glyph_selected::String = "[X]",
                       glyph_deselected::String = "[ ]",
                       group_name::String = "group")

    # Create the button widget.
    button = create_widget(Val(:button), opc;
                           label = glyph_deselected * " " * label,
                           color = color, color_highlight = color_highlight,
                           style = :none)

    # Current size and position of the widget.
    widget = WidgetRadioButton(base             = button,
                               label            = label,
                               glyph_deselected = glyph_deselected,
                               glyph_selected   = glyph_selected,
                               group_name       = group_name)

    # Function to be executed on return pressed.
    @connect_signal button key_pressed _handler_key_pressed widget

    @log info "create_widget" """
    Radio button created:
        Label      = \"$label\"
        Group name = $group_name
        Reference  = $(obj_to_ptr(widget))"""

    # Add the button to the desired group.
    if !haskey(_radio_buttons_groups, group_name)
        _radio_buttons_groups[group_name] = WidgetRadioButton[widget]
        _select_radio_button(widget)

        @log info "create_widget" "Radio button group \"$group_name\" created."
    else
        push!(_radio_buttons_groups[group_name], widget)

        @log info "create_widget" "$(obj_desc(widget)) added to the group \"$group_name\"."
    end

    # Return the created widget.
    return widget
end

# We must override the function `destroy_widget` function because we need to
# remove the radio button from the global list.
function destroy_widget(rb::WidgetRadioButton; refresh::Bool = true)
    @unpack buffer, parent = rb

    if haskey(_radio_buttons_groups, rb.group_name)
        v  = _radio_buttons_groups[rb.group_name]
        id = findfirst(x->x === rb, v)

        if id != nothing
            deleteat!(v,id)

            @log info "destroy_widget" "$(obj_desc(rb)) removed from group \"$(rb.group_name)\"."

            if isempty(v)
                pop!(_radio_buttons_groups, rb.group_name)

                @log info "destroy_widget" "Radio group name \"$(rb.group_name)\" deleted."
            else
                # If the deleted button was selected, then we must select
                # another one.
                rb.selected && _select_radio_button(v[1])
            end
        end
    end

    _destroy_widget(rb; refresh = refresh)
end

process_focus(widget::WidgetRadioButton, k::Keystroke) = process_focus(widget.base, k)
redraw(widget::WidgetRadioButton) = redraw(widget.base, has_focus(widget.parent, widget))
release_focus(widget::WidgetRadioButton) = release_focus(widget.base)

################################################################################
#                           Custom widget functions
################################################################################

"""
    get_selected(group_name::AbstractString)

Return the `WidgetRadioButton` that is selected in group with name `group_name`.
If the `group_name` does not exists or if no button is selected, then `nothing`
is returned.

"""
function get_selected(group_name::AbstractString)

    if !haskey(_radio_buttons_groups, group_name)
        @log warning "get_selected" "The radio button group named \"$group_name\" was not found!"

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

# Signal handler.
_handler_key_pressed(w, k, rb) = k.ktype == :enter && _select_radio_button(rb)

"""
    _select_radio_button(rb::WidgetRadioButton)

Select the radio button `rb` in its group name.

"""
function _select_radio_button(rb::WidgetRadioButton)
    group_name = rb.group_name

    if !haskey(_radio_buttons_groups, group_name)
        @log warning "_select_radio_button" "The radio button group named \"$group_name\" was not found!"
    else
        for b in _radio_buttons_groups[group_name]
            _deselect_radio_button(b)
        end
    end

    change_label(rb.base, rb.glyph_selected * " " * rb.label)
    rb.selected = true
end

"""
    _select_radio_button(rb::WidgetRadioButton)

Deselect the radio button `rb` in its group name.

"""
function _deselect_radio_button(rb::WidgetRadioButton)
    if rb.selected
        change_label(rb.base, rb.glyph_deselected * " " * rb.label)
        rb.selected = false
    end
end
