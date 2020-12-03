# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Functions related to the abstract class `ComposedWidget` that can be used to
#   create widgets that are composed of a set of widgets.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# All the composed widgets must have the following fields in the class:
#
#   container::WidgetContainer

################################################################################
#                                     API
################################################################################

function destroy_widget(widget::ComposedWidget; refresh::Bool = true)
    @unpack buffer, container, parent = widget

    widget_desc = obj_desc(widget)

    # First, we need to delete all children widgets.
    while length(container.widgets) > 0
        w = pop!(container.widgets)
        destroy_widget(w, refresh = false)
    end

    delwin(buffer)
    buffer = Ptr{WINDOW}(0)

    # Remove the widget from the parent.
    remove_widget(parent, widget)

    @log info "destroy_widget" "Widget $widget_desc destroyed."

    # If required, perform a full refresh of the parent window.
    refresh && refresh_window(parent; force_redraw = true)

    return nothing
end

process_focus(widget::ComposedWidget, k::Keystroke) = process_focus(widget.container, k)
redraw(widget::ComposedWidget) = redraw(widget.container)
release_focus(widget::ComposedWidget) = release_focus(widget.container)
request_next_widget(widget::ComposedWidget) = request_next_widget(widget.container)
request_prev_widget(widget::ComposedWidget) = request_prev_widget(widget.container)
require_cursor(widget::ComposedWidget) = require_cursor(widget.container)
