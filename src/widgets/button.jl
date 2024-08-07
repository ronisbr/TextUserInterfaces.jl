## Description #############################################################################
#
# Widget: Button.
#
############################################################################################

export WidgetButton

############################################################################################
#                                        Structure                                         #
############################################################################################

@widget mutable struct WidgetButton
    label::String
    style::Symbol

    # == Signals ===========================================================================

    @signal return_pressed
end

# Conversion dictionary between style and height.
const _BUTTON_STYLE_HEIGHT = Dict(
    :boxed  => 3,
    :simple => 1,
    :none   => 1
)

# Conversion dictionary between style and width that must be added to the label
# length.
const _BUTTON_STYLE_WIDTH = Dict(
    :boxed  => 4,
    :simple => 4,
    :none   => 0
)

############################################################################################
#                                        Object API                                        #
############################################################################################

############################################################################################
#                                        Widget API                                        #
############################################################################################

can_accept_focus(::WidgetButton) = true

function create_widget(
    ::Val{:button},
    layout::ObjectLayout;
    label::AbstractString = "Button",
    style::Symbol = :simple,
    theme::Theme = tui.default_theme
)
    # Check arguments.
    if !haskey(_BUTTON_STYLE_HEIGHT, style)
        @log WARNING "create_widget" """
        The button style :$style is not known.
        The style :simple will be used."""
        style = :simple
    end

    # Create the widget.
    button = WidgetButton(;
        id               = reserve_object_id(),
        label            = label,
        layout           = layout,
        style            = style,
        theme            = theme,
        horizontal_hints = Dict(:width => textwidth(label) + _BUTTON_STYLE_WIDTH[style]),
        vertical_hints   = Dict(:height => _BUTTON_STYLE_HEIGHT[style])
    )

    @log DEBUG "create_widget" """
    WidgetButton created:
      ID    = $(button.id)
      Label = $(button.label)
      Style = $(button.style)"""

    # Return the created container.
    return button
end

function release_focus!(widget::WidgetButton)
    request_update!(widget)
    return nothing
end

function request_focus!(widget::WidgetButton)
    request_update!(widget)
    return true
end

function process_keystroke!(widget::WidgetButton, k::Keystroke)
    if k.ktype == :enter
        @emit widget return_pressed
        return :keystroke_processed
    end

    return :keystroke_not_processed
end

function redraw!(widget::WidgetButton)
    @unpack buffer = widget
    NCurses.wclear(buffer)

    _draw_button!(widget, has_focus(widget))

    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper button

############################################################################################
#                                    Private Functions                                     #
############################################################################################

function _draw_button!(widget::WidgetButton, focused::Bool)
    @unpack buffer, width, label, style, theme = widget

    # Get the background color depending on the focus.
    c = focused ? theme.highlight : theme.default

    if style == :none
        @ncolor c buffer begin
            NCurses.mvwprintw(buffer, 0, 0, label)
        end
    else
        # Center the label in the button.
        w   = width
        Δ   = w - 4 - length(label)
        pad = div(Δ, 2)
        str = " "^pad * label * " "^(Δ - pad)

        if style == :boxed
            NCurses.mvwprintw(buffer, 0, 0, "┌" * "─"^(w - 2) * "┐")
            NCurses.mvwprintw(buffer, 1, 0, "│")

            @ncolor c buffer begin
                NCurses.wprintw(buffer, " " * str * " ")
            end

            NCurses.wprintw(buffer, "│")
            NCurses.mvwprintw(buffer, 2, 0, "└" * "─"^(w - 2) * "┘")
        else
            @ncolor c buffer begin
                NCurses.mvwprintw(buffer, 0, 0, "[ " * str * " ]")
            end
        end
    end

    return nothing
end
