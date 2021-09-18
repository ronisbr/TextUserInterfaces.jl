# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file defines the implementation of the functions required by the Object
#   API for the containers.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

get_left_for_child(c::WidgetContainer) = c.border ?  1 : 0
get_top_for_child(c::WidgetContainer)  = c.border ?  1 : 0

get_width_for_child(c::WidgetContainer)  = c.width  + (c.border ? -2 : 0)
get_height_for_child(c::WidgetContainer) = c.height + (c.border ? -2 : 0)

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
