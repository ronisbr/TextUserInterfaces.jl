## Description #############################################################################
#
# Types related to the logger.
#
############################################################################################

export logger, CRITICAL, WARNING, DEBUG

const CRITICAL = 0
const WARNING  = 1
const DEBUG    = 2

"""
    mutable struct Logger

Structure that defines the logger.

# Fields

- `enabled::Bool`: If `true`, the logger is enabled.
    (**Default** = `false`)
- `level::Int`: Logging level (`CRITICAL`, `WARNING`, `DEBUG`).
    (**Default** = `CRITICAL`)
- `logfile::String`: Path to the log file.
    (**Default** = `"./tui.log"`)
- `timestamp::Bool`: If `true`, then add timestamp to each log entry.
    (**Default** = `true`)
- `file::Union{Nothing, IOStream}`: File stream related to the log file.
    (**Default** = `nothing`)
- `pad::Int`: Padding related to the log level.
    (**Default** = `0`)
- `lock::Threads.ReentrantLock`: Lock to avoid race conditions when logging from multiple
    threads.
"""
@kwdef mutable struct Logger
    enabled::Bool = false
    level::Int = CRITICAL
    logfile::String = "./tui.log"
    timestamp::Bool = true

    # == Internals =========================================================================

    file::Union{Nothing, IOStream} = nothing
    pad::Int = 0
    lock::Threads.ReentrantLock = Threads.ReentrantLock()
end

# Global logger instance.
const logger = Logger()
