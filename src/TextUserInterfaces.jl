module TextUserInterfaces

using Dates
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
include("init_destruct.jl")
include("main_loop.jl")
include("misc.jl")
include("signals.jl")
include("update.jl")
include("validators.jl")

# Input
# ==============================================================================

include("./input/input.jl")

# Objects
# ==============================================================================

include("./objects/api.jl")
include("./objects/anchors.jl")

# Windows
# ==============================================================================

include("./windows/create.jl")
include("./windows/destroy.jl")
include("./windows/focus.jl")
include("./windows/manage.jl")
include("./windows/misc.jl")
include("./windows/object_api.jl")
include("./windows/refresh_update.jl")
include("./windows/rootwin.jl")

# Widgets
# ==============================================================================

include("./widgets/container/container.jl")
include("./widgets/container/object_api.jl")
include("./widgets/container/private.jl")

include("./widgets/widgets.jl")
include("./widgets/ansi_label.jl")
include("./widgets/button.jl")
include("./widgets/canvas.jl")
include("./widgets/composed_widgets.jl")
include("./widgets/combo_box.jl")
include("./widgets/label.jl")
include("./widgets/list_box.jl")
include("./widgets/input_field.jl")
include("./widgets/object_api.jl")
include("./widgets/progress_bar.jl")

include("./widgets/composed/form.jl")

# Dialogs
# ==============================================================================

include("./dialogs/base_dialog.jl")
include("./dialogs/input_dialog.jl")
include("./dialogs/message_dialog.jl")

# Precompile
# ==============================================================================

include("precompile_helpers.jl")
include("precompile.jl")

_precompile()

end # module
