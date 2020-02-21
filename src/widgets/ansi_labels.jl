# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Widget: Labels with colors defined by ANSI escape sequences.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetANSILabel, change_text

################################################################################
#                                     Type
################################################################################

@with_kw mutable struct WidgetANSILabel{T<:WidgetParent} <: Widget

    # API
    # ==========================================================================
    common::WidgetCommon{T}

    # Parameters related to the widget
    # ==========================================================================
    text::Vector{String} = String[]
    colors::Vector{Int} = Int[]
end

################################################################################
#                                     API
################################################################################

# Labels cannot accept focus.
accept_focus(widget::WidgetANSILabel) = false

function create_widget(::Type{Val{:ansi_label}}, parent::WidgetParent;
                       alignment = :l,
                       color::Int = 0,
                       text::AbstractString = "Text",
                       kwargs...)

    # Positioning configuration.
    opc = object_positioning_conf(;kwargs...)

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    if (opc.vertical == :unknown) || (opc.horizontal == :unknown)
        printable_text = replace(text, r"\e\[[0-9;]*m(?:\e\[K)?" => s"")
        lines          = split(text, '\n')
        opc.vertical   == :unknown && (opc.height = length(lines))
        opc.horizontal == :unknown && (opc.width  = maximum(length.(lines)))
    end

    # Create the common parameters of the widget.
    common = create_widget_common(parent, opc)

    # Create the widget.
    widget = WidgetANSILabel(common = common)

    # Update the text.
    change_text(widget, text; alignment = alignment)

    # Add the new widget to the parent widget list.
    add_widget(parent, widget)

    @log info "create_widget" """
    An ANSI label was created in $(obj_desc(parent)).
        Size        = ($(common.height), $(common.width))
        Coordinate  = ($(common.top), $(common.left))
        Positioning = ($(common.opc.vertical),$(common.opc.horizontal))
        Text        = \"$text\"
        Reference   = $(obj_to_ptr(widget))"""

    # Return the created widget.
    return widget
end

function redraw(widget::WidgetANSILabel)
    @unpack common, colors, text = widget
    @unpack buffer = common

    wclear(buffer)

    mvwprintw(buffer, 0, 0, "")

    for i = 1:length(text)
        wattron(buffer, colors[i])
        wprintw(buffer, text[i])
        wattroff(buffer, colors[i])
    end

    return nothing
end

################################################################################
#                           Custom widget functions
################################################################################

"""
    change_text(widget::WidgetANSILabel, new_text::AbstractString; alignment = :l, color::Int = -1)

Change to text of the label widget `widget` to `new_text`.

The text alignment in the widget can be selected by the keyword `alignment`,
which can be:

* `:l`: left alignment (**default**);
* `:c`: Center alignment; or
* `:r`: Right alignment.

The text color can be selected by the keyword `color`. It it is negative
(**default**), then the current color will not be changed.

"""
function change_text(widget::WidgetANSILabel, new_text::AbstractString;
                     alignment = :l, color::Int = -1)

    @unpack parent, buffer, width = widget.common

    # Split the string in each line.
    tokens = split(new_text, "\n")

    # Formatted text.
    text = ""

    for line in tokens
        # Notice that if the ANSI escape sequence is not valid, then the
        # alignment will not be correct. This regex remove all ANSI escape
        # sequences to count for the printable characters.
        if alignment ∈ [:r,:c]
            printable_line = replace(line, r"\e\[[0-9;]*m(?:\e\[K)?" => s"")
            length_line    = length(printable_line)
        else
            length_line    = 0
        end

        # Check the alignment and print accordingly.
        if alignment == :r
            col   = width - length_line - 1
            text *= " "^col * line * "\n"
        elseif alignment == :c
            col   = div(width - length_line, 2)
            text *= " "^col * line * "\n"
        else
            text *= line * "\n"
        end
    end

    # Parse the ANSI escape sequences.
    v_str,v_d = parse_ansi_string(text)

    colors = Vector{Int}(undef,0)

    for d in v_d
        c = ncurses_color(d.foreground, d.background,
                          bold      = d.bold,
                          underline = d.underline)
        push!(colors,c)
    end

    widget.text   = v_str
    widget.colors = colors

    @log verbose "change_text" "$(obj_desc(widget)): ANSI Label text changed to \"$new_text\"."

    request_update(widget)

    return nothing
end
