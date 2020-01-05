# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Abstract types.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Abstract type for all widgets.
abstract type Widget end

# Abstract type for all composed widgets.
abstract type ComposedWidget <: Widget end
