# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Widget: Forms.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetForm, get_data

################################################################################
#                                     Type
################################################################################

@with_kw mutable struct WidgetForm{T<:WidgetParent} <: ComposedWidget

    # API
    # ==========================================================================
    common::WidgetCommon{T}
    container::WidgetContainer{T}

    # Derived widgets
    # ==========================================================================
    inputs::Vector{WidgetInputField}
end

################################################################################
#                                     API
################################################################################

function create_widget(::Type{Val{:form}}, parent::WidgetParent,
                       labels::Vector{String}; borders::Bool = false,
                       color_valid::Int = 0,
                       color_invalid::Int = 0,
                       field_size::Int = 40,
                       validator = nothing,
                       kwargs...)

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
    opc = object_positioning_conf(; kwargs...)

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    if opc.vertical == :unknown
        opc.height = borders ? 3nfields : nfields
    end

    if opc.horizontal == :unknown
        opc.width = lmax + 1 + field_size
    end

    # Create the container.
    container = create_widget(Val{:container}, parent; opc = opc,
                              composed = true)

    widget_labels = Vector{WidgetLabel}(undef, nfields)
    widget_inputs = Vector{WidgetInputField}(undef, nfields)

    for i = 1:length(labels)
        at  = i == 1 ? container : widget_inputs[i-1]
        ats = i == 1 ? :top : :bottom

        wii = create_widget(Val{:input_field}, container,
                            anchor_top    = (at, ats, 0),
                            anchor_left   = (container, :left, lmax+1),
                            color_valid   = color_valid,
                            color_invalid = color_invalid,
                            border        = borders,
                            validator     = validator[i],
                            width         = field_size)

        wli = create_widget(Val{:label}, container,
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
                        inputs    = widget_inputs)

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
    function get_data(widget::WidgetInputField)

Return a vector with the data of all fields.

"""
get_data(widget::WidgetForm) = get_data.(widget.inputs)
