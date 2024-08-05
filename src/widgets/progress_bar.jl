# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Widget: Progress bar.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetProgressBar
export set_value!

############################################################################################
#                                        Structure
############################################################################################

@widget mutable struct WidgetProgressBar
    border::Bool = false
    show_value::Bool = false
    value::Int = 0
end

############################################################################################
#                                        Object API
############################################################################################

############################################################################################
#                                        Widget API
############################################################################################

function create_widget(
    ::Val{:progress_bar},
    layout::ObjectLayout;
    border::Bool = false,
    show_value::Bool = false,
    value::Int = 0,
    theme::Theme = tui.default_theme
)

    # Create the widget.
    progress_bar = WidgetProgressBar(
        ;
        id               = reserve_object_id(),
        layout           = layout,
        show_value       = show_value,
        value            = value,
        theme            = theme,
        horizontal_hints = Dict(:width  => 30),
        vertical_hints   = Dict(:height => border ? 3 : 1)
    )

    @log DEBUG "create_widget" """
    WidgetInputField created:
      ID             = $(progress_bar.id)
      Show value     = $(progress_bar.show_value)"""

    # Return the created container.
    return progress_bar
end

function redraw!(widget::WidgetProgressBar)
    @unpack buffer, border, show_value, value, width, theme = widget

    value = clamp(value, 0, 100)

    NCurses.wclear(buffer)

    # Compute the number of spaces with and without decoration.
    num_with_color = round(Int, width * value / 100)
    num_without_color = width - num_with_color

    Δy = border ? 1 : 0

    # Draw the background.
    @ncolor (theme.default) buffer begin
        NCurses.mvwprintw(buffer, Δy, 0, " "^width)
    end

    # Draw the progress.
    @ncolor (theme.default | A_REVERSE) buffer begin
        NCurses.mvwprintw(buffer, Δy, 0, " "^num_with_color)
    end

    # Draw the progress value, if requested, considering the correct colors.
    if show_value
        progress_str = "$value %"
        lstr = length(progress_str)
        str_pos = floor(Int, (width - lstr) / 2)

        for i in 1:length(progress_str)
            pos_i = str_pos + (i - 1)
            color = theme.default

            if pos_i < num_with_color
                color |= NCurses.A_REVERSE
            end

            @ncolor color buffer begin
                c = progress_str[i]

                if c == '%'
                    NCurses.mvwprintw(buffer, Δy, pos_i, "%%")
                else
                    NCurses.mvwprintw(buffer, Δy, pos_i, string(c))
                end
            end
        end
    end

    return nothing
end

############################################################################################
#                                         Helpers
############################################################################################

@create_widget_helper progress_bar

############################################################################################
#                                     Public Functions
############################################################################################

"""
    set_value!(progress_bar::WidgetProgressBar, value::Int) -> Nothing

Set the `value` of the `progress_bar`.
"""
function set_value!(progress_bar::WidgetProgressBar, value::Int)
    progress_bar.value = clamp(value, 0, 100)
    request_update!(progress_bar)
    return nothing
end
