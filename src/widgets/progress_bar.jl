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
    value::Float64 = 0.0
    title::String = ""
    title_alignment::Symbol = :l
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
    value::Number = 0.0,
    title::String = "",
    title_alignment::Symbol = :l,
    theme::Theme = tui.default_theme
)

    # Create the widget.
    progress_bar = WidgetProgressBar(;
        id               = reserve_object_id(),
        border           = border,
        layout           = layout,
        show_value       = show_value,
        value            = value,
        theme            = theme,
        title            = title,
        title_alignment  = title_alignment,
        horizontal_hints = Dict(:width  => 30),
        vertical_hints   = Dict(:height => border ? 3 : 1),
    )

    @log DEBUG "create_widget" """
    WidgetInputField created:
      ID         = $(progress_bar.id)
      Border     = $(progress_bar.border)
      Show value = $(progress_bar.show_value)"""

    # Return the created container.
    return progress_bar
end

function redraw!(widget::WidgetProgressBar)
    @unpack buffer, border, show_value, value, width, title, title_alignment, theme = widget

    value = clamp(value, 0, 100)

    NCurses.wclear(buffer)

    Δy = 0
    Δx = 0

    if border
        NCurses.wborder(buffer)

        # Check if we need to draw the title.
        if !isempty(title)
            tw = textwidth(title)

            Δxt = if title_alignment == :r
                max(width - tw - 1, 0)
            elseif title_alignment == :c
                max(div(width - tw - 2, 2), 0)
            else
                1
            end

            NCurses.mvwprintw(buffer, 0, Δxt, title)
        end

        Δx = 1
        Δy = 1
        width -= 2
    end

    # Compute the number of spaces with and without decoration.
    num_with_color = round(Int, width * value / 100)
    num_without_color = width - num_with_color

    # Draw the background.
    @ncolor (theme.default) buffer begin
        NCurses.mvwprintw(buffer, Δy, Δx, " "^width)
    end

    # Draw the progress.
    @ncolor (theme.default | NCurses.A_REVERSE) buffer begin
        NCurses.mvwprintw(buffer, Δy, Δx, " "^num_with_color)
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
    set_value!(progress_bar::WidgetProgressBar, value::Number) -> Nothing

Set the `value` of the `progress_bar`.
"""
function set_value!(progress_bar::WidgetProgressBar, value::Number)
    progress_bar.value = clamp(value, 0, 100)
    request_update!(progress_bar)
    return nothing
end