# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Widget: Labels with colors defined by ANSI escape sequences.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetANSILabel, change_text

################################################################################
#                                     Type
################################################################################

@widget mutable struct WidgetANSILabel
    # Input label data from the user.
    alignment::Symbol
    text₀::AbstractString

    # Variable to store the parsed text and color to reduce the computational
    # burden.
    text::Vector{String} = String[]
    colors::Vector{Int} = Int[]
end

################################################################################
#                                     API
################################################################################

# Labels cannot accept focus.
accept_focus(widget::WidgetANSILabel) = false

function create_widget(::Val{:ansi_label},
                       opc::ObjectPositioningConfiguration;
                       alignment = :l,
                       color::Int = 0,
                       text::AbstractString = "Text")

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    horizontal = _process_horizontal_info(opc)
    vertical   = _process_vertical_info(opc)

    if (vertical == :unknown) || (horizontal == :unknown)
        printable_text = replace(text, r"\e\[[0-9;]*m(?:\e\[K)?" => s"")
        lines          = split(text, '\n')
        vertical   == :unknown && (opc.height = length(lines))
        horizontal == :unknown && (opc.width  = maximum(length.(lines)) + 1)
    end

    # Create the widget.
    widget = WidgetANSILabel(opc       = opc,
                             alignment = alignment,
                             text₀     = text)

    @log info "create_widget" """
    ANSI label created:
        Reference = $(obj_to_ptr(widget))
        Alignment = $alignment
        Text      = \"$text\""""

    # Return the created widget.
    return widget
end

function redraw(widget::WidgetANSILabel)
    @unpack buffer, colors, text = widget

    wclear(buffer)

    mvwprintw(buffer, 0, 0, "")

    for i = 1:length(text)
        wattron(buffer, colors[i])
        wprintw(buffer, text[i])
        wattroff(buffer, colors[i])
    end

    return nothing
end

function reposition!(widget::WidgetANSILabel; force::Bool = false)
    # Call the default repositioning function.
    if invoke(reposition!, Tuple{Widget}, widget; force = force)
        _parse_ansi_text!(widget)
        return true
    else
        return false
    end
end

################################################################################
#                           Custom widget functions
################################################################################

"""
    change_text(widget::WidgetANSILabel, new_text::AbstractString; alignment = :l)

Change to text of the label widget `widget` to `new_text`.

The text alignment in the widget can be selected by the keyword `alignment`,
which can be:

* `:l`: left alignment (**default**);
* `:c`: Center alignment; or
* `:r`: Right alignment.

"""
function change_text(widget::WidgetANSILabel, new_text::AbstractString;
                     alignment = :l)

    widget.text₀ = new_text
    _parse_ansi_text!(widget)

    @log verbose "change_text" "$(obj_desc(widget)): ANSI Label text changed to \"$new_text\"."

    return nothing
end

################################################################################
#                              Private functions
################################################################################

# This function gets the text in the variable `text₀`, and converts the ANSI
# escape sequences to NCurse colors. It is only called when the widget is
# repositioned.
function _parse_ansi_text!(widget::WidgetANSILabel)
    # If the widget does not has a parent, then we cannot align the text.
    isnothing(widget.parent) && return nothing

    @unpack parent, alignment, buffer, text₀, width = widget

    # Split the string in each line.
    tokens = split(text₀, "\n")

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

    request_update(widget)

    return nothing
end
