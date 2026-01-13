## Description #############################################################################
#
# Align widgets in a column layout.
#
############################################################################################

############################################################################################
#                                        Constants                                         #
############################################################################################

# Default anchors for the column layout.
_COLUMN_LAYOUT__DEFAULT_TOP_ANCHOR    = Anchor(:parent, :top)
_COLUMN_LAYOUT__DEFAULT_BOTTOM_ANCHOR = Anchor(:parent, :bottom)
_COLUMN_LAYOUT__DEFAULT_LEFT_ANCHOR   = Anchor(:parent, :left)
_COLUMN_LAYOUT__DEFAULT_RIGHT_ANCHOR  = Anchor(:parent, :right)

############################################################################################
#                                        Structure                                         #
############################################################################################

"""
    struct ColumnLayout <: ComposedWidget

Arrange widgets vertically in a column layout, automatically managing the anchors between
widgets.

# Functions

    create_widget(Val(:column_layout), layout::ObjectLayout; kwargs...)

Create a column layout widget.

## Keywords

- `expander::Union{Int, Nothing}`: Index of the widget that will expand to fill the
    remaining space. If `nothing`, the last widget will expand.
    (**Default**: `nothing`)
- `theme::Theme`: Theme for the widget.
    (**Default**: `Theme()`)
- `widgets::AbstractVector`: Vector of widgets to arrange in the column layout.
    (**Required**)

---

    get_container(cw::ColumnLayout) -> WidgetContainer

Return the container of the column layout `cw`.

# Signals

This widget does not have signals.
"""
struct ColumnLayout <: ComposedWidget
    container::WidgetContainer
    widgets::Vector{Widget}

    # == Configurations ====================================================================
    expander::Int
end

############################################################################################
#                                        Widget API                                        #
############################################################################################

function create_widget(
    ::Val{:column_layout},
    layout::ObjectLayout;
    expander::Union{Int, Nothing} = nothing,
    theme::Theme = Theme(),
    widgets::AbstractVector
)
    if isnothing(expander)
        expander = length(widgets)
    end

    container     = create_widget(Val(:container), layout; theme = theme)
    column_layout = ColumnLayout(container, widgets, expander)

    return column_layout
end

############################################################################################
#                                      Container API                                       #
############################################################################################

# We need a custom function when adding the column layout to a container because we first
# need the main container added to a parent before creating the other components.
function add_widget!(parent::WidgetContainer, column_layout::ColumnLayout)
    @unpack container, expander, widgets = column_layout

    add_widget!(parent, container)

    last_widget = nothing

    for (i, widget) in enumerate(widgets)
        top_anchor = isnothing(last_widget) ?
            _COLUMN_LAYOUT__DEFAULT_TOP_ANCHOR :
            Anchor(last_widget, :bottom)

        layout = ObjectLayout(;
            left_anchor  = _COLUMN_LAYOUT__DEFAULT_LEFT_ANCHOR,
            right_anchor = _COLUMN_LAYOUT__DEFAULT_RIGHT_ANCHOR,
            top_anchor   = top_anchor,
        )

        widget.layout = layout
        add_widget!(container, widget)

        last_widget = widget

        i >= expander && break
    end

    last_widget = nothing

    for (i, widget) in Iterators.reverse(enumerate(widgets))
        i <= expander && break

        bottom_anchor = isnothing(last_widget) ?
            _COLUMN_LAYOUT__DEFAULT_BOTTOM_ANCHOR :
            Anchor(last_widget, :top)

        layout = ObjectLayout(;
            left_anchor   = _COLUMN_LAYOUT__DEFAULT_LEFT_ANCHOR,
            right_anchor  = _COLUMN_LAYOUT__DEFAULT_RIGHT_ANCHOR,
            bottom_anchor = bottom_anchor,
        )

        widget.layout = layout
        add_widget!(container, widget)

        last_widget = widget
    end

    return nothing
end

function remove_widget!(parent::WidgetContainer, column_layout::ColumnLayout)
    @unpack container = column_layout
    remove_widget!(parent, container)
    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper column_layout