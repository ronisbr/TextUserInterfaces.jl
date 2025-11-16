## Description #############################################################################
#
# This file contains the definitions related to widgets.
#
############################################################################################

export WidgetContainer

# We need to define the widget container here because `Window` depends on it.
@widget mutable struct WidgetContainer
    border::Bool = false
    border_style::Symbol = :default
    title::String = ""
    title_alignment::Symbol = :l
    widgets::Vector{Widget} = Widget[]

    # == Focus Management ==================================================================

    focused_widget_id::Int = 0
end
