## Description #############################################################################
#
# Widget: Horizontal line.
#
############################################################################################

############################################################################################
#                                        Structure                                         #
############################################################################################

"""
    struct WidgetHorizontalLine

Store a horizontal line widget that renders a repeating pattern across its width.

# Functions

This widget does not have public functions.

# Signals

This widget does not have signals.
"""
@widget mutable struct WidgetHorizontalLine
    pattern::String = "─"
end

############################################################################################
#                                        Object API                                        #
############################################################################################

############################################################################################
#                                        Widget API                                        #
############################################################################################

function create_widget(
    ::Val{:horizontal_line},
    layout::ObjectLayout;
    pattern::String = "─",
    theme::Theme = Theme()
)
    # Create the widget.
    line = WidgetHorizontalLine(;
        id           = reserve_object_id(),
        layout       = layout,
        layout_hints = Dict(:height => 1, :width  => textwidth(pattern)),
        pattern      = pattern,
        theme        = theme,
    )

    @log DEBUG "create_widget" """
    WidgetHorizontalLine created:
      ID      = $(line.id)
      Pattern = $(line.pattern)"""

    # Return the created widget.
    return line
end

function redraw!(widget::WidgetHorizontalLine)
    @unpack buffer, pattern, theme, width = widget
    NCurses.wclear(buffer)

    pw = textwidth(pattern)
    Δ = floor(Int, width / pw)
    str = pattern^Δ

    for k in 1:(width - textwidth(str))
        str *= pattern[(k - 1) % pw + 1]
    end

    @nstyle get_style(theme, :default) buffer begin
        NCurses.mvwprintw(buffer, 0, 0, str)
    end

    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper horizontal_line
