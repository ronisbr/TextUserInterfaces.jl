module TextUserInterfaces

using Dates
using FileWatching
using LinearAlgebra
using Parameters
using SnoopPrecompile

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
#                                    Macros
################################################################################

include("./macros/signals.jl")
include("./macros/colors.jl")
include("./macros/widgets.jl")

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
include("./focus.jl")
include("./initialization.jl")
include("./main_loop.jl")
include("./misc.jl")
include("./themes.jl")
include("./update.jl")

include("./input/keyboard.jl")
include("./input/keycodes.jl")

include("./objects/anchors.jl")
include("./objects/api.jl")

include("./widgets/button.jl")
include("./widgets/container.jl")
include("./widgets/input_field.jl")
include("./widgets/keystroke.jl")
include("./widgets/label.jl")
include("./widgets/object_api.jl")
include("./widgets/widgets.jl")

include("./windows/constants.jl")
include("./windows/create.jl")
include("./windows/destroy.jl")
include("./windows/misc.jl")
include("./windows/object_api.jl")
include("./windows/root_window.jl")
include("./windows/update.jl")
include("./windows/theme.jl")

################################################################################
#                               Global variables
################################################################################

export tui

# Global instance to store the text user interface configurations.
const tui = TextUserInterface()

# Global object to reference the root window.
export ROOT_WINDOW
const ROOT_WINDOW = RootWindow()

################################################################################
#                                Initialization
################################################################################

function __init__()
    load_ncurses()
end

################################################################################
#                                Precompilation
################################################################################

include("./precompilation.jl")

end # module
