# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
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

accept_focus(widget::ComposedWidget) = accept_focus(widget.container)
process_focus(widget::ComposedWidget, k::Keystroke) = process_focus(widget.container, k)
redraw(widget::ComposedWidget) = redraw(widget.container)
release_focus(widget::ComposedWidget) = release_focus(widget.container)
require_cursor(widget::ComposedWidget) = require_cursor(widget.container)
