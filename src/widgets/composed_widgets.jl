## Description #############################################################################
#
# This file defines the API for composed widgets. Those are objects that contains several
# widgets to perform a task.
#
############################################################################################

export get_container

"""
    get_container(cw::ComposedWidget) -> WidgetContainer

Return the container of the composed widget `cw`.
"""
function get_container(cw::ComposedWidget)
    return cw.container
end
