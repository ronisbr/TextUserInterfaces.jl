# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Widget container.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export add_widget!, remove_widget!

################################################################################
#                                  Constants
################################################################################

# Hints for the widget container layout.
const _WIDGET_CONTAINER_HORIZONTAL_LAYOUT_HINTS = (
    anchor_left  = Anchor(:parent, :left,   0),
    anchor_right = Anchor(:parent, :right,  0),
)

const _WIDGET_CONTAINER_VERTICAL_LAYOUT_HINTS = (
    anchor_bottom = Anchor(:parent, :bottom, 0),
    anchor_top    = Anchor(:parent, :top,    0),
)

################################################################################
#                                  Object API
################################################################################

get_inner_height(c::WidgetContainer) = c.height + (c.border ? -2 : 0)
get_inner_left(c::WidgetContainer)   = c.border ?  1 : 0
get_inner_top(c::WidgetContainer)    = c.border ?  1 : 0
get_inner_width(c::WidgetContainer)  = c.width  + (c.border ? -2 : 0)

function update_layout!(container::WidgetContainer; force::Bool = false)
    # Update the layout of the container as if it is a generic widget.
    if invoke(update_layout!, Tuple{Widget}, container; force = force)
        for widget in container.widgets
            # In this case, we must force all the children to update their
            # layout because the container buffer has been recreated.
            update_layout!(widget; force = true)
        end

        return true
    else
        return false
    end
end

################################################################################
#                                  Widget API
################################################################################

function create_widget(
    ::Val{:container},
    layout::ObjectLayout;
    border::Bool = false,
    theme::Theme = tui.default_theme,
    title::AbstractString = "",
    title_alignment::Symbol = :l,
)
    # Create the widget.
    container = WidgetContainer(
        layout           = layout,
        border           = border,
        horizontal_hints = _WIDGET_CONTAINER_HORIZONTAL_LAYOUT_HINTS,
        id               = reserve_object_id(),
        theme            = theme,
        title            = title,
        title_alignment  = title_alignment,
        vertical_hints   = _WIDGET_CONTAINER_VERTICAL_LAYOUT_HINTS,
    )

    @log INFO "create_widget" """
    Container created:
      ID               = $(container.id)
      border           = $(container.border),
      horizontal_hints = $(container.horizontal_hints)
      title            = $(container.title),
      title_alignment  = $(container.title_alignment),
      vertical_hints   = $(container.vertical_hints)"""

    # Return the created container.
    return container
end

function process_keystroke(container::WidgetContainer, k::Keystroke)
    return :keystroke_processed
end

function redraw!(container::WidgetContainer)
    @unpack border, buffer, update_needed, widgets, theme = container

    wclear(buffer)

    if border
        @ncolor theme.border buffer begin
            wborder(buffer)
        end

        @ncolor theme.title buffer begin
            _draw_title!(container)
        end
    end

    # Check if any widget must be redrawn.
    for widget in widgets
        if widget.update_needed
            update_needed = true
            break
        end
    end

    # Redraw all the widgets in the container if necessary.
    if update_needed
        for widget in widgets
            redraw!(widget)
        end
    end

    return nothing
end

################################################################################
#                               Public functions
################################################################################

"""
    add_widget!(container::WidgetContainer, widget::Widget)

Add the `widget` to the `container`.
"""
function add_widget!(container::WidgetContainer, widget::Widget)
    # If the widget already has a container, remove it before adding to this
    # container.
    !isnothing(widget.container) && remove_widget!(widget.container, widget)

    # Add the widget to the container.
    widget.container = container
    widget.window = container.window
    create_widget_buffer!(widget)
    push!(container.widgets, widget)

    # Since adding a widget into a container can change its size, we need to
    # update the layout.
    update_layout!(widget; force = true)

    request_update!(container)

    @log INFO "add_widget!" """
    Add widget $(obj_desc(widget)) => $(obj_desc(container)):
        Top    = $(widget.top)
        Left   = $(widget.left)
        Height = $(widget.height)
        Width  = $(widget.width)"""

    return nothing
end

"""
    remove_widget!(container::WidgetContainer, widget::Widget)

Remove the `widget` from the `container`.
"""
function remove_widget!(container::WidgetContainer, widget::Widget)
    idx = findfirst(x -> x === widget, container.widgets)

    if isnothing(idx)
        # TODO: Write to the log.
        return nothing
    end

    # Delete the widget from the list.
    deleteat!(container.widgets, idx)

    widget.container = nothing
    widget.window = nothing
    destroy_widget_buffer!(widget)

    request_update!(container)

    return nothing
end

################################################################################
#                              Private functions
################################################################################

"""
    _draw_title!(container::WidgetContainer)

Draw the title in the container `container`.
"""
function _draw_title!(container::WidgetContainer)
    @unpack buffer, title, title_alignment = container

    # Get the width of the container.
    width = get_width(container)

    # If the width is too small, then do nothing.
    if width ≤ 4
        return nothing
    end

    # Check if the entire title cannot be written. In this case, the title will
    # be shrunk.
    if length(title) ≥ width - 4
        title = title[1:width - 4]
    end

    # Compute the padding to print the title based on the alignment.
    if title_alignment == :r
        pad = width - 2 - length(title)
    elseif title_alignment == :c
        pad = div(width - length(title), 2)
    else
        pad = 2
    end

    mvwprintw(buffer, 0, pad, title)

    return nothing
end

################################################################################
#                                   Helpers
################################################################################

@create_widget_helper container
