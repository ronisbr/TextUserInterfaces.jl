# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Abstract types.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Abstract type of objects.
abstract type Object end

# Abstract type for all widgets.
abstract type Widget <: Object end

# Abstract type for all composed widgets.
abstract type ComposedWidget <: Widget end

# Abstract type for all derived widgets.
abstract type DerivedWidget <: Widget end
