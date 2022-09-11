# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains macros and functions related to signals.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export @connect, @disconnect, @emit, @signal

#                                    Macros
# ==============================================================================

"""
    @connect(object, signal::Symbol, f, kwargs)

Connect the function `f` to the `signal` in the `object`. `kwargs` must be a
named tuple with additional keyword arguments passed to `f` when the signal is
emitted.
"""
macro connect(object::Symbol, signal::Symbol, f, kwargs = (;))
    var = Symbol("_signal_", signal)

    ex = quote
        push!($object.$var.connections, $f)
        $object.$var.kwargs[$f] = $kwargs
    end

    return esc(ex)
end

"""
    @disconnect(object::Symbol, signal::Symbol, f)

Disconnect `f` from `signal` in `object`.
"""
macro disconnect(object::Symbol, signal::Symbol, f)
    var = Symbol("_signal_", signal)

    ex = quote
        id = findfirst(==($f), $object.$var.connections)
        !isnothing(id) && deleteat!($object.$var.connections, id)
        delete!($object.$var.kwargs, $f)
    end

    return esc(ex)
end

"""
    @emit([object, ]signal::Symbol, signal_kwargs)

Emit the `signal` in the `object` with the keyword arguments in the named tuple
`signal_kwargs`.
"""
macro emit(object::Symbol, signal::Symbol, signal_kwargs = (;))
    var = Symbol("_signal_", signal)

    ex = quote
        for f in $object.$var.connections
            kwargs = get($object.$var.kwargs, f, (;))
            f($object; $signal_kwargs..., kwargs...)
        end
    end

    return esc(ex)
end

"""
    @signal(name)

Create the signal named `name`. This must be used inside a structure that
supports `Base.@kwdef`.
"""
macro signal(name)
    var = Symbol("_signal_", name)
    ex = quote
        $var::Signal = Signal()
    end

    return esc(ex)
end
