# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Widget: Canvas.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetCanvas

################################################################################
#                                     Type
################################################################################

@widget mutable struct WidgetCanvas
    chars::Matrix{String}
    colors::Matrix{Int}

    # Signals
    # ==========================================================================
    @signal return_pressed
end

################################################################################
#                                     API
################################################################################

function create_widget(::Val{:canvas},
                       parent::WidgetParent,
                       opc::ObjectPositioningConfiguration;
                       num_columns = 1,
                       num_rows = 1)

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    _process_horizontal_info!(opc)
    _process_vertical_info!(opc)

    opc.vertical   == :unknown && (opc.height = num_rows)
    opc.horizontal == :unknown && (opc.width  = num_columns)

    # Create the matrices that will hold the characters and the colors.
    chars  = [" " for i = 1:num_rows, j = 1:num_columns]
    colors = zeros(Int, num_rows, num_columns)

    # Create the widget.
    widget = WidgetCanvas(parent = parent,
                          opc    = opc,
                          chars  = chars,
                          colors = colors)

    # Initialize the internal variables of the widget.
    init_widget!(widget)

    # Add the new widget to the parent widget list.
    add_widget(parent, widget)

    @log info "create_widget" """
    A canvas was created in $(obj_desc(parent)).
        Size        = ($(widget.height), $(widget.width))
        Coordinate  = ($(widget.top), $(widget.left))
        Positioning = ($(widget.opc.vertical),$(widget.opc.horizontal))
        Num. cols   = $num_columns
        Num. rows   = $num_rows
        Reference   = $(obj_to_ptr(widget))"""

    # Return the created widget.
    return widget
end

function process_focus(widget::WidgetCanvas, k::Keystroke)
    @log verbose "process_focus" "$(obj_desc(widget)): Key pressed on focused canvas."
    ret = @emit_signal widget key_pressed k

    isnothing(ret) && return k.ktype == :tab ? false : true

    return ret
end

function redraw(widget::WidgetCanvas)
    @unpack buffer, chars, colors = widget

    wclear(buffer)

    N,M = size(chars)

    height = get_height(widget)
    width  = get_width(widget)

    @inbounds for i = 1:N
        i > height+1 && break
        for j = 1:M
            j > width+1 && break

            color_ij = colors[i,j]

            color_ij > 0 && wattron(buffer, color_ij)
            mvwprintw(buffer, i-1, j-1, first(chars[i,j],1))
            color_ij > 0 && wattroff(buffer, color_ij)
        end
    end

    return nothing
end
