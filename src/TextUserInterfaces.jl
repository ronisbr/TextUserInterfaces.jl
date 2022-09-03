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

################################################################################
#                                   Includes
################################################################################

end # module
