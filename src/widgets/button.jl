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

    create_widget(Val(:button), layout::ObjectLayout; kwargs...)

Create a button widget.

## Keywords

- `label::AbstractString`: Button label.
    (**Default**: `"Button"`)
- `style::Symbol`: Button style. Possible values are: `:boxed`, `:boxed_double`,
    `:boxed_heavy`, `:boxed_rounded`, `:simple`, and `:none`.
    (**Default**: `:simple`)
- `theme::Theme`: Theme for the widget.
    (**Default**: `Theme()`)

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
    :boxed         => 3,
    :boxed_double  => 3,
    :boxed_heavy   => 3,
    :boxed_rounded => 3,
    :simple        => 1,
    :none          => 1
)

# Conversion dictionary between style and width that must be added to the label length.
const _BUTTON_STYLE_WIDTH = Dict(
    :boxed         => 4,
    :boxed_double  => 4,
    :boxed_heavy   => 4,
    :boxed_rounded => 4,
    :simple        => 4,
    :none          => 0
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

    if style == :none
        s = get_style(theme, focused ? :highlight : :default)

        @nstyle s buffer begin
            NCurses.mvwprintw(buffer, 0, 0, label)
        end

        return nothing
    end

    # Center the label in the button.
    w   = width
    Δ   = w - length(label)
    pad = div(Δ, 2)
    str = " "^pad * label * " "^(Δ - pad)

    Δy = style == :simple ? 0 : 1

    @nstyle s buffer begin
        NCurses.mvwprintw(buffer, Δy, 0, str)
    end

    if style == :simple
        b = get_style(theme, :border)

        @nstyle b buffer begin
            NCurses.mvwprintw(buffer, 0, 0,     "[ ")
            NCurses.mvwprintw(buffer, 0, w - 2, " ]")
        end
        return nothing
    end

    border_style = if style == :boxed_double
        :double
    elseif style == :boxed_heavy
        :heavy
    elseif style == :boxed_rounded
        :rounded
    else
        :default
    end

    draw_border!(buffer; style = border_style, theme = theme)

    return nothing
end
