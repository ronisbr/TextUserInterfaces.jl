# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Widget: Input field.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetInputField
export get_text

############################################################################################
#                                        Structure
############################################################################################

@widget mutable struct WidgetInputField
    # Data array that contains the input to the field.
    data::Vector{Char} = Char[]

    # Maximum allowed data size.
    max_data_size::Int = 0

    # Field usable width in screen.
    field_width::Int = 0

    # Cursor position in the data vector.
    cursor::Int = 1

    # Physical cursor position.
    phy_cursor_x::Int = 1
    phy_cursor_y::Int = 1

    # Beginning of the view expressed in text width.
    view_beginning::Int = 1

    # Rendered string.
    rendered_view::String = ""

    # Internal buffer to avoid output flickering when drawing.
    internal_buffer::Ptr{WINDOW} = Ptr{WINDOW}(0)

    # Style.
    style::Symbol = :simple

    # Validator.
    validator::Function = _INPUT_FIELD_DEFAULT_VALIDATOR
    is_valid::Bool = true

    # Signals
    # ======================================================================================

    @signal return_pressed
    @signal text_changed
end

# Conversion dictionary between style and height.
const _INPUT_FIELD_STYLE_HEIGHT = Dict(
    :boxed  => 3,
    :simple => 1,
    :none   => 1
)

# Conversion dictionary between style and the width margins.
const _INPUT_FIELD_STYLE_WIDTH_MARGINS = Dict(
    :boxed  => 2,
    :simple => 2,
    :none   => 0
)

_INPUT_FIELD_DEFAULT_VALIDATOR(str::String) = true

############################################################################################
#                                        Object API
############################################################################################

function destroy!(widget::WidgetInputField)
    @unpack internal_buffer = widget

    # We must destroy the internal buffer.
    if widget.internal_buffer !== Ptr{WINDOW}(0)
        delwin(internal_buffer)
        widget.internal_buffer = Ptr{WINDOW}(0)
    end

    # Call the general function to destroy a widget.
    return destroy_widget!(widget)
end

function update_layout!(widget::WidgetInputField; force::Bool = false)
    if update_widget_layout!(widget; force = force)
        @unpack internal_buffer, style = widget
        @unpack height, width = widget

        # Since the widget could have changed its size, we need to compute the usable size
        # to display the text.
        widget.field_width = width - _INPUT_FIELD_STYLE_WIDTH_MARGINS[style]

        # Update the rendered text and also the cursor position.
        _render_text_view_and_update_cursor_position!(widget)

        # Recreate the internal buffer considering the new size.
        internal_buffer !== Ptr{WINDOW}(0) && delwin(internal_buffer)
        internal_buffer = newwin(height, width, 0, 0)

        @pack! widget = internal_buffer

        return true
    else
        return false
    end
end

############################################################################################
#                                        Widget API
############################################################################################

can_accept_focus(::WidgetInputField) = true

function create_widget(
    ::Val{:input_field},
    layout::ObjectLayout;
    max_data_size::Int = 0,
    style::Symbol = :simple,
    validator::Function = _INPUT_FIELD_DEFAULT_VALIDATOR,
    theme::Theme = tui.default_theme
)
    # Check arguments.
    if !haskey(_INPUT_FIELD_STYLE_HEIGHT, style)
        @log WARNING "create_widget" """
        The input field style :$style is not known.
        The style :simple will be used."""
        style = :simple
    end

    # Create the widget.
    input_field = WidgetInputField(;
        id               = reserve_object_id(),
        layout           = layout,
        max_data_size    = max_data_size,
        style            = style,
        theme            = theme,
        validator        = validator,
        horizontal_hints = Dict(:width  => 30),
        vertical_hints   = Dict(:height => _INPUT_FIELD_STYLE_HEIGHT[style])
    )

    @log INFO "create_widget" """
    WidgetInputField created:
      ID             = $(input_field.id)
      Max. data size = $(max_data_size)
      Style          = $(style)"""

    # Return the created container.
    return input_field
