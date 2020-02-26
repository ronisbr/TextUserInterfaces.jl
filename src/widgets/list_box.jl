# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Widget: List box.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetListBox, get_data, get_selected, select_item

################################################################################
#                                     Type
################################################################################

@with_kw mutable struct WidgetListBox{T<:WidgetParent} <: Widget

    # API
    # ==========================================================================
    common::WidgetCommon{T}

    # Parameters related to the widget
    # ==========================================================================

    # Data to be listed.
    data::Vector{String}

    # Selected data.
    selected::Vector{Bool}

    # Current highlighted item.
    curh::Int = 0

    # View pointer.
    begview::Int = 0

    # Number of lines that will be displayed.
    numlines::Int = 1

    # Original configuration related to the number of lines.
    numlines₀::Int = 1

    # Are the elements selectable?
    selectable::Bool = false

    # Allow multiple selection.
    multiple_selection::Bool = false

    # Styling
    # ==========================================================================
    color::Int = 0
    color_highlight::Int = Int(A_REVERSE)
    color_selected::Int = 0
    show_icon::Bool = false
    icon_not_selected::String = "[ ]"
    icon_selected::String = "[X]"

    # Signals
    # ==========================================================================
    on_return_pressed::Function = ()->return nothing
    vargs_on_return_pressed::Tuple = ()
end

################################################################################
#                                     API
################################################################################

function accept_focus(widget::WidgetListBox)
    # Make sure that the highlighted item is on view.
    _move_view(widget, 0)

    request_update(widget)
    return true
end

function create_widget(::Val{:list_box}, parent::WidgetParent;
                       data::Vector{String} = String[],
                       color::Int = 0,
                       color_highlight::Int = Int(A_REVERSE),
                       color_selected::Int = 0,
                       multiple_selection::Bool = false,
                       numlines::Int = -1,
                       icon_not_selected::String = "[ ]",
                       icon_selected::String = "[X]",
                       selectable::Bool = true,
                       show_icon::Bool = false,
                       kwargs...)

    # Positioning configuration.
    opc = object_positioning_conf(; kwargs...)

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    if opc.vertical == :unknown
        opc.height = length(data)
    end

    if opc.horizontal == :unknown
        opc.width = maximum(length.(data))
        show_icon && (opc.width += max(length(icon_selected),
                                       length(icon_not_selected)) + 1)
    end

    # Create the common parameters of the widget.
    common = create_widget_common(parent, opc)

    numlines₀ = numlines

    # If `numlines` is less or equal 0, then make it equal to the number of
    # available lines of the widget.
    numlines ≤ 0 && (numlines = common.height)

    # `numlines` must not be greater than the widget height.
    numlines > common.height && (numline = common.height)

    # Create the widget.
    widget = WidgetListBox(common             = common,
                           color              = color,
                           color_highlight    = color_highlight,
                           color_selected     = color_selected,
                           data               = data,
                           icon_not_selected  = icon_not_selected,
                           icon_selected      = icon_selected,
                           multiple_selection = multiple_selection,
                           numlines           = numlines,
                           numlines₀          = numlines₀,
                           selected           = zeros(Bool, length(data)),
                           selectable         = selectable,
                           show_icon          = show_icon)

    # Add the new widget to the parent widget list.
    add_widget(parent, widget)

    @log info "create_widget" """
    A list box was created in $(obj_desc(parent)).
        Size           = ($(common.height), $(common.width))
        Coordinate     = ($(common.top), $(common.left))
        Data length    = $(length(data))
        Mul. Selection = $multiple_selection
        Num. lines     = $numlines
        Positioning    = ($(common.opc.vertical),$(common.opc.horizontal))
        Reference      = $(obj_to_ptr(widget))
        Show icon      = $show_icon"""

    # Return the created widget.
    return widget
end

function process_focus(widget::WidgetListBox, k::Keystroke)
    # Handle the input.
    if _handle_input(widget, k)
        request_update(widget)
        return true
    else
        return false
    end
end

