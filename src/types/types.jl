# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains the definitions of types and structures.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

@with_kw mutable struct TextUserInterface
    initialized::Bool = false

    # Windows
    # ==========================================================================
    stdscr::Ptr{WINDOW} = Ptr{WINDOW}(0)
end

# Global instance to store the text user interface configurations.
const tui = TextUserInterface()

# Include of other files that define types
# ==============================================================================

include("./colors.jl")
include("./logger.jl")
