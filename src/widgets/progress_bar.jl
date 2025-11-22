## Description #############################################################################
#
# Widget: Progress bar.
#
############################################################################################

export WidgetProgressBar
export set_value!

############################################################################################
#                                        Structure                                         #
############################################################################################

@widget mutable struct WidgetProgressBar
    show_value::Bool = false
    style::Symbol = :bar
    value::Float64 = 0.0
end

############################################################################################
#                                        Object API                                        #
############################################################################################

############################################################################################
#                                        Widget API                                        #
############################################################################################

function create_widget(
    ::Val{:progress_bar},
    layout::ObjectLayout;
    show_value::Bool = false,
    style::Symbol = :bar,
    value::Number = 0.0,
    theme::Theme = tui.default_theme
)

    # Create the widget.
    progress_bar = WidgetProgressBar(;
        id               = reserve_object_id(),
        layout           = layout,
        show_value       = show_value,
        style            = style,
        value            = value,
        theme            = theme,
        horizontal_hints = Dict(:width  => 30),
        vertical_hints   = Dict(:height => 1),
    )

    @log DEBUG "create_widget" """
    WidgetInputField created:
      ID         = $(progress_bar.id)
      Style      = $(progress_bar.style)
      Show value = $(progress_bar.show_value)"""

    # Return the created container.
    return progress_bar
end

function redraw!(widget::WidgetProgressBar)
    NCurses.wclear(widget.buffer)

    if widget.style == :line
        _progress_bar__draw_with_line_sytle!(widget)
    else
        _progress_bar__draw_with_bar_style!(widget)
    end

    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper progress_bar

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    set_value!(progress_bar::WidgetProgressBar, value::Number) -> Nothing

Set the `value` of the `progress_bar`.
"""
function set_value!(progress_bar::WidgetProgressBar, value::Number)
    progress_bar.value = clamp(value, 0, 100)
    request_update!(progress_bar)
    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _progress_bar__draw_with_bar_style!(widget::WidgetProgressBar) -> Nothing

Draw the progress bar `widget` using the bar style.
"""
function _progress_bar__draw_with_bar_style!(widget::WidgetProgressBar)
    @unpack buffer, show_value, value, width, theme = widget

    value = clamp(value, 0, 100)

    # Compute the number of spaces with decoration.
    num_with_color = round(Int, width * value / 100)

    # Draw the background.
    @ncolor (theme.default) buffer begin
        NCurses.mvwprintw(buffer, 0, 0, " "^width)
    end

    # Draw the progress.
    @ncolor (theme.default | NCurses.A_REVERSE) buffer begin
        NCurses.mvwprintw(buffer, 0, 0, " "^num_with_color)
    end

    # Draw the progress value, if requested, considering the correct colors.
    if show_value
        progress_str = "$(round(Int, value)) %"
        lstr = length(progress_str)
        str_pos = floor(Int, (width - lstr) / 2)

        @inbounds for i in 1:length(progress_str)
            pos_i = str_pos + (i - 1)
            color = theme.default

            if pos_i < num_with_color
                color |= NCurses.A_REVERSE
            end

            @ncolor color buffer begin
                c = progress_str[i - 1 + begin]
                NCurses.mvwprintw(buffer, 0, pos_i, c == '%' ? "%%" : string(c))
            end
        end
    end

    return nothing
end

"""
    _progress_bar__draw_with_line_sytle!(widget::WidgetProgressBar) -> Nothing

Draw the progress bar `widget` using the line style.
"""
function _progress_bar__draw_with_line_sytle!(widget::WidgetProgressBar)
    @unpack buffer, show_value, value, width, theme = widget

    bar_width = show_value ? width - 6 : width

    # If `bar_width` is less than or equal to zero, there is no space to draw the bar.
    bar_width ≤ 0 && return nothing

    value = clamp(value, 0, 100)

    # Compute the number of spaces with decoration.
    num_with_color = round(Int, bar_width * value / 100)

    # Draw the background.
    @ncolor theme.default buffer begin
        NCurses.mvwprintw(buffer, 0, 0, "━"^(bar_width))
        NCurses.mvwprintw(buffer, 0, bar_width, " "^(width - bar_width))
    end

    # Draw the progress.
    @ncolor theme.selected buffer begin
        NCurses.mvwprintw(buffer, 0, 0, "━"^num_with_color)
    end

    # Draw the progress value, if requested, considering the correct colors.
    if show_value
        progress_str = "$(round(Int, value)) %%"
        lstr         = length(progress_str)
        str_pos      = width - lstr + 1

        @ncolor theme.default buffer begin
            NCurses.mvwprintw(buffer, 0, str_pos, progress_str)
        end
    end

    return nothing
end