function redraw(widget::WidgetListBox)
    @unpack common, begview, color, color_highlight, color_selected, curh, data,
            icon_not_selected, icon_selected, numlines, selected,
            show_icon = widget
    @unpack parent, buffer, width = common

    wclear(buffer)

    # Make sure that the number of lines that will be printed are inside the
    # allowed interval.
    numlines = clamp(numlines, 1, length(data))

    for i = 0:numlines-1
        # ID of the current item in the vectors.
        id = clamp(begview+i+1, 1, length(data))

        # Select which icon must be used for this item.
        if show_icon
            icon  = selected[id] ? icon_selected : icon_not_selected
            icon *= " "
        else
            icon = ""
        end

        # Select which color the current item must be printed.
        color_i = selected[id] ? color_selected : color

        # If the item is the highlighted (the one that holds the cursor), then
        # the color must be inverted.
        if (begview+i == curh) && has_focus(parent, widget)
            color_i = color_highlight
        end

        # Compute the padding after the text so that the entire field is filled
        # with the correct color.
        str = icon * data[id]
        Δ   = common.width - length(str)
        pad = Δ > 0 ? " "^Δ : ""

        wattron(buffer, color_i)
        mvwprintw(buffer, i, 0, str * pad)
        wattroff(buffer, color_i)
    end

    return nothing
end

function release_focus(widget::WidgetListBox)
    request_update(widget)
    return true
end

function reposition!(widget::WidgetListBox; force::Bool = false)
    # Call the default repositioning function.
    if invoke(reposition!, Tuple{Widget}, widget; force = force)
        @unpack common, begview, data, numlines, numlines₀ = widget

        len_data = length(data)

        # In this case, we must take care about the size.
        if numlines₀ ≤ 0
            numlines = common.height
        elseif numlines > numlines₀
            numlines = numlines₀
        end

        # `numlines` must not be greater than the widget height.
        common.height < numlines && (numlines = common.height)

        # `numlines` must not be greater than the number of data.
        len_data < numlines && (numlines = len_data)

        # Adjust the beginning of the view.
        if begview + numlines > len_data
            begview = len_data - numlines
        end

        @pack! widget = begview, numlines

        # Make sure that the highlighted item is on view.
        _move_view(widget, 0)

        return true
    else
        return false
    end
end

require_cursor(widget::WidgetListBox) = false

################################################################################
#                           Custom widget functions
################################################################################

"""
    get_data(widget::WidgetListBox)

Return the data of the list box `widget`.

"""
get_data(widget::WidgetListBox) = widget.data

"""
    get_selected(widget::WidgetListBox)

Return an array of `Bool` indicating which elements of the list box `widget` are
selected.

"""
get_selected(widget::WidgetListBox) = widget.selected

"""
    get_selected_item(widget::WidgetListBox)

Return the ID of the current item of the list box `widget` and the data
associated with it.

"""
function get_current_item(widget::WidgetListBox)
    id = widget.curh + 1
    return id, widget.data[id]
end

"""
    select_item(widget::WidgetListBox, id::Int)

Select the item `id` in the list box `widget`. Notice that `id` refers to the
position of the item in the array `data`.

"""
function select_item(widget::WidgetListBox, id::Int)
    @unpack data = widget

    if 0 < id ≤ length(data)
        widget.curh = id-1
        _move_view(widget, 0)
    end

    return nothing
end

################################################################################
#                              Private functions
################################################################################

function _handle_input(widget::WidgetListBox, k::Keystroke)
    @unpack data, begview, curh, multiple_selection, numlines, selectable,
            selected = widget

    # Shift that we must apply to the list highlight item.
    Δx = 0

    # Release focus.
    if k.ktype == :tab
        return false
    elseif k.ktype == :enter
        widget.on_return_pressed(widget.vargs_on_return_pressed...)
    # Toggle the selection of the current item.
    elseif k.value == " "
        if selectable
            id = curh + 1

            if multiple_selection
                selected[id] = !selected[id]
            else
                selected .= false
                selected[id] = true
            end
        end
    # Select previous value.
    elseif k.ktype == :up
        Δx -= 1
    # Select next value.
    elseif k.ktype == :down
        Δx += 1
    elseif k.ktype == :pageup
        Δx -= numlines
    elseif k.ktype == :pagedown
        Δx += numlines
    elseif k.ktype == :home
        # The overflow will be handled by `_move_view`.
        Δx -= length(data)
    elseif k.ktype == :end
        # The overflow will be handled by `_move_view`.
        Δx += length(data)
    end

    _move_view(widget, Δx)

    return true
end

function _move_view(widget::WidgetListBox, Δx::Int)
    @unpack begview, curh, data, numlines = widget

    # Make sure `curh` is inside the allowed bounds considering the data.
    curh = clamp(curh + Δx, 0, length(data)-1)

    # Check if the highlighted values is outside the view.
    if curh < begview
        begview = curh
    elseif curh > (begview + numlines - 1)
        begview = curh - numlines + 1
    end

    # Repack values that were modified.
    @pack! widget = curh, begview

    return nothing
end
