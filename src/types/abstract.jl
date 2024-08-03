## Description #############################################################################
#
# Abstract types.
#
############################################################################################

export Widget

# Abstract type of objects.
abstract type Object end

# Abstract type for all widgets.
abstract type Widget <: Object end

# Abstract type for all composed widgets.
abstract type ComposedWidget end
