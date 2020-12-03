# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Create a input dialog.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function create_dialog(::Val{:input_field},
                       msg::AbstractString;
                       # Input field options.
                       border::Bool = false,
                       color_valid::Int = 0,
                       color_invalid::Int = 0,
                       color_text::Int = 0,
                       max_data_size::Int = 0,
                       validator = nothing,
                       kwargs...)

    opc_msg = newopc(anchor_top  = Anchor(:parent, :top,  0),
                     anchor_left = Anchor(:parent, :left, 0))
    text = create_widget(Val(:label), opc_msg;
                         color = color_text,
                         text = msg)

    opc_input = newopc(anchor_top   = Anchor(text,    :bottom, 0),
                       anchor_left  = Anchor(text,    :left,   0),
                       anchor_right = Anchor(:parent, :right,  0))
    input = create_widget(Val(:input_field), opc_input;
                          border = true,
                          color_valid = color_valid,
                          color_invalid = color_invalid,
                          max_data_size = max_data_size,
                          validator = nothing)

    # Function that create the widgets of the dialog.
    function f_widgets(c)
        add_widget!(c, text)
        add_widget!(c, input)
    end

    ret = create_dialog(f_widgets, ["Cancel", "OK"]; kwargs...)
    text = ret == 2 ? get_data(input) : nothing

    return text
end
