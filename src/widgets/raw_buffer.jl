## Description #############################################################################
#
# Widget: Raw buffer.
#
############################################################################################

export WidgetRawBuffer

############################################################################################
#                                        Structure                                         #
############################################################################################

"""
    struct WidgetRawBuffer

Store a raw buffer widget that allows custom drawing using a user-defined function.

# Functions

This widget does not have public functions.

# Signals

This widget does not have signals.
"""
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
    draw!::Function = _raw_buffer__default_draw!,
    theme::Theme = Theme()
)
    # Create the widget.
    raw_buffer = WidgetRawBuffer(;
        id     = reserve_object_id(),
        draw!  = draw!,
        layout = layout,
        theme  = theme
    )

    @log DEBUG "create_widget" """
    WidgetRawBuffer created:
      ID            = $(raw_buffer.id)
      Draw function = $(raw_buffer.draw!)"""

    # Return the created container.
    return raw_buffer
end

function redraw!(widget::WidgetRawBuffer)
    @unpack buffer = widget
    NCurses.wclear(buffer)
    widget.draw!(widget, buffer)
    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

_raw_buffer__default_draw!(rb::WidgetRawBuffer, buffer::Ptr{WINDOW}) = nothing

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper raw_buffer