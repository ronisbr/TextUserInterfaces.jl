# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Widget: Horizontal line.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetHorizontalLine, change_glyph!

################################################################################
#                                     Type
################################################################################

@widget mutable struct WidgetHorizontalLine
    glyph::String
end

################################################################################
#                                     API
################################################################################

# Labels cannot accept focus.
accept_focus(widget::WidgetHorizontalLine) = false

function create_widget(
    ::Val{:horizontal_line},
    layout::ObjectLayout;
    glyph::String = "─"
)
    # We should not allow special characters in `glyph`.
    escaped_glyph = escape_string(glyph)

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    horizontal = _process_horizontal_info(layout)

    # The height of a horizontal line is always 1.
    layout.height = 1

    if horizontal == :unknown
        layout.width = textwidth(escaped_glyph)
    end

    # Create the widget.
    widget = WidgetHorizontalLine(
        glyph = escaped_glyph,
        layout = layout
    )

    @log info "create_widget" """
    Horizontal line created:
        Reference  = $(obj_to_ptr(widget))
        Glyph      = $escaped_glyph
    """

    # Return the created widget.
    return widget
end

# TODO: Create the line only when `reposition!` is called.
function redraw(widget::WidgetHorizontalLine)
    @unpack buffer, width, glyph = widget

    wclear(buffer)

    num_chars = 0
    line_filled = false

    mvwprintw(buffer, 0, 0, "")

    while !line_filled
        for c in glyph
            if num_chars ≥ width
                line_filled = true
                break
            end

            wprintw(buffer, string(c))
            num_chars += textwidth(c)
        end
    end

    return nothing
end

################################################################################
#                           Custom widget functions
################################################################################

"""
    change_glyph!(widget::WidgetHorizontalLine, glyph::String)

Change the glyph of the horizontal line `widget` to `glyph`.
"""
function change_glyph!(widget::WidgetHorizontalLine, glyph::String)
    widget.glyph = escape_strige(glyph)
    request_update!(widget)

    return nothing
end

################################################################################
#                                   Helpers
################################################################################

@create_widget_helper horizontal_line
