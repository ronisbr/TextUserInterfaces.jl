## Description #############################################################################
#
# Logger.
#
############################################################################################

export @log, @log_ident, @reset_log_ident, log_message

############################################################################################
#                                          Macros                                          #
############################################################################################

"""
    macro log(level, msg)

Log the message `msg` with level `level`.
"""
macro log(level, msg)
    return quote
        local _level = $(esc(level))
        local _msg   = $(esc(msg))
        log_message(_level, _msg, "")
    end
end

"""
    macro log(level, msg, id)

Log the message `msg` with level `level` of the caller `id`
"""
macro log(level, msg, id)
    return quote
        local _level = $(esc(level))
        local _msg   = $(esc(msg))
        local _id    = $(esc(id))
        log_message(_level, _id, _msg)
    end
end

macro log_ident(ident)  return :(logger.pad = 2 * $(esc(ident))) end
macro reset_log_ident() return :(logger.pad = 0)   end

############################################################################################
#                                        Functions                                         #
############################################################################################

"""
    log_message(level::Int, msg::String, id::String = "") -> Nothing

Log the message `msg` with level `level`. The ID of the called can be specified by `id`.

If a line is `@log_pad X`, then the following lines will have a padding of X.
"""
function log_message(level::Int, msg::String, id::String = "")
    # Check if logging is enabled and if the log file is opened.
    logger.enabled || return nothing
    isnothing(logger.file) && return nothing

    # Check if the level is equal or below the desired logging level.
    Int(level) > Int(logger.level) && return nothing

    io = logger.file

    # Check if the user wants to add the ID.
    id_str = length(id) > 0 ? "[$id] " : ""

    # Check if the user wants the timestamp.
    time_str = logger.timestamp ? Dates.format(now(), "Y-mm-dd HH:MM:SS") * " │ " : ""
    time_pad = logger.timestamp ? " "^(length(time_str) - 3) * " │ " : ""

    # Split the message by each line.
    lines = split(msg, '\n')

    output = ""

    Δ_pad = 0

    @inbounds for i in eachindex(lines)
        # Check if the line is a command to change the logging pad.
        aux = match(r"^@log_pad [0-9]+", lines[i])
        if aux !== nothing
            Δ_pad = parse(Int64, aux.match[10:end])
        else
            i_output  = ""
            i_output *= i == first(eachindex(lines)) ? time_str : time_pad
            i_output *= id_str * " "^(logger.pad + Δ_pad) * lines[i]
            output   *= rstrip(i_output) * "\n"
        end
    end

    # Check if the resource is available.
    Threads.lock(logger.lock)
    print(io, output)
    Threads.unlock(logger.lock)

    return nothing
end
