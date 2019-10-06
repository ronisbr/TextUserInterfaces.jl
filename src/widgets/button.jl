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
    parent::Window = nothing
    cwin::Ptr{WINDOW}  = Ptr{WINDOW}(0)
    update_needed::Bool = true

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

function create_widget(::Type{Val{:button}}, parent::Window,
                       begin_y::Integer, begin_x::Integer, ncols::Integer,
                       label::AbstractString, color::Int, color_highlight::Int)

    nlines = 1

    # Create the window that will hold the contents.
    cwin = subpad(parent.buffer, nlines, ncols, begin_y, begin_x)

    # Create the widget.
    widget = WidgetButton(parent = parent, cwin = cwin, label = label,
                          color = color, color_highlight = color_highlight)

    # Add to the parent window widget list.
    push!(parent.widgets, widget)

    @log info "create_widget" """
    A button was created in window $(parent.id).
        Size       = ($nlines, $ncols)
        Coordinate = ($begin_y, $begin_x)
        Label      = \"$label\""""

    # Return the created widget.
    return widget
end

function process_focus(widget::WidgetButton, k::Keystroke)
    if k.ktype == :tab
        return false
    elseif k.ktype == :enter
        widget.on_return_pressed(widget.vargs_on_return_pressed...)
    end

    return true
end

function redraw(widget::WidgetButton)
    @unpack cwin, color, label, color, color_highlight = widget
    wclear(cwin)

    # Get the background color depending on the focus.
    c = has_focus(widget.parent, widget) ? color_highlight : color

    wattron(cwin, c)
    mvwprintw(cwin, 0, 0, "[ " * label * " ]")
    wattroff(cwin, c)

    return nothing
end

function release_focus(widget::WidgetButton)
    request_update(widget)
    return true
end
