## Description #############################################################################
#
# Message box dialogs.
#
############################################################################################

export create_dialog, show_dialog

@dialog mutable struct DialogMessageBox end

function create_dialog(
    ::Val{:message_box},
    layout::ObjectLayout;
    title::AbstractString = "Dialog Title",
    message::AbstractString = "Dialog Message",
)
    horizontal_hints = Dict(
        :center_anchor => Anchor(:parent, :center),
        :width => 50
    )

    vertical_hints = Dict(
        :middle_anchor => Anchor(:parent, :middle),
        :height => 7
    )

    window = create_window(;
        border           = true,
        horizontal_hints = horizontal_hints,
        layout           = layout,
        hidden           = true,
        title            = title,
        vertical_hints   = vertical_hints,
    )

    label = @tui_label(
        parent = window.widget_container,
        top_anchor = (:parent, :top),
        left_anchor = (:parent, :left),
        label = message,
    )

    resize_buffer_to_fit_contents!(window)

    dialog = DialogMessageBox(; window = window)

    return dialog
end