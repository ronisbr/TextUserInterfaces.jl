# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Description
#
#   Types related to the logger.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export logger, critical, warning, info, verbose

@enum LogLevels begin
    critical = 0
    warning  = 1
    info     = 2
    verbose  = 3
end

@with_kw mutable struct Logger
    enabled::Bool = false
    level::Int = 0
    logfile::AbstractString = "./tui.log"
    timestamp::Bool = true

    # Internals
    # ==========================================================================
    file::Union{Nothing,IOStream} = nothing
    pad::Integer = 0
    lock::Threads.SpinLock = Threads.SpinLock()
end

# Global logger instance.
const logger = Logger()

