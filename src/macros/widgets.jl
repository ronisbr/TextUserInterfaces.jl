# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains macros related to widgets.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export @create_widget_helper, @widget

const _list_layout_args = (
    :anchor_bottom,
    :anchor_left,
    :anchor_right,
    :anchor_top,
    :anchor_center,
    :anchor_middle,
    :top,
    :left,
    :height,
    :width
)

const _list_layout_anchors = (
    :anchor_bottom,
    :anchor_left,
    :anchor_right,
    :anchor_top,
    :anchor_center,
    :anchor_middle
)

"""
    @create_widget_helper(widget_symbol[, macro_name])

This macro defines a helper to create a widget of type `widget_symbol`. The
helper name is `macro_name`. If the latter is not available, then it will be
composed of the prefix `tui_` plus the `widget_symbol`.
"""
macro create_widget_helper(widget_symbol)
    macro_name = Symbol("tui_" * string(widget_symbol))
    return esc(:(@create_widget_helper $widget_symbol $macro_name))
end

macro create_widget_helper(widget_symbol, macro_name)
    mnq = Meta.quot(macro_name)
    wsq = Meta.quot(widget_symbol)

    expr = quote
"""
    @$($mnq)(args...)

This macro creates a widget of type `$($wsq)` using the arguments
`args...`.

`args` must be a set of expressions as follows:

    <parameter> = <value>

If the parameter `parent` is present, then the created widget will be added to
`parent`. Otherwise, the widget will be created and returned, but not added to
any parent.
"""
        macro $macro_name(args...)
            # List of expressions to be passed to the keyword as arguments.
            expr_kwargs = Expr[]

            # List of expressions to be passed to the creation of
            # `ObjectLayout`.
            expr_layout = Expr[]

            # List of expressions to connect signals.
            expr_signals = Expr[]

            # Variables to verify if the `parent` was defined. In this case, the
            # created widget will be added to it.
            has_parent = false
            parent = nothing

            ws = Meta.quot($wsq)

            for a in args
                # `a` must be an expression like `property = value`.
                if (a isa Expr) && (a.head === :(=))
                    if a.args[1] === :parent
                        has_parent = true
                        parent = a.args[2]

                    elseif a.args[1] ∈ _list_layout_args
                        # In this case, if the parameter is an anchor and value
                        # is a `Tuple`, we should convert to an `Anchor`.
                        if (a.args[1] ∈ _list_layout_anchors) &&
                            (a.args[2] isa Expr) &&
                            (a.args[2].head === :tuple)

                            v = :(Anchor($(a.args[2].args...)))
                        else
                            v = a.args[2]
                        end

                        push!(expr_layout, Expr(:kw, a.args[1], v))

                    elseif a.args[1] === :signal
                        # Those statements will be executed after the widget has
                        # been created. The widget variable name in the
                        # following code is `widget`.
                        push!(
                            expr_signals,
                            :(@connect(widget, $(a.args[2].args...)))
                        )

                    else
                        push!(expr_kwargs, Expr(:kw, a.args[1], a.args[2]))
                    end
                end
            end

            # Assemble the expression that will create the widget.
            if !has_parent
                create_widget_expr = quote
                    layout = ObjectLayout($(expr_layout...))
                    widget = create_widget(Val($ws), layout; $(expr_kwargs...))
                    $(expr_signals...)
                    widget
                end

            else
                create_widget_expr = quote
                    layout = ObjectLayout($(expr_layout...))
                    widget = create_widget(Val($ws), layout; $(expr_kwargs...))
                    add_widget!($parent, widget)
                    $(expr_signals...)
                    widget
                end
            end

            return esc(create_widget_expr)
        end
    end

    # Expression to export the macro.
    expr_export = Expr(:export, Symbol("@", macro_name))

    return Expr(:block, esc(expr), expr_export)
end

"""
    @widget(ex)

Declare a structure of a widget.
"""
macro widget(ex)
    # Expression must be a structure definition.
    if !(typeof(ex) <: Expr) || (ex.head !== :struct)
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
    ]...)

    ret = quote
        @with_kw $ex
    end

    return esc(ret)
end

