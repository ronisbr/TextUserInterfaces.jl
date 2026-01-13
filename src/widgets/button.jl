## Description #############################################################################
#
# Widget: Button.
#
############################################################################################

export WidgetButton

############################################################################################
#                                        Structure                                         #
############################################################################################

"""
    struct WidgetButton

Store a button widget that can be clicked by pressing the return key when focused.

# Functions

This widget does not have public functions.

# Signals

- `return_pressed`: Emitted when the return key is pressed while the button has focus.
"""
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

# Conversion dictionary between style and width that must be added to the label length.
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
    theme::Theme = Theme()
)
    # Check arguments.
    if !haskey(_BUTTON_STYLE_HEIGHT, style)
        @log WARNING "create_widget" """
        The button style :$style is not known.
        The style :simple will be used."""
        style = :simple
    end

    layout_hints = Dict(
        :height => _BUTTON_STYLE_HEIGHT[style],
        :width  => textwidth(label) + _BUTTON_STYLE_WIDTH[style]
    )

    # Create the widget.
    button = WidgetButton(;
        id           = reserve_object_id(),
        layout       = layout,
        layout_hints = layout_hints,
        label        = label,
        style        = style,
        theme        = theme,
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

    _widget_button__draw!(widget, has_focus(widget))

    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper button

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _widget_button__draw!(widget::WidgetButton, focused::Bool) -> Nothing

Draw the button `widget`. If `focused` is `true`, the button will be highlighted
accordingly.
"""
function _widget_button__draw!(widget::WidgetButton, focused::Bool)
    @unpack buffer, width, label, style, theme = widget

    # Get the style depending on the focus.
    b = get_style(theme, :border)
    s = get_style(theme, focused ? :highlight : :default)

    if style == :none
        @nstyle s buffer begin
            NCurses.mvwprintw(buffer, 0, 0, label)
        end
    else
        # Center the label in the button.
        w   = width
        Δ   = w - 4 - length(label)
        pad = div(Δ, 2)
        str = " "^pad * label * " "^(Δ - pad)

        if style == :boxed
            @nstyle b buffer begin
                NCurses.mvwprintw(buffer, 0, 0, "┌" * "─"^(w - 2) * "┐")
                NCurses.mvwprintw(buffer, 1, 0, "│")
            end

            @nstyle s buffer begin
                NCurses.wprintw(buffer, " " * str * " ")
            end

            @nstyle b buffer begin
                NCurses.wprintw(buffer, "│")
                NCurses.mvwprintw(buffer, 2, 0, "└" * "─"^(w - 2) * "┘")
            end
        else
            @nstyle s buffer begin
                NCurses.mvwprintw(buffer, 0, 0, "[ " * str * " ]")
            end
        end
    end

    return nothing
end
