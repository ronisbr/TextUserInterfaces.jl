# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Widget: Button.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetButton, change_label

################################################################################
#                                     Type
################################################################################

@with_kw mutable struct WidgetButton{T<:WidgetParent} <: Widget

    # API
    # ==========================================================================
    common::WidgetCommon{T}

    # Parameters related to the widget
    # ==========================================================================
    label::String
    color::Int
    color_highlight::Int
    style::Symbol

    # Signals
    # ==========================================================================
    on_return_pressed::Function = ()->return nothing
    vargs_on_return_pressed::Tuple = ()
end

# Conversion dictionary between style and height.
_button_style_height = Dict(:boxed  => 3,
                            :simple => 1,
                            :none   => 1)

################################################################################
#                                     API
################################################################################

function accept_focus(widget::WidgetButton)
    request_update(widget)
    return true
end

function create_widget(::Type{Val{:button}}, parent::WidgetParent;
                       label::AbstractString = "Button",
                       color::Int = 0,
                       color_highlight::Int = 0,
                       style::Symbol = :simple,
                       _derive::Bool = false,
                       kwargs...)

    # Check arguments.
    if !haskey(_button_style_height, style)
        @log warning "create_widget" """
        The button style :$style is not known.
        The style :simple will be used."""

        style = :simple
    end

    # Positioning configuration.
    posconf = wpc(;kwargs...)

    # Initial processing of the position.
    _process_vertical_info!(posconf)
    _process_horizontal_info!(posconf)

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    if posconf.vertical == :unknown
        posconf.height = _button_style_height[style]
    end

    if posconf.horizontal == :unknown
        posconf.width = length(label) + 4
    end

    # Create the common parameters of the widget.
    common = create_widget_common(parent, posconf)

    # Create the widget.
    widget = WidgetButton(common          = common,
                          label           = label,
                          color           = color,
                          color_highlight = color_highlight,
                          style           = style)

    # Add the new widget to the parent widget list.
    !_derive && add_widget(parent, widget)

    !_derive && @log info "create_widget" """
    A button was created in $(obj_desc(parent)).
        Size        = ($(common.height), $(common.width))
        Coordinate  = ($(common.top), $(common.left))
        Positioning = ($(common.posconf.vertical),$(common.posconf.horizontal))
        Label       = \"$label\"
        Style       = $style
        Reference   = $(obj_to_ptr(widget))"""

    # Return the created widget.
    return widget
end

function process_focus(widget::WidgetButton, k::Keystroke)
    if k.ktype == :tab
        return false
    elseif k.ktype == :enter
        @log verbose "change_value" "$(obj_desc(widget)): Enter pressed on focused button."
        widget.on_return_pressed(widget.vargs_on_return_pressed...)
    end

    return true
end

redraw(widget::WidgetButton) = redraw(widget, has_focus(widget.common.parent,widget))

function redraw(widget::WidgetButton, focused::Bool)
    wclear(widget.common.buffer)

    # Draw the button.
    _draw_button(widget, focused)

    return nothing
end

function release_focus(widget::WidgetButton)
    request_update(widget)
    return true
end

################################################################################
#                           Custom widget functions
################################################################################

"""
    function change_label(button::WidgetButton, label::AbstractString)

Change the label of button `button` to `label`.

"""
function change_label(button::WidgetButton, label::AbstractString)
    button.label = label
    request_update(button)
    return nothing
end

################################################################################
#                               Derived widgets
################################################################################

include("./radio_button.jl")

################################################################################
#                              Private functions
################################################################################

function _draw_button(widget::WidgetButton, focused::Bool = false)
    @unpack common, label, color, color_highlight, style = widget
    @unpack buffer, parent = common

    # Get the background color depending on the focus.
    c = focused ? color_highlight : color

    if style == :none
        wattron(buffer, c)
        mvwprintw(buffer, 0, 0, label)
        wattroff(buffer, c)
    else
        # Center the label in the button.
        w   = common.width
        Δ   = w - 4 - length(label)
        pad = div(Δ,2)
        str = " "^pad * label * " "^(Δ - pad)

        if style == :boxed
            mvwprintw(buffer, 0, 0, "┌" * "─"^(w-2) * "┐")
            mvwprintw(buffer, 1, 0, "│")

            wattron(buffer, c)
            wprintw(buffer, " " * str * " ")
            wattroff(buffer, c)

            wprintw(buffer, "│")
            mvwprintw(buffer, 2, 0, "└" * "─"^(w-2) * "┘")
        else
            wattron(buffer, c)
            mvwprintw(buffer, 0, 0, "[ " * str * " ]")
            wattroff(buffer, c)
        end
    end

    return nothing
end
