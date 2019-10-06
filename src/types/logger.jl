# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Description
#
#   Types related to the logger.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

@with_kw mutable struct Logger
    enabled::Bool = false
    level::Int = 0
    logfile::AbstractString = "./tui.log"
end

# Global logger instance.
const logger = Logger()

