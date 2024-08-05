## Description #############################################################################
#
# Types related to signals.
#
############################################################################################

"""
    struct Signal

Defines a signal.

# Fields

- `connection::Function`: The function that is called when the signal is emitted. It must
    have the following API: `f(obj; kwargs...)`, where `obj` is the object that generated
    the signal. `kwargs` are keyword with values native to the signal and also selected
    during the connection.
- `kwargs::NamedTuple`: Additional keyword arguments passed to the connection function
    together with those native to the signal.
"""
@kwdef struct Signal
    connections::Vector{Function} = Function[]
    kwargs::Dict{Function, NamedTuple} = Dict{Function, NamedTuple}()
    properties::Dict{Symbol, Any} = Dict{Symbol, Any}()
end
