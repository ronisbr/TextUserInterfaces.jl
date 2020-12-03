# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Types related to widgets.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export Widget, WidgetCommon, WidgetParent
export @widget, @composed_widget

# Types that can be parent of widgets.
WidgetParent = Union{Nothing, RootWin, Window, Widget}

################################################################################
#                                   Widgets
################################################################################

"""
    @widget(ex)

Declare a structure of a widget.

"""
macro widget(ex)

    # Expression must be a structure definition.
    @assert((typeof(ex) <: Expr) && (ex.head == :struct),
            "@widget must be used only with a structure definition.")

    # Th structure supertype must be `Widget`.
    ex.args[2] = :($(ex.args[2]) <: Widget)

    # Then, we just need to add the required fields inside the arguments.
    push!(ex.args[3].args, [
        :(parent::WidgetParent = nothing)
        :(buffer::Ptr{WINDOW} = Ptr{WINDOW}(0))

        # Configuration related to the size and position of the widget.
        :(opc::ObjectPositioningConfiguration)

        # Current size and position of the widget.
        :(top::Int    = -1)
        :(left::Int   = -1)
        :(height::Int = -1)
        :(width::Int  = -1)

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

################################################################################
#                               Composed widgets
################################################################################

"""
    @composed_widget(ex)

Declare a structure of a composed widget.

"""
macro composed_widget(ex)

    # Expression must be a structure definition.
    @assert((typeof(ex) <: Expr) && (ex.head == :struct),
            "@composed_widget must be used only with a structure definition.")

    # Th structure supertype must be `Widget`.
    ex.args[2] = :($(ex.args[2]) <: ComposedWidget)

    # Then, we just need to add the required fields inside the arguments.
    push!(ex.args[3].args, [
        # Container that holds the widgets.
        :(container::WidgetContainer)

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

# In the case of composed widgets, the access to all fields must be transferred
# to those of the container.
function getproperty(a::ComposedWidget, f::Symbol)
    if f == :parent
        return a.container.parent
    elseif f == :buffer
        return a.container.buffer
    elseif f == :opc
        return a.container.opc
    elseif f == :top
        return a.container.top
    elseif f == :left
        return a.container.left
    elseif f == :height
        return a.container.height
    elseif f == :width
        return a.container.width
    elseif f == :update_needed
        return a.container.update_needed
    else
        return getfield(a, f)
    end
end

function setproperty!(a::ComposedWidget, f::Symbol, v)
    if f == :parent
        return (a.container.parent = v)
    elseif f == :buffer
        return (a.container.buffer = v)
    elseif f == :opc
        return (a.container.opc = v)
    elseif f == :top
        return (a.container.top = v)
    elseif f == :left
        return (a.container.left = v)
    elseif f == :height
        return (a.container.height = v)
    elseif f == :width
        return (a.container.width = v)
    elseif f == :update_needed
        return (a.container.update_needed = v)
    else
        return setfield!(a, f, v)
    end
end

################################################################################
#                               Derived widgets
################################################################################

"""
    @derived_widget(ex)

Declare a structure of a derived widget.

"""
macro derived_widget(ex)

    # Expression must be a structure definition.
    @assert((typeof(ex) <: Expr) && (ex.head == :struct),
            "@widget must be used only with a structure definition.")

    # Th structure supertype must be `Widget`.
    ex.args[2] = :($(ex.args[2]) <: DerivedWidget)

    # Then, we just need to add the required fields inside the arguments.
    push!(ex.args[3].args, [
        # Widget that is the base of the derived widget.
        :(base::Widget)

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

# In the case of derived widgets, the access to all fields must be transferred
# to those of the base widget.
function getproperty(a::DerivedWidget, f::Symbol)
    if f == :parent
        return a.base.parent
    elseif f == :buffer
        return a.base.buffer
    elseif f == :opc
        return a.base.opc
    elseif f == :top
        return a.base.top
    elseif f == :left
        return a.base.left
    elseif f == :height
        return a.base.height
    elseif f == :width
        return a.base.width
    elseif f == :update_needed
        return a.base.update_needed
    else
        return getfield(a, f)
    end
end

function setproperty!(a::DerivedWidget, f::Symbol, v)
    if f == :parent
        return (a.base.parent = v)
    elseif f == :buffer
        return (a.base.buffer = v)
    elseif f == :opc
        return (a.base.opc = v)
    elseif f == :top
        return (a.base.top = v)
    elseif f == :left
        return (a.base.left = v)
    elseif f == :height
        return (a.base.height = v)
    elseif f == :width
        return (a.base.width = v)
    elseif f == :update_needed
        return (a.base.update_needed = v)
    else
        return setfield!(a, f, v)
    end
end
