## Description #############################################################################
#
# This file contains the definitions related to widgets.
#
############################################################################################

export WidgetContainer

# We need to define the widget container here because `Window` depends on it.
"""
    struct WidgetContainer

Store a container widget that holds other widgets with optional border and focus management
support.

# Functions

    create_widget(Val(:container), layout::ObjectLayout; kwargs...)

Create a container widget.

## Keywords

- `border::Bool`: Whether to draw a border around the container.
    (**Default**: `false`)
- `border_style::Symbol`: Border style.
    (**Default**: `:default`)
- `theme::Theme`: Theme for the widget.
    (**Default**: `Theme()`)
- `title::String`: Title to display in the border.
    (**Default**: `""`)
- `title_alignment::Symbol`: Title alignment (`:l` for left, `:c` for center, `:r` for
    right).
    (**Default**: `:l`)

---

    add_widget!(container::WidgetContainer, widget::Widget) -> Nothing

Add the `widget` to the `container`.

    remove_widget!(container::WidgetContainer, widget::Widget) -> Nothing

Remove the `widget` from the `container`.

    content_dimension_limits(container::WidgetContainer) -> Tuple{Int, Int}

Return the content dimension limits (height, width) of the `container`.

    move_focus_to_next_widget!(container::WidgetContainer; cyclic::Bool = false) -> Bool

Move the focus in `container` to the next widget. This function returns `true` if it was
possible to acquire focus or `false` otherwise.

    move_focus_to_previous_widget!(container::WidgetContainer; cyclic::Bool = false) -> Bool

Move the focus in `container` to the previous widget. This function returns `true` if it was
possible to acquire focus or `false` otherwise.

    move_focus_to_widget!(container::WidgetContainer, widget::Widget) -> Nothing

Move the focus of the `container` to the `widget`.

    get_focused_widget(container::WidgetContainer) -> Union{Nothing, Widget}

Return the current widget in focus. If no widget is in focus, return `nothing`.

    tight_layout!(container::WidgetContainer) -> Nothing

Add layout hints to the `container` (width and height) so that it fits tightly its content.

# Signals

This widget does not have signals.
"""
@widget mutable struct WidgetContainer
    border::Bool = false
    border_style::Symbol = :default
    title::String = ""
    title_alignment::Symbol = :l
    widgets::Vector{Widget} = Widget[]

    # == Focus Management ==================================================================

    focused_widget_id::Int = 0
end
