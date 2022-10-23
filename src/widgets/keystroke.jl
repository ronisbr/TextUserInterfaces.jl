# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Widget to display the current keystroke.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

################################################################################
#                                  Structure
################################################################################

@widget mutable struct WidgetKeystroke
    k::Keystroke = Keystroke(value = "None", ktype = :none)
end

################################################################################
#                                  Widget API
################################################################################

can_accept_focus(::WidgetKeystroke) = true

function create_widget(
    ::Val{:keystroke},
    layout::ObjectLayout;
)
    # Create the widget.
    keystroke = WidgetKeystroke(
        id               = reserve_object_id(),
        layout           = layout,
        horizontal_hints = (; width = 20),
        vertical_hints   = (; height = 1)
    )

    @log INFO "create_widget" "WidgetKeystroke created"

    # Return the created container.
    return keystroke
end

function release_focus!(widget::WidgetKeystroke)
    request_update!(widget)
    return nothing
end

function request_focus!(widget::WidgetKeystroke)
    request_update!(widget)
    return true
end

function process_keystroke!(widget::WidgetKeystroke, k::Keystroke)
    widget.k = k
    request_update!(widget)
    return :keystroke_processed
end

function redraw!(widget::WidgetKeystroke)
    @unpack buffer = widget
    wclear(buffer)

    if has_focus(widget)
        mvwprintw(buffer, 0, 0, "FOCUS: " * widget.k.value)
    else
        mvwprintw(buffer, 0, 0, widget.k.value)
    end

    return nothing
end

################################################################################
#                                   Helpers
################################################################################

@create_widget_helper keystroke
