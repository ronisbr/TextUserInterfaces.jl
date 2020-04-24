# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Widget: List box.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetComboBox, get_data, get_selected

################################################################################
#                                     Type
################################################################################

@with_kw mutable struct WidgetComboBox <: Widget

    # API
    # ==========================================================================
    common::WidgetCommon

    # Parameters related to the widget
    # ==========================================================================

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
    request_update(widget)
    return true
end

function create_widget(::Val{:combo_box}, parent::WidgetParent;
                       data::Vector{String} = String[],
                       color::Int = 0,
                       color_highlight::Int = 0,
                       list_box_border::Bool = false,
                       list_box_color::Int = 0,
                       list_box_color_highlight::Int = 0,
                       style::Symbol = :simple,
                       # Keywords related to the object positioning.
                       anchor_bottom::AnchorTuple = nothing,
                       anchor_left::AnchorTuple   = nothing,
                       anchor_right::AnchorTuple  = nothing,
                       anchor_top::AnchorTuple    = nothing,
                       anchor_center::AnchorTuple = nothing,
                       anchor_middle::AnchorTuple = nothing,
                       top::Int    = -1,
                       left::Int   = -1,
                       height::Int = -1,
                       width::Int  = -1)

    # Positioning configuration.
    opc = object_positioning_conf(anchor_bottom = anchor_bottom,
                                  anchor_left   = anchor_left,
                                  anchor_right  = anchor_right,
                                  anchor_top    = anchor_top,
                                  anchor_center = anchor_center,
                                  anchor_middle = anchor_middle,
                                  top           = top,
                                  left          = left,
                                  height        = height,
                                  width         = width)

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    if opc.vertical == :unknown
        opc.height = style == :boxed ? 3 : 1
    end

    if opc.horizontal == :unknown
        opc.width = maximum(length.(data)) + 5
    end

    # Create the common parameters of the widget.
    common = create_widget_common(parent, opc)

    # Create the widget.
    widget = WidgetComboBox(common                   = common,
                            color                    = color,
                            color_highlight          = color_highlight,
                            list_box_border          = list_box_border,
                            list_box_color           = list_box_color,
                            list_box_color_highlight = list_box_color_highlight,
                            data                     = data,
                            style                    = style)

    # If a border is required, then create a container and add the list box
    # in this container.
    if list_box_border
        con = create_widget(Val(:container), parent, border = true,
                            anchor_top   = (widget, :bottom, 0),
                            anchor_left  = (widget, :left,   0),
                            anchor_right = (widget, :right,  0),
                            height       = 5)

        list_box = create_widget(Val(:list_box), con,
                                 selectable      = false,
                                 retain_focus    = true,
                                 data            = data,
                                 color           = list_box_color,
                                 color_highlight = list_box_color_highlight,
                                 anchor_top      = (con, :top, 0),
                                 anchor_left     = (con, :left,   0),
                                 anchor_right    = (con, :right,  0),
                                 anchor_bottom   = (con, :bottom,  0))

        widget._list_box = con
    else
        list_box = create_widget(Val(:list_box), parent,
                                 selectable      = false,
                                 retain_focus    = true,
                                 data            = data,
                                 color           = list_box_color,
                                 color_highlight = list_box_color_highlight,
                                 anchor_top      = (widget, :bottom, 0),
                                 anchor_left     = (widget, :left,   0),
                                 anchor_right    = (widget, :right,  0),
                                 height          = 5)

        widget._list_box = list_box
    end

    # Add the new widget to the parent widget list.
    add_widget(parent, widget)

    @log info "create_widget" """
    A combo box was created in $(obj_desc(parent)).
        Size           = ($(common.height), $(common.width))
        Coordinate     = ($(common.top), $(common.left))
        Data length    = $(length(data))
        Positioning    = ($(common.opc.vertical),$(common.opc.horizontal))
        Reference      = $(obj_to_ptr(widget))"""

    # Return the created widget.
    return widget
end

function destroy_widget(widget::WidgetComboBox; refresh::Bool = true)
    @unpack _list_box = widget
    # Destroy the list box and the widget.
    (_list_box != nothing) && destroy_widget(widget._list_box; refresh = false)
    _destroy_widget(widget; refresh = refresh)
    return nothing
end

function process_focus(widget::WidgetComboBox, k::Keystroke)
    return _handle_input(widget, k)
end

function redraw(widget::WidgetComboBox)
    @unpack common, cur, data = widget
    @unpack parent, buffer, width = common

    wclear(buffer)

    _draw_combo_box(widget)

    return nothing
end

function release_focus(widget::WidgetComboBox)
    request_update(widget)
    return true
end

require_cursor(widget::WidgetComboBox) = false

################################################################################
#                           Custom widget functions
################################################################################

################################################################################
#                              Private functions
################################################################################

function _draw_combo_box(widget::WidgetComboBox)
    @unpack common, color, color_highlight, cur, data, style,
            _list_box_opened = widget
    @unpack parent, buffer, width = common

    # Get the background color depending on the focus.
    c = (has_focus(parent, widget) || _list_box_opened) ? color_highlight : color

    if style == :boxed
        w = common.width

        current = data[cur]
        Δ = width - 5 - length(current)
        str = Δ < 0 ? current[1:width-5] : current * " "^Δ

        mvwprintw(buffer, 0, 0, "┌" * "─"^(w-2) * "┐")
        mvwprintw(buffer, 1, 0, "│")

        wattron(buffer, c)
        wprintw(buffer, " " * str * " ↓")
        wattroff(buffer, c)

        wprintw(buffer, "│")
        mvwprintw(buffer, 2, 0, "└" * "─"^(w-2) * "┘")
    else
        current = data[cur]
        Δ = width - 2 - length(current)
        str = Δ < 0 ? current[1:width-2] : current * " "^Δ

        wattron(buffer, c)
        mvwprintw(buffer, 0, 0, str * " ↓")
        wattroff(buffer, c)
    end
end

function _handle_input(widget::WidgetComboBox, k::Keystroke)
    @unpack common, data, _list_box = widget
    @unpack parent = common

    # If `enter` is pressed, then create a list box that contains all the data,
    # pass the focus to it, and keep it there until `enter` is pressed again.
    if k.ktype == :enter

        # Correct the positioning of the list box.
        reposition!(_list_box)

        # Add the list box widget to the same container of the combo box.
        add_widget(parent, _list_box)

        # Make the selected item in the list box equal to the current item of
        # the comnbo box.
        select_item(_list_box, widget.cur)

        # Pass the focus to the newly created list box.
        request_focus(parent, _list_box)

        # Set the function called when `enter` is pressed inside the list box.
        # This function need to update the combo box current item, destroy the
        # created widgets, and return the focus to the combo box.
        f_return() = begin
            cur, ~ = get_current_item(_list_box)
            widget.cur = cur
            remove_widget(parent, _list_box)
            request_focus(parent, widget)
        end
        @connect_signal _list_box return_pressed f_return()

        # Set the function called when `ESC` is pressed inside the list box.
        # This function just destroys the list box, ignoring the selection.
        f_esc() = begin
            remove_widget(parent, _list_box)
            request_focus(parent, widget)
        end
        @connect_signal _list_box esc_pressed f_esc()

        return true
    else
        return false
    end
end
