module TextUserInterfaces

using Dates
using FileWatching
using LinearAlgebra
using Parameters

import Base: getproperty, setproperty!

# The performance of TextUserInterfaces.jl does not increase by a lot of
# optimizations that is performed by the compiler. Hence, we disable then to
# improve compile time.
if isdefined(Base, :Experimental) && isdefined(Base.Experimental, Symbol("@optlevel"))
    @eval Base.Experimental.@optlevel 1
end

################################################################################
#                                  Submodules
################################################################################

include("submodules/NCurses/NCurses.jl")
using .NCurses
export NCurses

include("./submodules/ParseAnsiColors/ParseAnsiColors.jl")
using .ParseAnsiColors
export ParseAnsiColors

################################################################################
#                                    Types
################################################################################

include("./types/types.jl")

################################################################################
#                                   Includes
################################################################################

include("./logger.jl")

include("./colors.jl")
include("./destruction.jl")
include("./initialization.jl")
include("./misc.jl")

include("./objects/anchors.jl")
include("./objects/api.jl")

include("./windows/create.jl")
include("./windows/destroy.jl")
include("./windows/object_api.jl")
include("./windows/root_window.jl")

################################################################################
#                               Global variables
################################################################################

# Global instance to store the text user interface configurations.
const tui = TextUserInterface()

# Global object to reference the root window.
export ROOT_WINDOW
const ROOT_WINDOW = RootWindow()

end # module