end

function process_keystroke!(widget::WidgetInputField, k::Keystroke)
    # In this case, if we have a global command, we must not process the keystroke.
    cmd = check_global_command(k)
    isnothing(cmd) || return :keystorke_not_processed

    # If the keystroke is `enter`, just emit the signal.
    if k.ktype == :enter
        @log INFO "PROCESS" "RETURN"
        @emit widget return_pressed
        return :keystroke_processed

    # Handle the input.
    else
        text_changed = _handle_input!(widget, k)
        _render_text_view_and_update_cursor_position!(widget)

        text_changed && @emit widget text_changed

        # Update the cursor position.
        _update_cursor(widget)

        return :keystroke_processed
    end
end

function request_focus!(widget::WidgetInputField)
    # When accepting focus we must update the cursor position so that it can be positioned
    # in the position it was when the focus was released.
    _update_cursor(widget)
    request_update!(widget)
    return true
end

request_cursor(::WidgetInputField) = true

function redraw!(widget::WidgetInputField)
    @unpack buffer, data, height, internal_buffer, is_valid, field_width = widget
    @unpack style, theme, width = widget

    if internal_buffer === Ptr{WINDOW}(0)
        @log ERROR "redraw!" """
        Internal buffer of input field ($(widget.id)) was not created."""
        return nothing
    end

    # Check which color to apply to the widget
    c = is_valid ? theme.default : theme.error

    if has_focus(widget)
        c |= A_UNDERLINE
    end

    # Clear the internal buffer.
    wclear(internal_buffer)

    # String to clear the entire field.
    clear_str = " " ^ field_width

    if style == :simple
        mvwprintw(internal_buffer, 0, 0, "[")

        @ncolor c internal_buffer begin
            mvwprintw(internal_buffer, 0, 1, clear_str)
            mvwprintw(internal_buffer, 0, 1, widget.rendered_view)
        end

        mvwprintw(internal_buffer, 0, field_width + 1, "]")

    elseif style == :boxed
        @ncolor c internal_buffer begin
            mvwprintw(internal_buffer, 1, 1, clear_str)
            mvwprintw(internal_buffer, 1, 1, widget.rendered_view)
        end

        wborder(internal_buffer)
    else
        @ncolor c internal_buffer begin
            mvwprintw(internal_buffer, 0, 0, clear_str)
            mvwprintw(internal_buffer, 0, 0, widget.rendered_view)
        end
    end

    # Copy the internal buffer to the output buffer.
    copywin(internal_buffer, buffer, 0, 0, 0, 0, height - 1, width - 1, 0)

    # Update the cursor.
    _update_cursor(widget)

    return nothing
end

############################################################################################
#                                         Helpers
############################################################################################

@create_widget_helper input_field

############################################################################################
#                                     Public Functions
############################################################################################

"""
    get_text(widget::WidgetInputField) -> String

Return a string with the text in the field.
"""
function get_text(widget::WidgetInputField)
    return String(widget.data)
end

############################################################################################
#                                    Private Functions
############################################################################################

# Handle the input `k` to the input field `widget`.
function _handle_input!(widget::WidgetInputField, k::Keystroke)
    @unpack data, max_data_size, validator = widget
    @unpack cursor = widget

    # Number of characters in the data array.
    num_chars = length(data)

    # Get the action.
    action = _get_input_field_action(k)

    # Check if the text has changed.
    text_changed = false

    # Translate the action and update the field state.
    if action == :add_character
        # Check if we can add a new character.
        if (max_data_size <= 0) || (num_chars < max_data_size)
            c = k.value |> first
            insert!(data, cursor, c)
            cursor += 1
            text_changed = true
        end

    elseif action == :delete_forward_character
        if cursor <= num_chars
            deleteat!(data, cursor)
            text_changed = true
        end

    elseif action == :delete_previous_character
        if cursor > 1
            c = data[cursor - 1]
            deleteat!(data, cursor - 1)
            cursor -= 1
            text_changed = true
        end

    elseif action == :goto_beginning
        cursor = 1

    elseif action == :goto_end
        cursor = length(data) + 1

    elseif action == :move_cursor_to_left
        if cursor > 1
            cursor -= 1
        end

    elseif action == :move_cursor_to_right
        if cursor <= num_chars
            cursor += 1
        end
    end

    if text_changed
        is_valid = validator(String(data))
        @pack! widget = is_valid
    end

    (action !== :none) && request_update!(widget)

    @pack! widget = cursor

    return text_changed
