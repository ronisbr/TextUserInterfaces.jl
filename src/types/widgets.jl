# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Types related to widgets.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export Widget, WidgetCommon, WidgetParent

# Types that can be parent of widgets.
WidgetParent = Union{Window,Widget}

# Common configurations for all widgets.
@with_kw mutable struct WidgetCommon
    parent::WidgetParent
    buffer::Ptr{WINDOW} = Ptr{WINDOW}(0)

    # Configuration related to the size and position of the widget.
    opc::ObjectPositioningConfiguration

    # Current size and position of the widget.
    top::Int    = -1
    left::Int   = -1
    height::Int = -1
    width::Int  = -1

    update_needed::Bool = true
end
