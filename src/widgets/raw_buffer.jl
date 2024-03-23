## Description #############################################################################
#
# Widget: Raw buffer.
#
############################################################################################

export WidgetRawBuffer

############################################################################################
#                                        Structure                                         #
############################################################################################

@widget mutable struct WidgetRawBuffer
    draw!::Function
end

############################################################################################
#                                        Object API                                        #
############################################################################################

############################################################################################
#                                        Widget API                                        #
############################################################################################

can_accept_focus(::WidgetRawBuffer) = false

function create_widget(
    ::Val{:raw_buffer},
    layout::ObjectLayout;
    draw!::Function,
    theme::Theme = tui.default_theme
)
    # Create the widget.
    raw_buffer = WidgetRawBuffer(
        ;
        id     = reserve_object_id(),
        draw!  = draw!,
        layout = layout,
        theme  = theme
    )

    @log DEBUG "create_widget" """
    WidgetRawBuffer created:
      ID = $(raw_buffer.id)"""

    # Return the created container.
    return raw_buffer
end

function redraw!(widget::WidgetRawBuffer)
    @unpack buffer = widget
    wclear(buffer)
    widget.draw!(widget, buffer)
    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper raw_buffer
