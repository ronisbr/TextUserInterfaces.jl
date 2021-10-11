# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Private functions related to the widget containers.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

"""
    _draw_title(container::WidgetContainer)

Draw the title in the container `container`.
"""
function _draw_title(container::WidgetContainer)
    @unpack buffer, title, title_alignment = container

    # Get the width of the container.
    width = get_width(container)

    # If the width is too small, then do nothing.
    if width ≤ 4
        return nothing
    end

    # Check if the entire title cannot be written. In this case, the title will
    # be shrinked.
    if length(title) ≥ width - 4
        title = title[1:width-4]
    end

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
    @unpack parent, widgets, focus_id = container

    @log verbose "_next_widget" "$(obj_desc(container)): Change the focused widget."

    # Release the focus from previous widget.
    if focus_id > 0
        if release_focus(widgets[focus_id])
            @emit_signal widgets[focus_id] focus_lost
        else
            return true
        end
    end

    # We need to mark that currently this container does not have any object
    # in focus because it could be necessary to update the entire TUI when
    # requesting the next widget. In this case, the old focused widget will be
    # updated. If this widget needs to check if it has focus, then the function
    # would wrongly return true.
    container.focus_id = 0

    # Search for the next widget that can handle the focus.
    for i = (focus_id + 1):length(widgets)
        if request_next_widget(widgets[i])
            container.focus_id = i

            # We need to update the TUI, now that the new widget has the focus,
            # and then synchronize the cursors.
            tui_update()
            sync_cursor(container)

            @emit_signal widgets[i] focus_acquired

            @log verbose "_next_widget" "$(obj_desc(container)): Focus was handled to widget #$i -> $(obj_desc(widgets[i]))."

            return true
        end
    end

    # No more element could accept the focus.
    container.focus_id = 0

    # We need to update the TUI, now that the new widget has the focus, and then
    # synchronize the cursors.
    tui_update()
    sync_cursor(container)

    @log verbose "_next_widget" "$(obj_desc(container)): There are no more widgets to receive the focus."

    return false
end

"""
    _previous_widget(container::WidgetContainer)

Move the focus of container `container` to the previous widget.
"""
function _previous_widget(container::WidgetContainer)
    @unpack parent, widgets, focus_id = container

    @log verbose "_previous_widget" "$(obj_desc(container)): Change the focused widget."

    # Release the focus from previous widget.
    if focus_id > 0
        if release_focus(widgets[focus_id])
            @emit_signal widgets[focus_id] focus_lost
        else
            return true
        end
    else
        focus_id = length(widgets) + 1
    end

    # We need to mark that currently this container does not have any object
    # in focus because it could be necessary to update the entire TUI when
    # requesting the next widget. In this case, the old focused widget will be
    # updated. If this widget needs to check if it has focus, then the function
    # would wrongly return true.
    container.focus_id = 0

    # Search for the next widget that can handle the focus.
    for i in (focus_id - 1):-1:1
        if request_prev_widget(widgets[i])
            container.focus_id = i

            # We need to update the TUI, now that the new widget has the focus,
            # and then synchronize the cursors.
            tui_update()
            sync_cursor(container)

            @log verbose "_previous_widget" "$(obj_desc(container)): Focus was handled to widget #$i -> $(obj_desc(widgets[i]))."

            return true
        end
    end

    # No more element could accept the focus.
    container.focus_id = 0

    # We need to update the TUI, now that the new widget has the focus, and then
    # synchronize the cursors.
    tui_update()
    sync_cursor(container)

    @log verbose "_previous_widget" "$(obj_desc(container)): There are no more widgets to receive the focus."

    return false
end
