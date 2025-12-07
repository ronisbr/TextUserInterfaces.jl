## Description #############################################################################
#
# Message box dialogs.
#
############################################################################################

export create_dialog, show_dialog

############################################################################################
#                                        Constants                                         #
############################################################################################

const _MESSAGE_BOX__INFO_ICON = """
╭─────────╮
│         │
│    i    │
│         │
╰─────────╯"""

const _MESSAGE_BOX__ICON_WARNING = """
╭─────────╮
│         │
│    !    │
│         │
╰─────────╯"""

const _MESSAGE_BOX__ICON_ERROR = """
╭─────────╮
│         │
│    x    │
│         │
╰─────────╯"""

############################################################################################
#                                        Dialog API                                        #
############################################################################################

@dialog mutable struct DialogMessageBox end

function create_dialog(
    ::Val{:message_box},
    layout::ObjectLayout;
    border_style::Symbol = :single,
    icon_type::Symbol = :info,
    message::AbstractString = "Dialog Message",
    show_icon::Bool = true,
    title::AbstractString = "Dialog Title",
)
    horizontal_hints = Dict(
        :center_anchor => Anchor(:parent, :center),
        :width         => 90
    )

    vertical_hints = Dict(
        :middle_anchor => Anchor(:parent, :middle),
        :height        => 10
    )

    # Select the icon and its color.
    # TODO: Make the color customizable.
    icon, icon_color = if icon_type == :warning
        _MESSAGE_BOX__ICON_WARNING, tui_style(:yellow)
    elseif icon_type == :error
        _MESSAGE_BOX__ICON_ERROR, tui_style(:red)
    else
        _MESSAGE_BOX__INFO_ICON, tui_style(:green)
    end

    # Create the dialog window.
    window = create_window(;
        border           = true,
        border_style     = border_style,
        horizontal_hints = horizontal_hints,
        layout           = layout,
        hidden           = true,
        title            = title,
        vertical_hints   = vertical_hints,
    )

    # We only want the container to have the same width of the parent window and start at 
    # the top-left corner. Its width will be adjusted later.
    content_container = @tui_container(
        parent        = window.widget_container,
        left_anchor   = (:parent, :left),
        right_anchor  = (:parent, :right),
        top_anchor    = (:parent, :top),
    )

    # == Content ===========================================================================

    icon_widget = nothing

    if show_icon
        icon_widget = @tui_text(
            parent      = content_container,
            text        = icon,
            theme       = Dict(:default => icon_color),
            left_anchor = (:parent, :left),
            top_anchor  = (:parent, :top),
        )
    end

    left_anchor = !isnothing(icon_widget) ? Anchor(icon_widget, :right) : Anchor(:parent, :left)

    @tui_text(
        parent        = content_container,
        auto_wrap     = true,
        text          = message,
        left_anchor   = left_anchor,
        top_anchor    = (:parent, :top, 1),
    )

    # Adjust the container size to fit its content. In this case, we only modifying its
    # height.
    tight_layout!(content_container)

    # == Buttons ===========================================================================

    hl = @tui_horizontal_line(
        parent       = window.widget_container,
        left_anchor  = (:parent, :left),
        right_anchor = (:parent, :right),
        top_anchor   = (content_container, :bottom),
    )

    button = @tui_button(
        parent       = window.widget_container,
        label        = "OK",
        right_anchor = (:parent, :right),
        top_anchor   = (hl, :bottom),
        width        = 10
    )

    dialog = DialogMessageBox(; window = window)

    @connect button return_pressed _message_box__ok_button_return_pressed (; dialog = dialog)

    return dialog
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _message_box__ok_button_return_pressed(button::WidgetButton; kwargs...) -> Nothing

Handle the `return_pressed` signal of the OK button in a message box dialog.
"""
function _message_box__ok_button_return_pressed(::WidgetButton; dialog::DialogMessageBox)
    close_dialog!(dialog)
    return nothing
end