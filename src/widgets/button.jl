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
                       top::Union{Integer,Symbol} = 0,
                       left::Union{Integer,Symbol} = 0,
                       width::Number = 10,
                       hsize_policy::Symbol = :absolute,
                       label::AbstractString = "Button",
                       color::Int = 0,
                       color_highlight::Int = 0)

    # Create the common parameters of the widget.
    common = create_widget_common(parent, top, left, 1, width, :absolute,
                                  hsize_policy)

    # Create the widget.
    widget = WidgetButton(common          = common,
                          label           = label,
                          color           = color,
                          color_highlight = color_highlight)

    # Add to the parent window widget list.
    push!(parent.widgets, widget)

    @log info "create_widget" """
    A button was created in window $(parent.id).
        Size        = ($(common.height), $(common.width))
        Coordinate  = ($(common.top), $(common.left))
        Size policy = ($(common.vsize_policy), $(common.hsize_policy))
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
    @unpack common, label, color, color_highlight = widget
    @unpack buffer, parent = common

    wclear(buffer)

    # Get the background color depending on the focus.
    c = has_focus(parent, widget) ? color_highlight : color

    wattron(buffer, c)
    mvwprintw(buffer, 0, 0, "[ " * label * " ]")
    wattroff(buffer, c)

    return nothing
end

function release_focus(widget::WidgetButton)
    request_update(widget)
    return true
end
