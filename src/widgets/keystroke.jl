## Description #############################################################################
#
# Widget to display the current keystroke.
#
############################################################################################

############################################################################################
#                                        Structure                                         #
############################################################################################

"""
    struct WidgetKeystroke

Store a widget that displays the current keystroke pressed by the user.

# Functions

    create_widget(Val(:keystroke), layout::ObjectLayout; kwargs...)

Create a keystroke widget.

## Keywords

This widget does not have keywords.

# Signals

This widget does not have signals.
"""
@widget mutable struct WidgetKeystroke
    k::Keystroke = Keystroke(value = "None", ktype = :none)
end

############################################################################################
#                                        Widget API                                        #
############################################################################################

can_accept_focus(::WidgetKeystroke) = true

function create_widget(
    ::Val{:keystroke},
    layout::ObjectLayout;
)
    # Create the widget.
    keystroke = WidgetKeystroke(;
        id           = reserve_object_id(),
        layout       = layout,
        layout_hints = Dict(:height => 1, :width  => 20),
    )

    @log DEBUG "create_widget" "WidgetKeystroke created"

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
    NCurses.wclear(buffer)

    if has_focus(widget)
        NCurses.mvwprintw(buffer, 0, 0, "FOCUS: " * widget.k.value)
    else
        NCurses.mvwprintw(buffer, 0, 0, widget.k.value)
    end

    return nothing
end

request_cursor(widget::WidgetKeystroke) = true

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper keystroke
