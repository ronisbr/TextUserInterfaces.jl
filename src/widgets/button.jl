# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Widget: Button.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetButton

################################################################################
#                                     Type
################################################################################

@with_kw mutable struct WidgetButton <: Widget

    # API
    # ==========================================================================
    common::WidgetCommon

    # Parameters related to the widget
    # ==========================================================================
    label::String
    color::Int
    color_highlight::Int
    style::Symbol

    # Signals
    # ==========================================================================
    on_return_pressed::Function = ()->return nothing
    vargs_on_return_pressed::Tuple = ()
end

################################################################################
#                                     API
################################################################################

function accept_focus(widget::WidgetButton)
    request_update(widget)
    return true
end

function create_widget(::Type{Val{:button}}, parent::WidgetParent;
                       label::AbstractString = "Button",
                       color::Int = 0,
                       color_highlight::Int = 0,
                       style::Symbol = :simple,
                       kwargs...)

    # Positioning configuration.
    posconf = wpc(;kwargs...)

    # Initial processing of the position.
    _process_vertical_info!(posconf)
    _process_horizontal_info!(posconf)

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    if posconf.vertical == :unknown
        posconf.height = style == :simple ? 1 : 3
    end

    if posconf.horizontal == :unknown
        posconf.width = length(label) + 4
    end

    # Create the common parameters of the widget.
    common = create_widget_common(parent, posconf)

    # Create the widget.
    widget = WidgetButton(common          = common,
                          label           = label,
                          color           = color,
                          color_highlight = color_highlight,
                          style           = style)

    # Add the new widget to the parent widget list.
    add_widget(parent, widget)

    @log info "create_widget" """
    A button was created in $(obj_desc(parent)).
        Size        = ($(common.height), $(common.width))
        Coordinate  = ($(common.top), $(common.left))
        Positioning = ($(common.posconf.vertical),$(common.posconf.horizontal))
        Label       = \"$label\"
        Reference   = $(obj_to_ptr(widget))"""

    # Return the created widget.
    return widget
end

function process_focus(widget::WidgetButton, k::Keystroke)
    if k.ktype == :tab
        return false
    elseif k.ktype == :enter
        @log verbose "change_value" "$(obj_desc(widget)): Enter pressed on focused button."
        widget.on_return_pressed(widget.vargs_on_return_pressed...)
    end

    return true
end

function redraw(widget::WidgetButton)
    wclear(widget.common.buffer)

    # Draw the button.
    _draw_button(widget)

    return nothing
end

function release_focus(widget::WidgetButton)
    request_update(widget)
    return true
end

################################################################################
#                              Private functions
################################################################################

function _draw_button(widget::WidgetButton)
    @unpack common, label, color, color_highlight, style = widget
    @unpack buffer, parent = common

    # Get the background color depending on the focus.
    c = has_focus(parent, widget) ? color_highlight : color

    # Center the label in the button.
    w   = common.width
    Δ   = w - 4 - length(label)
    pad = div(Δ,2)
    str = " "^pad * label * " "^(Δ - pad)

    if style == :complete
        mvwprintw(buffer, 0, 0, "┌" * "─"^(w-2) * "┐")
        mvwprintw(buffer, 1, 0, "│")

        wattron(buffer, c)
        wprintw(buffer, " " * str * " ")
        wattroff(buffer, c)

        wprintw(buffer, "│")
        mvwprintw(buffer, 2, 0, "└" * "─"^(w-2) * "┘")
    else
        wattron(buffer, c)
        mvwprintw(buffer, 0, 0, "[ " * str * " ]")
        wattroff(buffer, c)
    end

    return nothing
end
