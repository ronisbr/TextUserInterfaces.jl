# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains macros and functions related to signals.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export @connect, @disconnect, @disconnect_all, @emit, @signal

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
        let id
            id = findfirst(==($f), $object.$var.connections)
            !isnothing(id) && deleteat!($object.$var.connections, id)
            delete!($object.$var.kwargs, $f)
        end
    end

    return esc(ex)
end

"""
    @disconnect_all(object::Symbol, signal::Symbol)

Disconnect all connections of `signal` in `object`.
"""
macro disconnect_all(object::Symbol, signal::Symbol)
    var = Symbol("_signal_", signal)

    ex = quote
        empty!($object.$var.connections)
        empty!($object.$var.kwargs)
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

# Signal properties
# ------------------------------------------------------------------------------

export @delete_signal_property, @get_signal_property, @set_signal_property

"""
    @delete_signal_property(object::Symbol, signal::Symbol, property::Symbol)

Delete the `property` of `signal` in `object`, meaning that the default value
will be used.
"""
macro delete_signal_property(object::Symbol, signal::Symbol, property::Symbol)
    var = Symbol("_signal_", signal)
    p = Meta.quot(property)

    ex = quote
        delete!($object.$var.properties, $p)
    end

    return esc(ex)
end

"""
    @get_signal_property(object::Symbol, signal::Symbol, property::Symbol, default)

Get the `property` of the `signal` in `object`, returning the `default` value it
the property is not set.
"""
macro get_signal_property(object::Symbol, signal::Symbol, property::Symbol, default)
    var = Symbol("_signal_", signal)
    p = Meta.quot(property)

    ex = quote
        get($object.$var.properties, $p, $default)
    end

    return esc(ex)
end

"""
    @set_signal_property(object::Symbol, signal::Symbol, property::Symbol, value)

Set the `property` of the `signal` in `object` to `value`.
"""
macro set_signal_property(object::Symbol, signal::Symbol, property::Symbol, value)
    var = Symbol("_signal_", signal)
    p = Meta.quot(property)

    ex = quote
        $object.$var.properties[$p] = $value
    end

    return esc(ex)
end
