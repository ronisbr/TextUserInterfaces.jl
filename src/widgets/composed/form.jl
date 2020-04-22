# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Widget: Forms.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetForm, clear_daat!, get_data

################################################################################
#                                     Type
################################################################################

@with_kw mutable struct WidgetForm{I<:Tuple} <: ComposedWidget

    # API
    # ==========================================================================
    common::WidgetCommon
    container::WidgetContainer

    # Derived widgets
    # ==========================================================================
    inputs::I
end

################################################################################
#                                     API
################################################################################

function create_widget(::Val{:form}, parent::WidgetParent,
                       labels::Vector{String}; borders::Bool = false,
                       color_valid::Int = 0,
                       color_invalid::Int = 0,
                       field_size::Int = 40,
                       validator = nothing,
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

    # Get the size of the largest label.
    lmax = maximum(length.(labels))

    # Get the number of fields.
    nfields = length(labels)

    # Check arguments.
    if typeof(validator) <: AbstractVector
        length(validator) != nfields &&
        error("`validator` must have the same length as the number of fields.")
    else
        validator = [validator for _ = 1:nfields]
    end

    # Compute the positioning configuration.
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
        opc.height = borders ? 3nfields : nfields
    end

    if opc.horizontal == :unknown
        opc.width = lmax + 1 + field_size
    end

    # Create the container.
    container = create_widget(Val(:container), parent; opc = opc,
                              composed = true)

    widget_labels = Vector{WidgetLabel}(undef, nfields)
    widget_inputs = Vector{WidgetInputField}(undef, nfields)

    for i = 1:length(labels)
        at  = i == 1 ? container : widget_inputs[i-1]
        ats = i == 1 ? :top : :bottom

        wii = create_widget(Val(:input_field), container,
                            anchor_top    = (at, ats, 0),
                            anchor_left   = (container, :left, lmax+1),
                            anchor_right  = (container, :right, 0),
                            color_valid   = color_valid,
                            color_invalid = color_invalid,
                            border        = borders,
                            validator     = validator[i])

        wli = create_widget(Val(:label), container,
                            anchor_middle = (wii, :middle, 0),
                            anchor_left   = (container, :left, 0),
                            width         = lmax,
                            text          = labels[i])

        widget_labels[i] = wli
        widget_inputs[i] = wii
    end

    # Create the widget.
    widget = WidgetForm(common    = container.common,
                        container = container,
                        inputs    = tuple(widget_inputs...))

    # Add the new widget to the parent widget list.
    add_widget(parent, widget)

    @log info "create_widget" """
    A form widget was created in $(obj_desc(parent)).
        Size        = ($(container.common.height), $(container.common.width))
        Coordinate  = ($(container.common.top), $(container.common.left))
        Positioning = ($(container.common.opc.vertical),$(container.common.opc.horizontal))
        Fields      = $labels
        Reference   = $(obj_to_ptr(widget))"""

    # Return the created widget.
    return widget
end

################################################################################
#                           Custom widget functions
################################################################################

"""
    clear_data!(widget::WidgetForm)

Clear the data in all the input fields in the form `widget`.

"""
function clear_data!(widget::WidgetForm)
    clear_data!.(widget.inputs)
    request_update(widget)
end

"""
    get_data(widget::WidgetInputField)

Return a vector with the data of all fields.

"""
get_data(widget::WidgetForm) = map(get_data,widget.inputs)