end

# Obtain the action that the user wants by hitting the keystroke `k`.
function _get_input_field_action(k::Keystroke)
    action = :none

    if k.ktype == :left
        action = :move_cursor_to_left

    elseif k.ktype == :right
        action = :move_cursor_to_right

    elseif k.ktype == :home
        action = :goto_beginning

    elseif (k.ktype == :end)
        action = :goto_end

    elseif k.ktype == :backspace
        action = :delete_previous_character

    elseif k.ktype == :delete
        action = :delete_forward_character

    elseif (k.ktype == :char) || (k.ktype == :utf8)
        action = :add_character
    end

    return action
end

# Render the view text and also update the internal values that store the cursor position.
function _render_text_view_and_update_cursor_position!(widget::WidgetInputField)
    @unpack buffer, cursor, data, field_width, style, view_beginning = widget

    # Compute the string width up to the cursor.
    string_width = sum(textwidth.(data))
    string_width_before_cursor = sum(textwidth.(data[1:(cursor - 1)]))

    # Update the View
    # ======================================================================================

    # If the beginning of the view is after the cursor, we should move it to match the
    # cursor position.
    if string_width_before_cursor < (view_beginning - 1)
        view_beginning = string_width_before_cursor + 1

    # If the end of the view is before the cursor, we should move it to match the cursor
    # position. Notice that we always leave one space at the end in this case.
    elseif (view_beginning + field_width - 2) < string_width_before_cursor
        view_beginning = string_width_before_cursor - field_width + 2

    end

    # Make sure we only have one space at the end of the field if we are not at the
    # beginning of the view.
    if (view_beginning > 1) && (string_width < view_beginning + field_width - 2)
        view_beginning = string_width - field_width + 2
    end

    # If the cursor is at the end, we should add one space.
    if cursor > length(data)
        view_beginning = max(1, string_width_before_cursor - field_width + 2)
    end

    # Update the Physical Cursor Position
    # ======================================================================================

    # Move the physical cursor to the correct position considering the border if present.
    #
    # NOTE: The initial position here starts at 1, but in NCurses it starts in 0.

    if style == :simple
        widget.phy_cursor_x = string_width_before_cursor - view_beginning + 2
        widget.phy_cursor_y = 0
    elseif style == :boxed
        widget.phy_cursor_x = string_width_before_cursor - view_beginning + 2
        widget.phy_cursor_y = 1
    else
        widget.phy_cursor_x = string_width_before_cursor - view_beginning + 1
        widget.phy_cursor_y = 0
    end

    # Render the View
    # ======================================================================================

    current_str_width = 1
    processed_char = 0

    for c in data
        current_str_width >= view_beginning && break
        processed_char += 1
        current_str_width += textwidth(c)
    end

    rendered_view = " "^(current_str_width - view_beginning)

    current_view_width = current_str_width - view_beginning

    for i in (processed_char + 1):length(data)
        current_view_width += textwidth(data[i])
        current_view_width > field_width && break
        rendered_view *= data[i]
    end

    if (current_view_width - field_width) > 0
        rendered_view *= " "^(current_view_width - field_width)
    end

    @pack! widget = view_beginning, rendered_view

    return nothing
end

# Update the cursor in the view.
function _update_cursor(widget::WidgetInputField)
    wmove(widget.buffer, widget.phy_cursor_y, widget.phy_cursor_x)
    return nothing
end
