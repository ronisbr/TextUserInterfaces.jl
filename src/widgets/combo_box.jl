# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Widget: List box.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetComboBox, get_data, get_selected

################################################################################
#                                     Type
################################################################################

@widget mutable struct WidgetComboBox
    # Data to be selected.
    data::Vector{String}

    # Current selection.
    cur::Int = 1

    # Styling
    # ==========================================================================
    color::Int = 0
    color_highlight::Int = 0
    list_box_border::Bool = false
    list_box_color::Int = 0
    list_box_color_highlight::Int = 0
    style::Symbol = :simple

    # Private
    # ==========================================================================
    _list_box_opened::Bool = false
    _list_box::Union{Nothing,Widget} = nothing
end

################################################################################
#                                     API
################################################################################

function accept_focus(widget::WidgetComboBox)
    request_update!(widget)
    return true
end

function create_widget(
    ::Val{:combo_box},
    layout::ObjectLayout;
    data::Vector{String} = String[],
    color::Int = _color_default,
    color_highlight::Int = _color_highlight,
    list_box_border::Bool = false,
    list_box_color::Int = _color_default,
    list_box_color_highlight::Int = _color_highlight,
    style::Symbol = :simple
)

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    horizontal = _process_horizontal_info(layout)
    vertical   = _process_vertical_info(layout)

    if vertical == :unknown
        layout.height = style == :boxed ? 3 : 1
    end

    if horizontal == :unknown
        layout.width = maximum(length.(data)) + 5
    end

    # Create the widget.
    widget = WidgetComboBox(
        layout                   = layout,
        color                    = color,
        color_highlight          = color_highlight,
        list_box_border          = list_box_border,
        list_box_color           = list_box_color,
        list_box_color_highlight = list_box_color_highlight,
        data                     = data,
        style                    = style
    )

    # If a border is required, then create a container and add the list box
    # in this container.
    if list_box_border
        layout = ObjectLayout(
            anchor_top   = (widget, :bottom, 0),
            anchor_left  = (widget, :left,   0),
            anchor_right = (widget, :right,  0),
            height       = 5
        )

        con = create_widget(Val(:container), layout; border = true)

        layout = ObjectLayout(
            anchor_top    = Anchor(:parent, :top,    0),
            anchor_left   = Anchor(:parent, :left,   0),
            anchor_right  = Anchor(:parent, :right,  0),
            anchor_bottom = Anchor(:parent, :bottom, 0)
        )

        list_box = create_widget(
            Val(:list_box),
            layout;
            selectable      = false,
            data            = data,
            color           = list_box_color,
            color_highlight = list_box_color_highlight
        )

        add_widget!(con, list_box)

        widget._list_box = con
    else
        layout = ObjectLayout(
            anchor_top   = Anchor(widget, :bottom, 0),
            anchor_left  = Anchor(widget, :left,   0),
            anchor_right = Anchor(widget, :right,  0),
            height       = 5
        )

        list_box = create_widget(
            Val(:list_box),
            layout;
            selectable      = false,
            data            = data,
            color           = list_box_color,
            color_highlight = list_box_color_highlight
        )

        widget._list_box = list_box
    end

    @connect_signal widget key_pressed process_keystroke

    @log info "create_widget" """
    Combo box created:
        Reference   = $(obj_to_ptr(widget))
        Data length = $(length(data))"""

    # Return the created widget.
    return widget
end

function destroy_widget!(widget::WidgetComboBox; refresh::Bool = true)
    @unpack _list_box = widget
    # Destroy the list box and the widget.
    _list_box !== nothing && destroy_widget!(widget._list_box; refresh = false)
    _destroy_widget!(widget; refresh = refresh)
    return nothing
end

process_keystroke(widget::WidgetComboBox, k::Keystroke) = _handle_input!(widget, k)

function redraw(widget::WidgetComboBox)
    @unpack buffer, cur, data, parent, width = widget

    wclear(buffer)

    _draw_combo_box(widget)

    return nothing
end

function release_focus(widget::WidgetComboBox)
    request_update!(widget)
    return true
end

require_cursor(widget::WidgetComboBox) = false

