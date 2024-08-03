## Description #############################################################################
#
# This file defines the API for composed widgets. Those are objects that contains several
# widgets to perform a task.
#
############################################################################################

export get_containers

"""
    get_containers(cw::ComposedWidget) -> Vector{WidgetContainer}

Return the vector of containers of the composed widget `cw`.
"""
function get_containers(cw::ComposedWidget)
    error("The function `get_containers` is not implemented by $(typeof(cw)).")
end
