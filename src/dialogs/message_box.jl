## Description #############################################################################
#
# Message box dialogs.
#
############################################################################################

export create_dialog, show_dialog

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
        :height        => 7
    )

    icon = if icon_type == :warning
        _MESSAGE_BOX__ICON_WARNING
    elseif icon_type == :error
        _MESSAGE_BOX__ICON_ERROR
    else
        _MESSAGE_BOX__INFO_ICON
    end

    window = create_window(;
        border           = true,
        border_style     = border_style,
        horizontal_hints = horizontal_hints,
        layout           = layout,
        hidden           = true,
        title            = title,
        vertical_hints   = vertical_hints,
    )

    aux = :parent

    if show_icon
        aux = @tui_text(
            parent      = window.widget_container,
            text        = _MESSAGE_BOX__INFO_ICON,
            theme       = Dict(:default => tui_style(:green)),
            left_anchor = (:parent, :left),
            top_anchor  = (:parent, :top),
        )
    end

    left_anchor = show_icon ? Anchor(aux, :right) : Anchor(:parent, :left)

    @tui_text(
        parent        = window.widget_container,
        auto_wrap     = true,
        text          = message,
        bottom_anchor = (:parent, :bottom),
        left_anchor   = left_anchor,
        right_anchor  = (:parent, :right),
        top_anchor    = (:parent, :top, 1),
    )

    dialog = DialogMessageBox(; window = window)

    return dialog
end