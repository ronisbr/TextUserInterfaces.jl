# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Widget: Input field.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetInputField

################################################################################
#                                     Type
################################################################################

@with_kw mutable struct WidgetInputField{T<:WidgetParent} <: Widget

    # API
    # ==========================================================================
    common::WidgetCommon{T}

    # Parameters related to the widget
    # ==========================================================================

    # Data array that contains the input to the field.
    data::Vector{Char} = Char[]

    # Position of the physical cursor in the field.
    cury::Int  = 1
    curx::Int  = 1

    # Position of the virtual cursor in the data array.
    vcury::Int = 1
    vcurx::Int = 1

    # Index of the first character in the data vector to be printed.
    view::Int = 1
end

################################################################################
#                                     API
################################################################################

function accept_focus(widget::WidgetInputField)
    request_update(widget)
    return true
end

function create_widget(::Type{Val{:input_field}}, parent::WidgetParent;
                       kwargs...)

    # Positioning configuration.
    posconf = wpc(;kwargs...)

    # Initial processing of the position.
    _process_vertical_info!(posconf)
    _process_horizontal_info!(posconf)

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    if posconf.vertical == :unknown
        posconf.height = 1
    end

    if posconf.horizontal == :unknown
        posconf.width = 15
    end

    # Create the common parameters of the widget.
    common = create_widget_common(parent, posconf)

    # Create the widget.
    widget = WidgetInputField(common = common)

    # Add the new widget to the parent widget list.
    add_widget(parent, widget)

    @log info "create_widget" """
    A input field was created in $(obj_desc(parent)).
        Size        = ($(common.height), $(common.width))
        Coordinate  = ($(common.top), $(common.left))
        Positioning = ($(common.posconf.vertical),$(common.posconf.horizontal))
        Reference   = $(obj_to_ptr(widget))"""

    # Return the created widget.
    return widget
end

function process_focus(widget::WidgetInputField, k::Keystroke)
    # Handle the input.
    if _handle_input(widget, k)
        # Move the physical cursor to the correct position.
        #
        # NOTE: The initial position here starts at 1, but in NCurses it starts
        # in 0.
        wmove(widget.common.buffer, widget.cury-1, widget.curx-1)

        return true
    else
        return false
    end
end

function redraw(widget::WidgetInputField)
    @unpack common, view, data, cury, curx = widget
    @unpack buffer = common

    wclear(buffer)

    if length(data) == 0
        str = ""
    else
        str = String(@view data[view:end])
    end

    mvwprintw(buffer, 0, 0, str)

    return nothing
end

function release_focus(widget::WidgetInputField)
    request_update(widget)
    return true
end

require_cursor(widget::WidgetInputField) = true

################################################################################
#                              Private functions
################################################################################

function _handle_input(widget::WidgetInputField, k::Keystroke)
    @unpack common, data, view, curx, cury, vcury, vcurx = widget
    @unpack width = common

    # We do not support multiple lines yet.
    vcury  = 1
    cury   = 1

    # Number of spaces the virtual cursor must move.
    Δx     = 0

    # Flag to inform if the widget must be updated.
    update = false

    # Release focus.
    if k.ktype == :tab
        return false
    # Move cursor to the left.
    elseif k.ktype == :left
        Δx = -1
    # Move cursor to the right.
    elseif k.ktype == :right
        Δx = +1
    # Go to the beginning of the data.
    elseif k.ktype == :home
        Δx = -(vcurx-1)
    # Go to the end of the data.
    elseif k.ktype == :end
        Δx = length(data)-vcurx+1
    # Delete the previous character.
    elseif k.ktype == :backspace
        vcurx > 1 && deleteat!(data, vcurx-1)
        Δx = -1
        update = true
    # Delete the next character.
    elseif k.ktype == :delete
        vcurx ≤ length(data) && deleteat!(data, vcurx)
        update = true
    # Insert the character in the position of the virtual cursor.
    elseif k.ktype ∈ [:char, :utf8]
        if isempty(data)
            push!(data, k.value[1])
        else
            pos = clamp(vcurx, 1, length(data)+1)
            insert!(data, pos, k.value[1])
        end
        Δx = +1
        update = true
    # Unsupported key -- we do not pass the focus.
    else
        return true
    end

    # Update the position of the virtual cursor.
    vcurx = clamp(vcurx + Δx, 1, length(data)+1)

    # Check if we must change the view of the field.
    if Δx < 0
        # If the cursor is at the right edge and it was commanded to move it to
        # the left, then just move the view.
        if (curx == width) && (view > 1)
            view += Δx

            # If the view reached the most left position, then we must move the
            # cursor.
            curx += min(0, view-1)

            update = true
        elseif curx > 1
            curx += Δx
        end
    elseif Δx > 0
        curx += Δx

        # If the cursor is at the right edge, then just move the view.
        if curx > widget.common.width
            curx = widget.common.width
            view+width ≤ length(data)+1 && (view += Δx)
            update = true
        end
    end

    # The cursor position must not pass the data.
    curx = clamp(curx, 1, length(data)+1)

    # Make sure that view is in the acceptable interval.
    view = clamp(view, 1, max(1, length(data) - width + 2))

    # Request update if necessary.
    update && request_update(widget)

    # Repack values that were modified.
    @pack! widget = cury, curx, vcury, vcurx, view

    return true
end
