# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains functions to handle signals.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export @connect_signal, @disconnect_signal, @emit_signal

"""
    @connect_signal(obj::Symbol, signal::Symbol, fcall::Expr)

Connect the signal `signal` of the object `obj` to the function `fcall`. Notice
that `fcall` must be a function call with existing variables or literals. This
function **must not** have keywords. Thus, when `signal` is emitted by `obj`,
then `fcall` will be executed.

"""
macro connect_signal(obj::Symbol, signal::Symbol, fcall::Expr)
    # The expression must be a function call.
    (fcall.head != :call) &&
        error("""
              Error in @connect_signal.
              Usage:
                  @connect_signal object signal function(arg1, arg2, ...)
              """)

    # Get the function name.
    f = fcall.args[1]

    # The remaining arguments must be symbol.
    for i = 2:length(fcall.args)
        typeof(fcall.args[i]) <: Expr &&
            error("All arguments in the function call must be a variable or a literal. Expressions are not permitted.")
    end

    # Variable that stores the signal name.
    f_var = Symbol("on_", signal)

    # Variable that stores the signal input variables.
    vargs_var = Symbol("vargs_on_", signal)

    # Input variables.
    vargs = tuple(fcall.args[2:end]...)

    # Create and return the complete expression.
    ex = quote
        $obj.$f_var = $f
        $obj.$vargs_var = ($(vargs...),)
    end

    return esc(ex)
end

"""
    @disconnect_signal(obj::Symbol, signal::Symbol)

Disconnect the signal `signal` from object `obj`.

"""
macro disconnect_signal(obj::Symbol, signal::Symbol)
    # Variable that stores the signal name.
    f_var = Symbol("on_", signal)

    # Variable that stores the signal input variables.
    vargs_var = Symbol("vargs_on_", signal)

    # Create and return the complete expression.
    ex = quote
        $obj.$f_var = ()->nothing
        $obj.$vargs_var = tuple()
    end

    return esc(ex)
end

"""
    @emit_signal(obj::Symbol, signal::Symbol)

Emit the signal `signal` of the object `obj`, causing to execute the connected
function.

"""
macro emit_signal(obj::Symbol, signal::Symbol)
    # Variable that stores the signal name.
    f_var = Symbol("on_", signal)

    # Variable that stores the signal input variables.
    vargs_var = Symbol("vargs_on_", signal)

    # Create and return the complete expression.
    return esc(:($obj.$f_var($obj.$vargs_var...)))
end

"""
    @signal(name)

Create the signal named `name`. This must be used **inside** the widget
structure that must be declared with `@with_kw` option (see package
`Parameters.jl`).

"""
macro signal(name)
    f = Symbol("on_", name)
    v = Symbol("vargs_on_", name)

    ex = quote
        $f::Function = ()->nothing
        $v::Tuple = ()
    end

    return esc(ex)
end
