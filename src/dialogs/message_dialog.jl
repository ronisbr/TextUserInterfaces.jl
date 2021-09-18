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

    if show_icon
        layout_icon = newlayout(top = 0, left = 0)
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
        elseif icon_type == :question
            icon_text = """
                            ╭─────────╮
                            │         │
                            │    ?    │
                            │         │
                            ╰─────────╯"""

            isnothing(icon_color) && (ic = ncurses_color(:blue, :black, A_BOLD))
        else
            icon_text = """
                            ╭─────────╮
                            │         │
                            │    I    │
                            │         │
                            ╰─────────╯"""

            isnothing(icon_color) && (ic = ncurses_color(:green, :black))
        end

        icon = create_widget(Val(:label), layout_icon;
                             color = ic,
                             text = icon_text)
    end

    anchor_left = show_icon ? Anchor(icon,    :right, 1) :
                              Anchor(:parent, :left,  0)

    anchor_top  = show_icon ? Anchor(icon,    :top, 1) :
                              Anchor(:parent, :top, 0)

    layout_msg = newlayout(anchor_top  = anchor_top,
                     anchor_left = anchor_left)

    text = create_widget(Val(:label), layout_msg; text = msg)

    # Function that create the widgets of the dialog.
    function f_widgets(c)
        show_icon && add_widget!(c, icon)
        add_widget!(c, text)
    end

    return create_dialog(f_widgets, buttons; kwargs...)
end
