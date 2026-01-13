## Description #############################################################################
#
# Align widgets in a row layout.
#
############################################################################################

############################################################################################
#                                        Constants                                         #
############################################################################################

# Default anchors for the row layout.
_ROW_LAYOUT__DEFAULT_TOP_ANCHOR    = Anchor(:parent, :top)
_ROW_LAYOUT__DEFAULT_BOTTOM_ANCHOR = Anchor(:parent, :bottom)
_ROW_LAYOUT__DEFAULT_LEFT_ANCHOR   = Anchor(:parent, :left)
_ROW_LAYOUT__DEFAULT_RIGHT_ANCHOR  = Anchor(:parent, :right)

############################################################################################
#                                        Structure                                         #
############################################################################################

"""
    struct RowLayout <: ComposedWidget

Arrange widgets horizontally in a row layout, automatically managing the anchors between
widgets.

# Functions

    get_container(cw::RowLayout) -> WidgetContainer

Return the container of the row layout `cw`.

# Signals

This widget does not have signals.
"""
struct RowLayout <: ComposedWidget
    container::WidgetContainer
    widgets::Vector{Widget}

    # == Configurations ====================================================================
    expander::Int
end

############################################################################################
#                                        Widget API                                        #
############################################################################################

function create_widget(
    ::Val{:row_layout},
    layout::ObjectLayout;
    expander::Union{Int, Nothing} = nothing,
    theme::Theme = Theme(),
    widgets::AbstractVector
)
    if isnothing(expander)
        expander = length(widgets)
    end

    container  = create_widget(Val(:container), layout; theme = theme)
    row_layout = RowLayout(container, widgets, expander)

    return row_layout
end

############################################################################################
#                                      Container API                                       #
############################################################################################

# We need a custom function when adding the row layout to a container because we first need
# the main container added to a parent before creating the other components.
function add_widget!(parent::WidgetContainer, row_layout::RowLayout)
    @unpack container, expander, widgets = row_layout

    add_widget!(parent, container)

    last_widget = nothing

    for (i, widget) in enumerate(widgets)
        left_anchor = isnothing(last_widget) ?
            _ROW_LAYOUT__DEFAULT_LEFT_ANCHOR :
            Anchor(last_widget, :right)

        layout = ObjectLayout(;
            bottom_anchor = _ROW_LAYOUT__DEFAULT_BOTTOM_ANCHOR,
            left_anchor   = left_anchor,
            top_anchor    = _ROW_LAYOUT__DEFAULT_TOP_ANCHOR,
        )

        widget.layout = layout
        add_widget!(container, widget)

        last_widget = widget

        i >= expander && break
    end

    last_widget = nothing

    for (i, widget) in Iterators.reverse(enumerate(widgets))
        i <= expander && break

        right_anchor = isnothing(last_widget) ?
            _ROW_LAYOUT__DEFAULT_RIGHT_ANCHOR :
            Anchor(last_widget, :left)

        layout = ObjectLayout(;
            bottom_anchor = _ROW_LAYOUT__DEFAULT_BOTTOM_ANCHOR,
            right_anchor  = right_anchor,
            top_anchor    = _ROW_LAYOUT__DEFAULT_TOP_ANCHOR,
        )

        widget.layout = layout
        add_widget!(container, widget)

        last_widget = widget
    end

    return nothing
end

function remove_widget!(parent::WidgetContainer, row_layout::RowLayout)
    @unpack container = row_layout
    remove_widget!(parent, container)
    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper row_layout
