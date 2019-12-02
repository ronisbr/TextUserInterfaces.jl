module TextUserInterfaces

using Dates
using LinearAlgebra
using Parameters

################################################################################
#                                  Submodules
################################################################################

include("submodules/NCurses/NCurses.jl")
using .NCurses
export NCurses

################################################################################
#                                    Types
################################################################################

include("./types/types.jl")

################################################################################
#                                   Includes
################################################################################

# Logger
# ==============================================================================

include("logger.jl")

# Other includes
# ==============================================================================

include("colors.jl")
include("focus_manager.jl")
include("forms.jl")
include("input.jl")
include("init_destruct.jl")
include("menus.jl")
include("misc.jl")
include("validators.jl")

# Windows
# ==============================================================================

include("./windows/create_destroy.jl")
include("./windows/container.jl")
include("./windows/focus.jl")
include("./windows/manage.jl")
include("./windows/misc.jl")
include("./windows/refresh_update.jl")

# Widgets
# ==============================================================================

include("./widgets/widgets.jl")
include("./widgets/anchors.jl")
include("./widgets/button.jl")
include("./widgets/labels.jl")
include("./widgets/input_field.jl")
include("./widgets/progress_bar.jl")

include("./widgets/container/container.jl")
include("./widgets/container/api.jl")

end # module
