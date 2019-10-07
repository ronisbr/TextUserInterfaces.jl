# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Description
#
#   Logger.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export @log, @log_ident, @reset_log_ident, log_message

################################################################################
#                                    Macros
################################################################################

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

Log the messagem `msg` with level `level` of the caller `id`

"""
macro log(level, msg, id)
    return quote
        local _level = $(esc(level))
        local _msg   = $(esc(msg))
        local _id    = $(esc(id))
        log_message(_level, _id, _msg)
    end
end

macro log_ident(ident)  return :( logger.pad = 4*$(esc(ident)) ) end
macro reset_log_ident() return :( logger.pad = 0 )   end

################################################################################
#                                  Functions
################################################################################

"""
    function log_message(level::Int, msg::AbstractString, id::AbstractString = "")

Log the message `msg` with level `level`. The ID of the called can be specified
by `id`.

"""
function log_message(level::LogLevels, msg::AbstractString, id::AbstractString = "")
    # Check if logging is enabled.
    !logger.enabled && return nothing

    # Check if the level is equal or below the desired logging level.
    Int(level) > Int(logger.level) && return nothing

    # Check if the file is opened. If not, then open.
    logger.file == nothing && (logger.file = open(logger.logfile, "w"))

    io = logger.file

    # Check if the user wants to add the ID.
    id_str = length(id) > 0 ? "[$id] " : ""

    # Check if the user wants the timestamp.
    time_str = logger.timestamp ? Dates.format(now(), "Y-mm-dd HH:MM:SS") * " │ " : ""
    time_pad = logger.timestamp ? " "^(length(time_str)-3) * " │ " : ""

    # Split the message by each line.
    lines = split(msg,'\n')

    output = ""

    @inbounds for i = 1:length(lines)
        output *= i == 1 ? time_str : time_pad
        output *= id_str * " "^logger.pad * lines[i] * "\n"
    end

    # Check if the resource is available.
    Threads.lock(logger.lock)
    print(io, output)
    Threads.unlock(logger.lock)

    return nothing
end
