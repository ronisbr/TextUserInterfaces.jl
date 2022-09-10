# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains macros and functions related to signals.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export @connect, @emit, @signal

#                                  Constants
# ==============================================================================

# Global constants related to signals.
_NO_CONNECTION = (obj; kwargs...) -> return nothing

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
        $object.$var.connection = $f
        $object.$var.kwargs = $kwargs
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
        $object.$var.connection($object; $signal_kwargs..., $object.$var.kwargs...)
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