################################################################################
#                              Private functions
################################################################################

function _draw_combo_box(widget::WidgetComboBox)
    @unpack parent, buffer, width, color, color_highlight, cur, data = widget
    @unpack style, _list_box_opened = widget

    # Get the background color depending on the focus.
    c = (has_focus(parent, widget) || _list_box_opened) ? color_highlight : color

    if style == :boxed
        w = width

        current = data[cur]
        Δ = width - 5 - length(current)
        str = Δ < 0 ? current[1:width-5] : current * " "^Δ

        mvwprintw(buffer, 0, 0, "┌" * "─"^(w - 2) * "┐")
        mvwprintw(buffer, 1, 0, "│")

        wattron(buffer, c)
        wprintw(buffer, " " * str * " ↓")
        wattroff(buffer, c)

        wprintw(buffer, "│")
        mvwprintw(buffer, 2, 0, "└" * "─"^(w - 2) * "┘")
    else
        current = data[cur]
        Δ = width - 2 - length(current)
        str = Δ < 0 ? current[1:width-2] : current * " "^Δ

        wattron(buffer, c)
        mvwprintw(buffer, 0, 0, str * " ↓")
        wattroff(buffer, c)
    end

    return nothing
end

function _handle_input!(widget::WidgetComboBox, k::Keystroke)
    @unpack data, parent, _list_box = widget

    # If `enter` is pressed, then create a list box that contains all the data,
    # pass the focus to it, and keep it there until `enter` is pressed again.
    if k.ktype == :enter
        # Mark that the list box is opened.
        widget._list_box_opened = true

        # Add the list box widget to the same container of the combo box.
        add_widget!(parent, _list_box)

        # Make the selected item in the list box equal to the current item of
        # the combo box.
        select_item!(_list_box, widget.cur)

        # Pass the focus to the newly created list box.
        request_focus!(parent, _list_box)

        @connect_signal _list_box return_pressed _handler_return_pressed! widget
        @connect_signal _list_box esc_pressed _handler_esc_pressed! widget
        @connect_signal _list_box focus_lost _handler_focus_lost! widget

        return true
    else
        # The user can also change the selection without opening the list box.
        #
        # Select previous value.

        Δx = 0

        if k.ktype == :up
            Δx = -1
            # Select next value.
        elseif k.ktype == :down
            Δx = +1
        elseif k.ktype == :pageup
            Δx = -5
        elseif k.ktype == :pagedown
            Δx = +5
        elseif k.ktype == :home
            Δx = -length(data)
        elseif k.ktype == :end
            Δx = +length(data)
        end

        # If no movement key was pressed, then just release the focus.
        if Δx != 0
            widget.cur = clamp(widget.cur + Δx, 1, length(data))
            request_update!(widget)
            return true
        else
            return false
        end
    end

    return false
end

# Signal handlers
# ==============================================================================

# Set the function called when a key is pressed inside the list box.
#
# If `return` is pressed, then this function need to update the combo box
# current item, destroy the created widgets, and return the focus to the combo
# box.
function _handler_return_pressed!(list_box::WidgetListBox, combo_box::WidgetComboBox)
    cur, ~ = get_current_item(list_box)
    combo_box.cur = cur
    combo_box._list_box_opened = false
    remove_widget!(combo_box.parent, list_box)
    request_focus!(combo_box.parent, combo_box)

    return nothing
end

# If `esc` is pressed, then this function just destroys the list box,
# ignoring the selection.
function _handler_esc_pressed!(list_box::WidgetListBox, combo_box::WidgetComboBox)
    combo_box._list_box_opened = false
    remove_widget!(combo_box.parent, list_box)
    request_focus!(combo_box.parent, combo_box)

    return nothing
end

# If the list box for any reason lost focus, then it must be closed.
function _handler_focus_lost!(list_box::WidgetListBox, combo_box::WidgetComboBox)
    if combo_box._list_box_opened
        combo_box._list_box_opened = false
        remove_widget!(combo_box.parent, list_box)
    end

    return nothing
end

################################################################################
#                                   Helpers
################################################################################

@create_widget_helper combo_box
