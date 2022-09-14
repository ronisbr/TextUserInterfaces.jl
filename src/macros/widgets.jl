# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains macros related to widgets.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export @widget

"""
    @widget(ex)

Declare a structure of a widget.
"""
macro widget(ex)
    # Expression must be a structure definition.
    if !(typeof(ex) <: Expr) || (ex.head != :struct)
        error("@widget must be used only with a structure definition.")
    end

    # Th structure supertype must be `Widget`.
    ex.args[2] = :($(ex.args[2]) <: Widget)

    # Then, we just need to add the required fields inside the arguments.
    push!(ex.args[3].args, [
        :(id::Int = 0)
        :(container::Union{Nothing, WidgetContainer} = nothing)
        :(window::Union{Nothing, Object} = nothing)
        :(buffer::Ptr{WINDOW} = Ptr{WINDOW}(0))

        # Configuration related to the size and position of the widget.
        :(layout::ObjectLayout)

        # Horizontal and vertical hints for the object layout.
        :(horizontal_hints::NamedTuple = (;))
        :(vertical_hints::NamedTuple = (;))

        # Current size and position of the widget.
        :(top::Int    = -1)
        :(left::Int   = -1)
        :(height::Int = -1)
        :(width::Int  = -1)

        # Widget theme.
        :(theme::Theme = tui.default_theme)

        # Mark if the widget needs to be update.
        :(update_needed::Bool = true)

        # Default signals.
        :(@signal focus_acquired)
        :(@signal focus_lost)
        :(@signal key_pressed)
    ]...)

    ret = quote
        @with_kw $ex
    end

    return esc(ret)
end
