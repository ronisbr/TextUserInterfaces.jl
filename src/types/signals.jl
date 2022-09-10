# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Types related to signals.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

"""
    mutable struct Signal

Defines a signal.

# Fields

- `connection::Function`: The function that is called when the signal is
    emitted. It must have the following API: `f(obj; kwargs...)`, where `obj`
    is the object that generated the signal. `kwargs` are keyword with values
    native to the signal and also selected during the connection.
- `kwargs::NamedTuple`: Additional keyword arguments passed to the connection
    function together with those native to the signal.
"""
Base.@kwdef mutable struct Signal
    connection::Function = _NO_CONNECTION
    kwargs::NamedTuple = (;)
end
