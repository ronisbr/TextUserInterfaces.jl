# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Widget: Button.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetContainer

################################################################################
#                                     Type
################################################################################

@with_kw mutable struct WidgetContainer <: Widget

    # API
    # ==========================================================================
    common::WidgetCommon

    # Parameters related to the widget
    # ==========================================================================
    widgets::Vector{Any} = Any[]
    focus_id::Int = 0
end

################################################################################
#                                     API
################################################################################

function accept_focus(container::WidgetContainer)
    # If there were a widget with focus, then do not change the focus when
    # accepting it again.
    if container.focus_id <= 0
        return _next_widget(container)
    else
        return true
    end
end

function create_widget(::Type{Val{:container}}, parent::WidgetParent;
                       top::Union{Integer,Symbol} = 0,
                       left::Union{Integer,Symbol} = 0,
                       height::Number = 0,
                       width::Number = 0,
                       hsize_policy::Symbol = :absolute,
                       vsize_policy::Symbol = :absolute)

    height <= 0 && (height = get_height(parent))
    width  <= 0 && (width  = get_width(parent))

    # Create the common parameters of the widget.
    common = create_widget_common(parent, top, left, height, width,
                                  vsize_policy, hsize_policy)

    # Create the widget.
    container = WidgetContainer(common = common)

    # Add the new widget to the parent widget list.
    add_widget(parent, container)

    @log info "create_widget" """
    A container was created in $(obj_desc(parent)).
        Size        = ($(common.height), $(common.width))
        Coordinate  = ($(common.top), $(common.left))
        Size policy = ($(common.vsize_policy), $(common.hsize_policy))
        Reference   = $(obj_to_ptr(container))"""

    # Return the created container.
    return container
end

function process_focus(container::WidgetContainer, k::Keystroke)
    @unpack common, widgets, focus_id = container
    @unpack parent = common

    # If there is any element in focus, ask to process the keystroke.
    if focus_id > 0
        # If `process_focus` returns `false`, it means that the widget wants to
        # release the focus.
        if process_focus(widgets[focus_id],k)
            sync_cursor(container)
            sync_cursor(parent)
            return true
        end
    end

    # Otherwise, we must search another widget that can accept the focus.
    return _next_widget(container)
end

function redraw(container::WidgetContainer)
    @unpack common, widgets = container
    @unpack buffer, parent = common

    wclear(buffer)

    # Check if any widget must be redrawn.
    update_needed = false

    for widget in widgets
        if widget.common.update_needed
            update_needed = true
            break
        end
    end

    # Redraw all the widgets in the container if necessary.
    if update_needed
        for widget in widgets
            redraw(widget)
        end
    end

    return nothing
end

function require_cursor(container::WidgetContainer)
    @unpack widgets, focus_id = container
    focus_id > 0 && return require_cursor(widgets[focus_id])
    return false
end

################################################################################
#                              Private functions
################################################################################

"""
    function _next_widget(container::WidgetContainer)

Move the focus of container `container` to the next widget.

"""
function _next_widget(container::WidgetContainer)
    @unpack common, widgets, focus_id = container
    @unpack parent = common

    @log verbose "_next_widget" "$(obj_desc(container)): Change the focused widget."

    # Release the focus from previous widget.
    focus_id > 0 && release_focus(widgets[focus_id])

    # Search for the next widget that can handle the focus.
    for i = focus_id+1:length(widgets)
        if accept_focus(widgets[i])
            container.focus_id = i
            sync_cursor(container)
            sync_cursor(parent)

            @log verbose "_next_widget" "$(obj_desc(container)): Focus was handled to widget #$i -> $(obj_desc(widgets[i]))."

            return true
        end
    end

    # No more element could accept the focus.
    container.focus_id = 0
    sync_cursor(container)
    sync_cursor(parent)

    @log verbose "_next_widget" "$(obj_desc(container)): There are no more widgets to receive the focus."

    return false
end
