## Description #############################################################################
#
# Widget: List Box.
#
############################################################################################

export WidgetListBox
export get_current_item, get_selected_items

############################################################################################
#                                        Structure                                         #
############################################################################################

@widget mutable struct WidgetListBox
    # List box data.
    data::Vector{String}

    # Selected data.
    selected::Vector{Bool}

    # Current item in the list box cursor.
    current_item::Int = 0

    # View pointer.
    begview::Int = 0

    # Number of lines that will be displayed.
    numlines::Int = -1

    # Original configuration related to the number of lines.
    numlines₀::Int = -1

    # Are the elements selectable?
    selectable::Bool = false

    # Allow multiple selection.
    multiple_selection::Bool = false

    # == Styling ===========================================================================

    border::Bool = false
    show_icon::Bool = false
    item_icon::String = "[ ]"
    selected_item_icon::String = "[X]"

    # == Signals ===========================================================================

    @signal esc_pressed
    @signal return_pressed
end

############################################################################################
#                                        Object API                                        #
############################################################################################

function update_layout!(widget::WidgetListBox; force::Bool = false)
    if update_widget_layout!(widget; force = force)
        @unpack begview, border, data, height, numlines, numlines₀ = widget

        num_elements = length(data)

        # In this case, we must take care about the size.
        if numlines₀ ≤ 0
            numlines = height
        else
            numlines = numlines₀
        end

        # `numlines` must not be greater than the widget height and the number of data.
        numlines = min(numlines, height, num_elements)

        # Adjust the beginning of the view.
        if begview + numlines > num_elements
            begview = num_elements - numlines
        end

        @pack! widget = begview, numlines

        # Make sure that the highlighted item is on view.
        _move_view(widget, 0)

        return true
    else
        return false
    end
end

############################################################################################
#                                        Widget API                                        #
############################################################################################

can_accept_focus(::WidgetListBox) = true

function create_widget(
    ::Val{:list_box},
    layout::ObjectLayout;
    border::Bool = false,
    data::Vector{String} = String[],
    multiple_selection::Bool = false,
    number_of_lines::Int = -1,
    item_icon::String = "[ ]",
    selected_item_icon::String = "[X]",
    selectable::Bool = true,
    show_icon::Bool = false,
    theme::Theme = tui.default_theme
)
    num_elements = length(data)
    width_hint   = maximum(textwidth.(data))
    height_hint  = number_of_lines > 0 ? number_of_lines : num_elements

    # If we have borders, we must increase the vertical and horizontal hints.
    if border
        width_hint  += 2
        height_hint += 2
    end

    if show_icon
        width_hint += max(textwidth(item_icon), textwidth(selected_item_icon)) + 1
    end

    # Create the widget.
    list_box = WidgetListBox(
        ;
        id                 = reserve_object_id(),
        border             = border,
        data               = data,
        item_icon          = item_icon,
        layout             = layout,
        multiple_selection = multiple_selection,
        numlines           = number_of_lines,
        numlines₀          = number_of_lines,
        selectable         = selectable,
        selected           = zeros(Bool, num_elements),
        selected_item_icon = selected_item_icon,
        show_icon          = show_icon,
        theme              = theme,
        horizontal_hints   = Dict(:width  => width_hint),
        vertical_hints     = Dict(:height => height_hint)
    )

    @log DEBUG "create_widget" """
    WidgetListBox created:
      ID                 = $(list_box.id)
      Border             = $(border)
      Item icon          = $(item_icon)
      Multiple selection = $(multiple_selection)
      Number of elements = $(length(data))
      Number of lines    = $(number_of_lines)
      Selectable         = $(selectable)
      Selected item icon = $(selected_item_icon)
      Show item          = $(show_icon)"""

    # Return the created widget.
    return list_box
end

function process_keystroke!(widget::WidgetListBox, k::Keystroke)
    # In this case, if we have a global command, we must not process the keystroke.
    cmd = check_global_command(k)
    isnothing(cmd) || return :keystorke_not_processed

    # If the keystroke is `enter` or `esc`, just emit the signal.
    if k.ktype == :enter
        @emit widget return_pressed
        return :keystroke_processed

    elseif k.ktype == :esc
        @emit widget esc_pressed
        return :keystroke_processed

    # Handle the input.
    elseif _handle_input!(widget, k)
        request_update!(widget)
        return :keystroke_processed

    else
        return :keystroke_not_processed
    end
end

function request_focus!(widget::WidgetListBox)
    request_update!(widget)
    return true
end

request_cursor(::WidgetListBox) = false

function redraw!(widget::WidgetListBox)
    @unpack begview, buffer, = widget
    @unpack border, current_item, data, item_icon, selected_item_icon, numlines = widget
    @unpack selected, show_icon, theme, width = widget

    NCurses.wclear(buffer)

    if border
        Δi = 1
        Δj = 1
    else
        Δi = 0
        Δj = 0
    end

    for i in 0:numlines-1
        # ID of the current item in the vectors.
        id = clamp(begview + i + 1, 1, length(data))

        # Select which icon must be used for this item.
        if show_icon
            icon  = selected[id] ? selected_item_icon : item_icon
            icon *= " "
        else
            icon = ""
        end

        # Select which color the current item must be printed.
        color_i = selected[id] ? theme.selected : theme.default

        # If the item is the highlighted (the one that holds the cursor), the color must be
        # inverted.
        if (begview + i == current_item) && has_focus(widget)
            color_i |= theme.highlight
        end

        # Compute the padding after the text so that the entire field is filled with the
        # correct color.
        str = icon * data[id]
        Δ   = width - length(str)
        pad = Δ > 0 ? " " ^ Δ : ""

        @ncolor color_i buffer begin
            NCurses.mvwprintw(buffer, i + Δi, Δj, str * pad)
        end
    end

    border && NCurses.wborder(buffer)

    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper list_box

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    get_current_item(widget::WidgetListBox) -> Union{String, Nothing}

Return the current item in the list box `widget`.
"""
function get_current_item(widget::WidgetListBox)
    return widget.data[widget.current_item + 1]
end

"""
    get_selected_items(widget::WidgetListBox) -> Vector{String}

Return an array with the selected items in the list box `widget`.
"""
function get_selected_items(widget::WidgetListBox)
    return widget.data[widget.selected]
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

# Handle the input `k` in the list box `widget`.
function _handle_input!(widget::WidgetListBox, k::Keystroke)
    @unpack data, begview, current_item, multiple_selection, numlines = widget
    @unpack selectable, selected = widget

    # Shift that we must apply to the list highlight item.
    Δx = 0

    # Flag that indicates if the input was handled.
    input_handled = true

    # Toggle the selection of the current item.
    if k.value == " "
        if selectable
            id = current_item + 1

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
    else
        input_handled = false
    end

    if input_handled
        _move_view(widget, Δx)
        return true
    else
        return false
    end
end

# Move the view in the list box `widget` by `Δx` itens.
function _move_view(widget::WidgetListBox, Δx::Int)
    @unpack begview, current_item, data, numlines = widget

    # Make sure `current_item` is inside the allowed bounds considering the data.
    current_item = clamp(current_item + Δx, 0, length(data) - 1)

    # Check if the highlighted values is outside the view.
    if current_item < begview
        begview = current_item
    elseif current_item > (begview + numlines - 1)
        begview = current_item - numlines + 1
    end

    # Repack values that were modified.
    @pack! widget = current_item, begview

    return nothing
end
