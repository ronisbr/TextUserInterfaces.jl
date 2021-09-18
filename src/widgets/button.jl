# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Widget: Button.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetButton, change_label

################################################################################
#                                     Type
################################################################################

@widget mutable struct WidgetButton
    label::String
    color::Int
    color_highlight::Int
    style::Symbol

    # Signals
    # ==========================================================================
    @signal return_pressed
end

# Conversion dictionary between style and height.
const _button_style_height = Dict(
    :boxed  => 3,
    :simple => 1,
    :none   => 1
)

# Conversion dictionary between style and width that must be added to the label
# length.
const _button_style_width = Dict(
    :boxed  => 4,
    :simple => 4,
    :none   => 0
)

################################################################################
#                                     API
################################################################################

function accept_focus(widget::WidgetButton)
    request_update(widget)
    return true
end

function create_widget(
    ::Val{:button},
    layout::ObjectLayout;
    label::AbstractString = "Button",
    color::Int = _color_default,
    color_highlight::Int = _color_highlight,
    style::Symbol = :simple
)

    # Check arguments.
    if !haskey(_button_style_height, style)
        @log warning "create_widget" """
        The button style :$style is not known.
        The style :simple will be used."""

        style = :simple
    end

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    horizontal = _process_horizontal_info(layout)
    vertical   = _process_vertical_info(layout)

    if vertical == :unknown
        layout.height = _button_style_height[style]
    end

    if horizontal == :unknown
        layout.width = length(label) + _button_style_width[style]
    end

    # Create the widget.
    widget = WidgetButton(
        layout          = layout,
        label           = label,
        color           = color,
        color_highlight = color_highlight,
        style           = style
    )

    @connect_signal widget key_pressed process_keystroke

    @log info "create_widget" """
    Button created:
        Reference   = $(obj_to_ptr(widget))
        Label       = \"$label\"
        Style       = $style"""

    # Return the created widget.
    return widget
end

function process_keystroke(widget::WidgetButton, k::Keystroke)
    k.ktype == :enter && (@emit_signal widget return_pressed)
    return true
end

redraw(widget::WidgetButton) = redraw(widget, has_focus(widget.parent,widget))

function redraw(widget::WidgetButton, focused::Bool)
    wclear(widget.buffer)

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
    change_label(button::WidgetButton, label::AbstractString)

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
    @unpack buffer, color_highlight, width, color, label, parent, style = widget

    # Get the background color depending on the focus.
    c = focused ? color_highlight : color

    if style == :none
        wattron(buffer, c)
        mvwprintw(buffer, 0, 0, label)
        wattroff(buffer, c)
    else
        # Center the label in the button.
        w   = width
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

################################################################################
#                                   Helpers
################################################################################

@create_widget_helper button
