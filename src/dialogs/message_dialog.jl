# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Create a information dialog.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function create_dialog(::Val{:message},
                       msg::AbstractString,
                       buttons::AbstractVector{String} = ["OK"];
                       icon_color::Union{Nothing, Int} = nothing,
                       icon_type::Symbol = :info,
                       show_icon::Bool = true,
                       kwargs...)

    # Function that create the widgets of the dialog.
    function f_widgets(c)
        if show_icon
            opc_icon = newopc(top = 0, left = 0)
            ic = isnothing(icon_color) ? -1 : icon_color

            if icon_type == :error
                icon_text = """
                            ╭─────────╮
                            │         │
                            │  !!E!!  │
                            │         │
                            ╰─────────╯"""

                isnothing(icon_color) && (ic = ncurses_color(:red, :black, A_BOLD))

            elseif icon_type == :warning
                icon_text = """
                            ╭─────────╮
                            │         │
                            │   !W!   │
                            │         │
                            ╰─────────╯"""

                isnothing(icon_color) && (ic = ncurses_color(:yellow, :black))
            else
                icon_text = """
                            ╭─────────╮
                            │         │
                            │    I    │
                            │         │
                            ╰─────────╯"""

                isnothing(icon_color) && (ic = ncurses_color(:green, :black))
            end

            icon = create_widget(Val(:label), c, opc_icon;
                                 color = ic,
                                 text = icon_text)
        end

        anchor_left = show_icon ? Anchor(icon, :right, 1) :
                                  Anchor(c,    :left,  0)

        anchor_top  = show_icon ? Anchor(icon, :top, 1) :
                                  Anchor(c,    :top, 0)

        opc_msg = newopc(anchor_top  = anchor_top,
                         anchor_left = anchor_left)
        text = create_widget(Val(:label), c, opc_msg;
                             text = msg)
    end

    return create_dialog(f_widgets, buttons; kwargs...)
end
