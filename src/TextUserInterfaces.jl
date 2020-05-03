module TextUserInterfaces

using Dates
using LinearAlgebra
using Parameters

import Base: getproperty, setproperty!

################################################################################
#                                  Submodules
################################################################################

include("submodules/NCurses/NCurses.jl")
using .NCurses
export NCurses

include("./submodules/ParseANSIColors/ParseANSIColors.jl")
using .ParseANSIColors
export ParseANSIColors

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
include("input.jl")
include("init_destruct.jl")
include("menus.jl")
include("misc.jl")
include("signals.jl")
include("validators.jl")

# Objects
# ==============================================================================

include("./objects/api.jl")
include("./objects/anchors.jl")

# Windows
# ==============================================================================

include("./windows/create_destroy.jl")
include("./windows/container.jl")
include("./windows/focus.jl")
include("./windows/manage.jl")
include("./windows/misc.jl")
include("./windows/object_api.jl")
include("./windows/refresh_update.jl")
include("./windows/rootwin.jl")

# Widgets
# ==============================================================================

include("./widgets/widgets.jl")
include("./widgets/ansi_labels.jl")
include("./widgets/button.jl")
include("./widgets/composed_widgets.jl")
include("./widgets/combo_box.jl")
include("./widgets/labels.jl")
include("./widgets/list_box.jl")
include("./widgets/input_field.jl")
include("./widgets/object_api.jl")
include("./widgets/progress_bar.jl")

include("./widgets/container/container.jl")
include("./widgets/container/object_api.jl")
include("./widgets/container/api.jl")

include("./widgets/composed/form.jl")

end # module
