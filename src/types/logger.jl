# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Types related to the logger.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export logger, CRITICAL, WARNING, INFO, VERBOSE

const CRITICAL = 0
const WARNING  = 1
const INFO     = 2
const VERBOSE  = 3

@with_kw mutable struct Logger
    enabled::Bool = false
    level::Int = CRITICAL
    logfile::String = "./tui.log"
    timestamp::Bool = true

    # Internals
    # ==========================================================================
    file::Union{Nothing, IOStream} = nothing
    pad::Int = 0
    lock::Threads.SpinLock = Threads.SpinLock()
end

# Global logger instance.
const logger = Logger()
