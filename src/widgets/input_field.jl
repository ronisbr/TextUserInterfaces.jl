# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Widget: Input field.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetInputField

################################################################################
#                                  Structure
################################################################################

@widget mutable struct WidgetInputField
    # Data array that contains the input to the field.
    data::Vector{Char} = Char[]

    # Position of the physical cursor in the field.
    cury::Int = 1
    curx::Int = 1

    # Maximum allowed data size.
    max_data_size::Int = 0

    # Field usable size in screen.
    size::Int = 0

    # Position of the virtual cursor in the data array.
    vcury::Int = 1
    vcurx::Int = 1

    # Index of the first character in the data vector to be printed.
    view::Int = 1

    # Styling
    # =======

    border::Bool = false
end

################################################################################
#                                  Object API
################################################################################

function update_layout!(widget::WidgetInputField; force::Bool = false)
    if invoke(update_layout!, Tuple{Widget}, widget; force = force)
        # Since the widget could have changed its size, we need to compute the
        # usable size to display the text.
        widget.size = widget.border ? widget.width - 2 : widget.width

        return true
    else
        return false
    end
end

################################################################################
#                                  Widget API
################################################################################

can_accept_focus(::WidgetInputField) = true

function create_widget(
    ::Val{:input_field},
    layout::ObjectLayout;
    border::Bool = false,
    max_data_size::Int = 0
)

    # Create the widget.
    input_field = WidgetInputField(
        id               = reserve_object_id(),
        border           = border,
        layout           = layout,
        max_data_size    = max_data_size,
        horizontal_hints = (; width = 30),
        vertical_hints   = (; height = !border ? 1 : 3)
    )

    @log INFO "create_widget" """
    WidgetInputField created:
        ID             = $(input_field.id)
        Border         = $(border)
        Max. data size = $(max_data_size)"""

    # Return the created container.
    return input_field
end

function process_keystroke!(widget::WidgetInputField, k::Keystroke)
    @unpack border = widget

    # In this case, if we have a global command, we must not process the
    # keystroke.
    cmd = check_global_command(k)
    isnothing(cmd) || return :keystorke_not_processed

    # Handle the input.
    if _handle_input!(widget, k)
        # Update the cursor position.
        _update_cursor(widget)

        return :keystroke_processed
    else
        return :keystroke_not_processed
    end
end

function request_focus!(widget::WidgetInputField)
    # When accepting focus we must update the cursor position so that it can be
    # positioned in the position it was when the focus was released.
    _update_cursor(widget)
    request_update!(widget)
    return true
end

request_cursor(::WidgetInputField) = true

function redraw!(widget::WidgetInputField)
    @unpack border, buffer, curx, cury = widget
    @unpack data, size, view = widget

    wclear(buffer)

    # Convert the data to string.
    if isempty(data)
        str = ""
    else
        aux = clamp(view + size - 1, 1, length(data))
        str = String(@view data[view:aux])
    end

    # Check if a border must be drawn.
    if border
        wborder(buffer)
        y₀ = x₀ = 1
    else
        y₀ = x₀ = 0
    end

    # First, print spaces to apply the styling.
    mvwprintw(buffer, y₀, x₀, " " ^ size)
    mvwprintw(buffer, y₀, x₀, str)

    # We need to update the cursor after every redraw.
    _update_cursor(widget)

    return nothing
end

################################################################################
#                                   Helpers
################################################################################

@create_widget_helper input_field

################################################################################
#                              Private functions
################################################################################

function _handle_input!(widget::WidgetInputField, k::Keystroke)
    @unpack data, max_data_size, view, curx, cury, size, vcury, vcurx = widget

    # We do not support multiple lines yet.
    vcury = 1
    cury  = 1

    # Number of spaces the virtual cursor must move.
    Δx = 0

    # Flag to inform if the widget must be updated.
    update = false

    # Move cursor to the left.
    if k.ktype == :left
        Δx = -1

    # Move cursor to the right.
    elseif k.ktype == :right
        Δx = +1

    # Go to the beginning of the data.
    elseif k.ktype == :home
        Δx = -(vcurx - 1)

    # Go to the end of the data.
    elseif k.ktype == :end
        Δx = length(data) - vcurx + 1

    # Delete the previous character.
    elseif k.ktype == :backspace
        if vcurx > 1
            deleteat!(data, vcurx - 1)

            # We should only move the cursor if the view is at the beginning of
            # the string.
            if view == 1
                Δx = -1
            end

            update = true
        end

    # Delete the next character.
    elseif k.ktype == :delete
        vcurx ≤ length(data) && deleteat!(data, vcurx)
        update = true

    # Insert the character in the position of the virtual cursor.
    elseif k.ktype ∈ [:char, :utf8]
        if (max_data_size ≤ 0) || (length(data) < max_data_size)
            if isempty(data)
                push!(data, k.value[1])
            else
                pos = clamp(vcurx, 1, length(data) + 1)
                insert!(data, pos, k.value[1])
            end
            Δx = +1
            update = true
        end

    # Unsupported key -- we do not pass the focus.
    else
        return true
    end

    # Limit for the cursors in the X-axis.
    cxlimit = max_data_size > 0 ?
        min(max_data_size, length(data) + 1) :
        length(data) + 1

    # Update the position of the virtual cursor.
    vcurx = clamp(vcurx + Δx, 1, cxlimit)

    # Check if we must change the view of the field.
    curx += Δx

    if Δx < 0
        # Otherwise, move the view.
        if (curx ≤ 0) && (view > 1)
            view += Δx

            # If the view reached the most left position, then we must move the
            # cursor.
            curx += min(0, view - 1)

            update = true
        end
    elseif Δx > 0

        # If the cursor is at the right edge, then just move the view.
        if curx > size
            curx = size
            view += Δx
            update = true
        end
    end

    # The cursor position must not pass the data.
    curx = clamp(curx, 1, cxlimit)

    # Make sure that view is in the acceptable interval.
    #
    # If the field is completely filled, than we would not allow an additional
    # space for the cursor at the position a character would be added.
    max_view = length(data) - size + 2

    if length(data) == max_data_size
        max_view -= 1
    end

    view = clamp(view, 1, max(1, max_view))

    # Request update if necessary.
    update && request_update!(widget)

    # Repack values that were modified.
    @pack! widget = cury, curx, vcury, vcurx, view

    return true
end

function _update_cursor(widget::WidgetInputField)
    # Move the physical cursor to the correct position considering the border if
    # present.
    #
    # NOTE: The initial position here starts at 1, but in NCurses it starts in
    # 0.
    py = widget.border ? widget.cury : widget.cury - 1
    px = widget.border ? widget.curx : widget.curx - 1
    wmove(widget.buffer, py, px)

    return nothing
end
