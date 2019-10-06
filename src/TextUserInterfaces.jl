module TextUserInterfaces

using Dates
using Libdl
using LinearAlgebra
using Parameters

################################################################################
#                                    Types
################################################################################

include("./types/types.jl")

################################################################################
#                                   Includes
################################################################################

# Ncurses bindings
# ==============================================================================

include("./ncurses/ncurses_functions.jl")
include("./ncurses/form_functions.jl")
include("./ncurses/menu_functions.jl")
include("./ncurses/panel_functions.jl")

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

# Windows
# ==============================================================================

include("./windows/create_destroy.jl")
include("./windows/focus.jl")
include("./windows/manage.jl")
include("./windows/misc.jl")
include("./windows/refresh_update.jl")

# Widgets
# ==============================================================================

include("./widgets/widgets.jl")
include("./widgets/button.jl")
include("./widgets/labels.jl")
include("./widgets/progress_bar.jl")

end # module
