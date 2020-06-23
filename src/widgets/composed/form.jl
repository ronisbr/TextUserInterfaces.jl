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

@composed_widget mutable struct WidgetForm{I<:Tuple}
    inputs::I

    # Signals
    # ==========================================================================
    @signal return_pressed
end

################################################################################
#                                     API
################################################################################

function create_widget(::Val{:form},
                       parent::WidgetParent,
                       opc::ObjectPositioningConfiguration,
                       labels::Vector{String};
                       borders::Bool = false,
                       color_valid::Int = 0,
                       color_invalid::Int = 0,
                       field_size::Int = 40,
                       validator = nothing)

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

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    _process_horizontal_info!(opc)
    _process_vertical_info!(opc)

    if opc.vertical == :unknown
        opc.height = borders ? 3nfields : nfields
    end

    if opc.horizontal == :unknown
        opc.width = lmax + 1 + field_size
    end

    # Create the container.
    container = create_widget(Val(:container), parent, opc; composed = true)

    widget_labels = Vector{WidgetLabel}(undef, nfields)
    widget_inputs = Vector{WidgetInputField}(undef, nfields)

    for i = 1:length(labels)
        at  = i == 1 ? container : widget_inputs[i-1]
        ats = i == 1 ? :top : :bottom

        opc = newopc(anchor_top = Anchor(at, ats, 0),
                     anchor_left   = Anchor(container, :left, lmax+1),
                     anchor_right  = Anchor(container, :right, 0))
        wii = create_widget(Val(:input_field), container, opc;
                            color_valid   = color_valid,
                            color_invalid = color_invalid,
                            border        = borders,
                            validator     = validator[i])

        opc = newopc(anchor_middle = Anchor(wii, :middle, 0),
                     anchor_left   = Anchor(container, :left, 0),
                     width         = lmax)
        wli = create_widget(Val(:label), container, opc; text = labels[i])

        widget_labels[i] = wli
        widget_inputs[i] = wii
    end

    # Create the widget.
    widget = WidgetForm(container = container,
                        inputs    = tuple(widget_inputs...))

    # Add the new widget to the parent widget list.
    add_widget(parent, widget)

    @log info "create_widget" """
    A form widget was created in $(obj_desc(parent)).
        Size        = ($(container.height), $(container.width))
        Coordinate  = ($(container.top), $(container.left))
        Positioning = ($(container.opc.vertical),$(container.opc.horizontal))
        Fields      = $labels
        Reference   = $(obj_to_ptr(widget))"""

    # Return the created widget.
    return widget
end

function process_focus(widget::WidgetForm, k::Keystroke)
    if k.ktype == :enter
        @emit_signal widget return_pressed
    end

    process_focus(widget.container, k)
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
