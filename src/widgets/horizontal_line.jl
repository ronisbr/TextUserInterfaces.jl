# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Widget: Horizontal line.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

############################################################################################
#                                        Structure                                         #
############################################################################################

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
    theme::Theme = tui.default_theme,
)
    # Create the widget.
    line = WidgetHorizontalLine(
        ;
        id               = reserve_object_id(),
        horizontal_hints = Dict(:width  => textwidth(pattern)),
        layout           = layout,
        pattern          = pattern,
        theme            = theme,
        vertical_hints   = Dict(:height => 1)
    )

    @log DEBUG "create_widget" """
    WidgetHorizontalLine created:
      ID = $(line.id)
      Pattern = $(line.pattern)"""

    # Return the created widget.
    return line
end

function redraw!(widget::WidgetHorizontalLine)
    @unpack buffer, pattern, theme, width = widget
    wclear(buffer)

    pw = textwidth(pattern)
    Δ = floor(Int, width / pw)
    str = pattern^Δ

    for k in 1:(width - textwidth(str))
        str *= pattern[(k - 1) % pw + 1]
    end

    @ncolor theme.default buffer begin
        mvwprintw(buffer, 0, 0, str)
    end

    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper horizontal_line
