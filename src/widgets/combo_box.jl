## Description #############################################################################
#
# Widget: Combo Box.
#
############################################################################################

export WidgetComboBox
export get_item

############################################################################################
#                                        Structure                                         #
############################################################################################

@widget mutable struct WidgetComboBox
    # List box data.
    data::Vector{String}

    # Current selection.
    current_item::Int = 1

    # List box.
    list_box::Union{Nothing, WidgetListBox} = nothing

    # == Styling ===========================================================================

    icon::String  = "↓"
    show_icon::Bool = true

    # == Signals ===========================================================================

    @signal item_changed
end

############################################################################################
#                                        Object API                                        #
############################################################################################

############################################################################################
#                                        Widget API                                        #
############################################################################################

can_accept_focus(::WidgetComboBox) = true

function create_widget(
    ::Val{:combo_box},
    layout::ObjectLayout;
    data::Vector{String} = String[],
    icon::String  = "↓",
    show_icon::Bool = true,
    list_box_theme::Theme = tui.default_theme,
    theme::Theme = tui.default_theme
)
    width_hint   = maximum(textwidth.(data)) + (show_icon ? textwidth(icon) + 1 : 0)
    height_hint  = 1

    # Create the combo box.
    combo_box = WidgetComboBox(;
        id               = reserve_object_id(),
        layout           = layout,
        theme            = theme,
        data             = data,
        icon             = icon,
        show_icon        = show_icon,
        horizontal_hints = Dict(:width => width_hint),
        vertical_hints   = Dict(:height => height_hint)
    )

    @log DEBUG "create_widget" """
    WidgetComboBox created:
      ID                 = $(combo_box.id)
      Number of elements = $(length(data))"""

    # Create the list box.
    list_box_layout = ObjectLayout(
        top_anchor  = Anchor(combo_box, :bottom, 0),
        left_anchor = Anchor(combo_box, :left, 0),
        height      = 5
    )

    list_box = create_widget(
        Val(:list_box),
        list_box_layout;
        data       = data,
        selectable = false,
        theme      = list_box_theme
    )

    combo_box.list_box = list_box

    # Return the created widget.
    return combo_box
end

function process_keystroke!(widget::WidgetComboBox, k::Keystroke)
    # Let the container handle the tab key to change focus.
    k.ktype == :tab && return :keystroke_not_processed

    if k.ktype == :enter
        add_widget!(get_parent(widget), widget.list_box)
        move_focus_to_widget!(get_parent(widget), widget.list_box)

        list_box = widget.list_box

        @connect(list_box, esc_pressed,    _widget_combo_box__list_box_esc_pressed,    (; combo_box = widget))
        @connect(list_box, focus_lost,     _widget_combo_box__list_box_focus_lost,     (; combo_box = widget))
        @connect(list_box, return_pressed, _widget_combo_box__list_box_return_pressed, (; combo_box = widget))
    end

    return :keystroke_processed
end

function request_focus!(widget::WidgetComboBox)
    request_update!(widget)
    return true
end

request_cursor(::WidgetComboBox) = false

function redraw!(widget::WidgetComboBox)
    @unpack buffer, current_item, data, list_box, width, theme = widget
    @unpack icon, show_icon = widget

    NCurses.wclear(buffer)

    # Get the current selected item.
    current_item = clamp(current_item, 1, length(data))

    # We will highlight the combo box if it is selected or if list box is opened.
    list_box_opened = !isnothing(get_parent(list_box))
    color = (has_focus(widget) || list_box_opened) ? theme.highlight : theme.default

    # Get the string that will be printed.
    str = (show_icon ? "$icon " : "") * data[current_item]
    Δ = width - textwidth(str)
    pad = Δ > 0 ? " " ^ Δ : ""

    @ncolor color buffer begin
        NCurses.mvwprintw(buffer, 0, 0, str * pad)
    end

    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper combo_box

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    get_item(widget::WidgetComboBox) -> String

Return the selected item in the combo box `widget`.
"""
function get_item(widget::WidgetComboBox)
    return widget.data[widget.current_item]
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _widget_combo_box__close_list_box!(widget::Widget) -> Nothing

Close the list box of the combo box `widget`.
"""
function _widget_combo_box__close_list_box!(widget::Widget)
    # We must check if we are inside a container. If not, do nothing.
    parent = get_parent(widget)
    isnothing(parent) && return nothing
    remove_widget!(parent, widget)
    return nothing
end

"""
    _widget_combo_box__list_box_esc_pressed(widget::WidgetListBox; kwargs...) -> Nothing

Function executed when the signal `esc_pressed` is emitted in the list box.

# Keywords

- `combo_box::WidgetComboBox`: Combo box that contains the list box.
"""
function _widget_combo_box__list_box_esc_pressed(widget::WidgetListBox; combo_box::WidgetComboBox)
    _widget_combo_box__close_list_box!(widget)

    # We should disconnect all signals.
    @disconnect_all(widget, focus_lost)
    @disconnect_all(widget, return_pressed)

    # Move the focus to the combo box.
    move_focus_to_widget!(get_parent(combo_box), combo_box)

    return nothing
end

"""
    _widget_combo_box__list_box_focus_lost(widget::WidgetListBox; kwargs...) -> Return type

Function executed when the focus of the list box `widget` is lost.

# Keywords

- `combo_box::WidgetComboBox`: Combo box that contains the list box.
"""
function _widget_combo_box__list_box_focus_lost(widget::WidgetListBox; combo_box::WidgetComboBox)
    return _widget_combo_box__list_box_esc_pressed(widget; combo_box = combo_box)
end

"""
    _widget_combo_box__list_box_return_pressed(widget::WidgetListBox; kwargs...) -> Nothing

Function executed when the return is pressed in the list box `widget`.

# Keywords

- `combo_box::WidgetComboBox`: Combo box that contains the list box.
"""
function _widget_combo_box__list_box_return_pressed(
    widget::WidgetListBox;
    combo_box::WidgetComboBox,
)
    _widget_combo_box__list_box_esc_pressed(widget; combo_box = combo_box)

    list_box_selected_item = widget.current_item + 1

    if list_box_selected_item != combo_box.current_item
        combo_box.current_item = list_box_selected_item
        @emit combo_box item_changed
    end

    return nothing
end
