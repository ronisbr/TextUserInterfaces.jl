## Description #############################################################################
#
# Abstract types.
#
############################################################################################

export Widget

"""
    abstract type Object

Abstract type for all objects.
"""
abstract type Object end

"""
    abstract type Widget <: Object

Abstract type for all widgets.
"""
abstract type Widget <: Object end

"""
    abstract type ComposedWidget <: Widget

Abstract type for all composed widgets.
"""
abstract type ComposedWidget end
