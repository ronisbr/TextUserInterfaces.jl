# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains functions to handle signals.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export @connect_signal, @disconnect_signal, @emit_signal, @forward_signal

################################################################################
#                                    Macros
################################################################################

"""
    @connect_signal(obj, signal::Symbol, f::Symbol, vargs...)

Connect the signal `signal` of the object `obj` to the function `f` passing the
additional arguments `vargs`. Thus, when `signal` is emitted by `obj`, then
`fcall` will be executed.

"""
macro connect_signal(obj, signal::Symbol, f, vargs...)
    # Variable that stores the signal name.
    f_var = Symbol("on_", signal)

    # Variable that stores the signal input variables.
    vargs_var = Symbol("vargs_on_", signal)

    # Flag that stores if a signal is connected.
    conn_var = Symbol("conn_on_", signal)

    # Create and return the complete expression.
    ex = quote
        $obj.$f_var     = $f
        $obj.$vargs_var = ($(vargs...),)
        $obj.$conn_var  = true
    end

    return esc(ex)
end

"""
    @disconnect_signal(obj, signal::Symbol)

Disconnect the signal `signal` from object `obj`.

"""
macro disconnect_signal(obj, signal::Symbol)
    # Variable that stores the signal name.
    f_var = Symbol("on_", signal)

    # Variable that stores the signal input variables.
    vargs_var = Symbol("vargs_on_", signal)

    # Flag that stores if a signal is connected.
    conn_var = Symbol("conn_on_", signal)

    # Create and return the complete expression.
    ex = quote
        $obj.$f_var = ()->nothing
        $obj.$vargs_var = tuple()
        $obj.conn_var = false
    end

    return esc(ex)
end

"""
    @emit_signal(obj, signal::Symbol, params...)

Emit the signal `signal` of the object `obj` with the parameters `params...`,
causing to execute the connected function.

"""
macro emit_signal(obj, signal::Symbol, params...)
    # Variable that stores the signal name.
    f_var = Symbol("on_", signal)

    # Variable that stores the signal input variables.
    vargs_var = Symbol("vargs_on_", signal)

    # Flag that stores if a signal is connected.
    conn_var = Symbol("conn_on_", signal)

    # Create and return the complete expression.
    ex = quote
        if $obj.$conn_var
            $obj.$f_var($obj, $(params...), $obj.$vargs_var...)
        else
            nothing
        end
    end
    return esc(ex)
end

"""
    @forward_signal(src, dest, signal::Symbol)

Forward the signal `signal` from `src` to `dest`. This means that every time
that the signal `signal` is generated in `src`, then the function in `dest` will
be called.

"""
macro forward_signal(src, dest, signal::Symbol)
    # Variable that stores the signal name.
    f_var = Symbol("on_", signal)

    # Variable that stores the signal input variables.
    vargs_var = Symbol("vargs_on_", signal)

    # Flag that stores if a signal is connected.
    conn_var = Symbol("conn_on_", signal)

    ex = quote
        # TODO: Check if the destination signal is connected.
        $src.$f_var     = $dest.$f_var
        $src.$vargs_var = $dest.$vargs_var
        $src.$conn_var  = $dest.$conn_var
    end

    return esc(ex)
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
    c = Symbol("conn_on_", name)

    ex = quote
        $f::Function = (w)->nothing
        $v::Tuple = ()
        $c::Bool = false
    end

    return esc(ex)
end
