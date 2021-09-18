# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Widget: Forms.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export WidgetForm, clear_daat!, get_data

################################################################################
#                                     Type
################################################################################

@composed_widget mutable struct WidgetForm
    labels::Vector{WidgetLabel}
    inputs::Vector{WidgetInputField}

    # Private
    # ==========================================================================

    # This vector reduces allocation when calling `get_data`.
    _data::Vector{Union{Nothing,String}}
end

################################################################################
#                                     API
################################################################################

# TODO: We must define those functions separately. Otherwise, if a `Union` is
# used, we get an ambiguity.
function add_widget!(container::WidgetContainer, widget::WidgetForm)
    return _add_widget_form!(container, widget)
end

add_widget!(win::Window, widget::WidgetForm) = _add_widget_form!(win, widget)

function create_widget(
    ::Val{:form},
    layout::ObjectLayout;
    borders::Bool = false,
    color_valid::Int = 0,
    color_invalid::Int = 0,
    field_size::Int = 40,
    labels::Vector{String} = String[],
    validators = nothing
)
    # Get the size of the largest label.
    lmax = maximum(length.(labels))

    # Get the number of fields.
    nfields = length(labels)

    # Check arguments.
    if typeof(validators) <: AbstractVector
        length(validators) != nfields &&
        error("`validators` must have the same length as the number of fields.")
    else
        validators = [validators for _ = 1:nfields]
    end

    # Check if all positioning is defined and, if not, try to help by
    # automatically defining the height and/or width.
    horizontal = _process_horizontal_info(layout)
    vertical   = _process_vertical_info(layout)

    if vertical == :unknown
        layout.height = borders ? 3nfields : nfields
    end

    if horizontal == :unknown
        layout.width = lmax + 1 + field_size
    end

    # Create the container.
    container = create_widget(Val(:container), layout)

    widget_labels = Vector{WidgetLabel}(undef, nfields)
    widget_inputs = Vector{WidgetInputField}(undef, nfields)

    for i = 1:length(labels)
        at  = i == 1 ? :parent : widget_inputs[i-1]
        ats = i == 1 ? :top    : :bottom

        layout = ObjectLayout(
            anchor_top   = Anchor(at, ats, 0),
            anchor_left  = Anchor(:parent, :left, lmax+1),
            anchor_right = Anchor(:parent, :right, 0)
        )

        wii = create_widget(
            Val(:input_field), layout;
            color_valid   = color_valid,
            color_invalid = color_invalid,
            border        = borders,
            validator     = validators[i]
        )

        layout = ObjectLayout(
            anchor_middle = Anchor(wii,     :middle, 0),
            anchor_left   = Anchor(:parent, :left,   0),
            width         = lmax
        )

        wli = create_widget(Val(:label), layout; text = labels[i])

        widget_labels[i] = wli
        widget_inputs[i] = wii
    end

    # Pre-allocate the vector that will store the data.
    _data = Vector{Union{Nothing, String}}(nothing, nfields)

    # Create the widget.
    widget = WidgetForm(
        container = container,
        labels    = widget_labels,
        inputs    = widget_inputs,
        _data     = _data
    )

    @log info "create_widget" """
    A form widget was created in $(obj_desc(parent)).
        Fields      = $labels
        Reference   = $(obj_to_ptr(widget))"""

    # Return the created widget.
    return widget
end

function process_keystroke(widget::WidgetForm, k::Keystroke)
    process_focus(widget.container, k)
end

# TODO: We must define those functions separately. Otherwise, if a `Union` is
# used, we get an ambiguity.
function remove_widget!(container::WidgetContainer, widget::WidgetForm)
    return _remove_widget_form!(container, widget)
end

remove_widget!(win::Window, widget::WidgetForm) = _remove_widget_form!(win, widget)

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

    return nothing
end

"""
    get_data(widget::WidgetInputField)

Return a vector with the data of all fields.
"""
function get_data(widget::WidgetForm)
    @unpack _data, inputs = widget

    @inbounds for i = 1:length(inputs)
        _data[i] = get_data(inputs[i])
    end

    return _data
end

################################################################################
#                              Private functions
################################################################################

# Function when the form is added to a parent.
function _add_widget_form!(
    parent::Union{Window, WidgetContainer},
    widget::WidgetForm
)
    add_widget!(parent, widget.container)

    # The labels have anchors that reference the inputs. Hence, the latter must
    # be added first.
    for i in widget.inputs
        add_widget!(widget.container, i)
    end

    for l in widget.labels
        add_widget!(widget.container, l)
    end

    return nothing
end

# Function when the form is removed from its parent.
function _remove_widget_form!(
    parent::Union{Window, WidgetContainer},
    widget::WidgetForm
)
    for l in widget.labels
        remove_widget!(widget.container, l)
    end

    for i in widget.inputs
        remove_widget(widget.container, i)
    end

    remove_widget!(parent, widget.container)

    return nothing
end

################################################################################
#                                   Helpers
################################################################################

@create_widget_helper form
