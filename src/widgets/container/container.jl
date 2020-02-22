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

@with_kw mutable struct WidgetContainer{T<:WidgetParent} <: Widget

    # API
    # ==========================================================================
    common::WidgetCommon{T}

    # Parameters related to the widget
    # ==========================================================================
    border::Bool = false
    border_color::Int = 0
    focus_id::Int = 0
    title::String = ""
    title_alignment::Symbol = :l
    title_color::Int = 0
    widgets::Vector{Any} = Any[]
end

################################################################################
#                                     API
################################################################################

function create_widget(::Val{:container}, parent::T;
                       opc = nothing, border::Bool = false,
                       border_color::Int = -1, composed::Bool = false,
                       title::AbstractString = "", title_alignment::Symbol = :l,
                       title_color::Int = -1, kwargs...) where
    T<:WidgetParent

    if opc == nothing
        opc = object_positioning_conf(; kwargs...)

        # Check if all positioning is defined and, if not, try to help by
        # automatically defining some anchors.
        if opc.vertical == :unknown
            opc = ObjectPositioningConfiguration(
                    anchor_bottom = Anchor(parent, :bottom, 0),
                    anchor_left   = opc.anchor_left,
                    anchor_right  = opc.anchor_right,
                    anchor_top    = Anchor(parent, :top,    0),
                    anchor_center = opc.anchor_center,
                    anchor_middle = opc.anchor_middle,
                    top           = opc.top,
                    left          = opc.left,
                    height        = opc.height,
                    width         = opc.width
                   )
        end

        if opc.horizontal == :unknown
            opc = ObjectPositioningConfiguration(
                    anchor_bottom = opc.anchor_bottom,
                    anchor_left   = Anchor(parent, :left,  0),
                    anchor_right  = Anchor(parent, :right, 0),
                    anchor_top    = opc.anchor_top,
                    anchor_center = opc.anchor_center,
                    anchor_middle = opc.anchor_middle,
                    top           = opc.top,
                    left          = opc.left,
                    height        = opc.height,
                    width         = opc.width
                   )
        end
    end

    # Create the common parameters of the widget.
    common = create_widget_common(parent, opc)

    # Create the widget.
    container = WidgetContainer{T}(common          = common,
                                   border          = border,
                                   border_color    = border_color,
                                   title           = title,
                                   title_alignment = title_alignment,
                                   title_color     = title_color)

    # Add the new widget to the parent widget list.
    !composed && add_widget(parent, container)

    !composed && @log info "create_widget" """
    A container was created in $(obj_desc(parent)).
        Size        = ($(common.height), $(common.width))
        Coordinate  = ($(common.top), $(common.left))
        Positioning = ($(common.opc.vertical),$(common.opc.horizontal))
        Reference   = $(obj_to_ptr(container))"""

    # Return the created container.
    return container
end

function destroy_widget(container::WidgetContainer; refresh::Bool = true)
    # First, we need to delete all children widgets.
    while length(container.widgets) > 0
        w = pop!(container.widgets)
        destroy_widget(w, refresh = false)
    end

    _destroy_widget(container, refresh = refresh)
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
            return true
        end
    end

    # Otherwise, we must search another widget that can accept the focus.
    # In this case, if the keystorke was SHIFT-TAB, we will move the focus to
    # the previous widget.
    if k.ktype == :tab && k.shift == true
         return _previous_widget(container)
    else
        return _next_widget(container)
    end
end

function redraw(container::WidgetContainer)
    @unpack border, border_color, common, widgets, title_color = container
    @unpack buffer, parent = common

    wclear(buffer)

    if border
        border_color > 0 && wattron(buffer, border_color)
        wborder(buffer)
        border_color > 0 && wattroff(buffer, border_color)

        title_color  > 0 && wattron(buffer, title_color)
        _draw_title(container)
        title_color  > 0 && wattroff(buffer, title_color)
    end

    if common.update_needed
        update_needed = true
    else
        # Check if any widget must be redrawn.
        update_needed = false

        for widget in widgets
            if widget.common.update_needed
                update_needed = true
                break
            end
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

"""
    request_next_widget(container::WidgetContainer)

Request the next widget in `container`. It returns `true` if a widget has get
the focus or `false` otherwise.

"""
request_next_widget(container::WidgetContainer) = _next_widget(container)

"""
    request_prev_widget(container::WidgetContainer)

Request the previous widget in `container`. It returns `true` if a widget has
get the focus or `false` otherwise.

"""
request_prev_widget(container::WidgetContainer) = _previous_widget(container)

function require_cursor(container::WidgetContainer)
    @unpack widgets, focus_id = container
    focus_id > 0 && return require_cursor(widgets[focus_id])
    return false
end

function release_focus(container::WidgetContainer)
    container.focus_id = 0
    return true
end

function reposition!(container::WidgetContainer; force::Bool = false)
    # Reposition the container as if it is a widget.
    if invoke(reposition!, Tuple{Widget}, container; force = force)
        # Then, reposition all the widgets.
        for widget in container.widgets
            # In this case, we must **force** a resize because the buffer on the
            # container has been recreated.
            reposition!(widget, force = true)
        end

        return true
    else
        return false
    end
end

################################################################################
#                              Private functions
################################################################################

"""
    _draw_title(container::WidgetContainer)

Draw the title in the container `container`.

"""
function _draw_title(container::WidgetContainer)
    @unpack common, title, title_alignment = container
    @unpack buffer = common

    # Get the width of the container.
    width = get_width(container)

    # If the width is too small, then do nothing.
    width ≤ 4 && return nothing

    # Check if the entire title cannot be written. In this case, the title will
    # be shrinked.
    length(title) ≥ width - 4 && (title = title[1:width-4])

    # Compute the padding to print the title based on the alignemnt.
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

"""
    _next_widget(container::WidgetContainer)

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
        if request_next_widget(widgets[i])
            container.focus_id = i
            sync_cursor(container)

            @log verbose "_next_widget" "$(obj_desc(container)): Focus was handled to widget #$i -> $(obj_desc(widgets[i]))."

            return true
        end
    end

    # No more element could accept the focus.
    container.focus_id = 0
    sync_cursor(container)

    @log verbose "_next_widget" "$(obj_desc(container)): There are no more widgets to receive the focus."

    return false
end

"""
    _previous_widget(container::WidgetContainer)

Move the focus of container `container` to the previous widget.

"""
function _previous_widget(container::WidgetContainer)
    @unpack common, widgets, focus_id = container
    @unpack parent = common

    @log verbose "_previous_widget" "$(obj_desc(container)): Change the focused widget."

    # Release the focus from previous widget.
    if focus_id > 0
        release_focus(widgets[focus_id])
    else
        focus_id = length(widgets)+1
    end

    # Search for the next widget that can handle the focus.
    for i = focus_id-1:-1:1
        if request_prev_widget(widgets[i])
            container.focus_id = i
            sync_cursor(container)

            @log verbose "_previous_widget" "$(obj_desc(container)): Focus was handled to widget #$i -> $(obj_desc(widgets[i]))."

            return true
        end
    end

    # No more element could accept the focus.
    container.focus_id = 0
    sync_cursor(container)

    @log verbose "_previous_widget" "$(obj_desc(container)): There are no more widgets to receive the focus."

    return false
end
