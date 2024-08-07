module TextUserInterfaces

using Dates
using FileWatching
using LinearAlgebra
using StringManipulation
using UnPack

import Base: getproperty, setproperty!, @kwdef

############################################################################################
#                                        Submodules                                        #
############################################################################################

include("submodules/NCurses/NCurses.jl")
using .NCurses
export NCurses

include("./submodules/ParseAnsiColors/ParseAnsiColors.jl")
using .ParseAnsiColors
export ParseAnsiColors

############################################################################################
#                                          Macros                                          #
############################################################################################

include("./macros/signals.jl")
include("./macros/colors.jl")
include("./macros/widgets.jl")
include("./macros/tui_builder.jl")

############################################################################################
#                                          Types                                           #
############################################################################################

include("./types/types.jl")

############################################################################################
#                                         Includes                                         #
############################################################################################

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

include("./widgets/ansi_label.jl")
include("./widgets/button.jl")
include("./widgets/container.jl")
include("./widgets/composed_widgets.jl")
include("./widgets/display_matrix.jl")
include("./widgets/horizontal_line.jl")
include("./widgets/input_field.jl")
include("./widgets/keystroke.jl")
include("./widgets/label.jl")
include("./widgets/list_box.jl")
include("./widgets/object_api.jl")
include("./widgets/progress_bar.jl")
include("./widgets/raw_buffer.jl")
include("./widgets/widgets.jl")

include("./widgets/combo_box.jl")
include("./widgets/panels.jl")
include("./widgets/tabs.jl")

include("./windows/constants.jl")
include("./windows/create.jl")
include("./windows/destroy.jl")
include("./windows/misc.jl")
include("./windows/object_api.jl")
include("./windows/root_window.jl")
include("./windows/update.jl")
include("./windows/theme.jl")


############################################################################################
#                                     Global Variables                                     #
############################################################################################

export tui

# Global instance to store the text user interface configurations.
const tui = TextUserInterface()

# Global object to reference the root window.
export ROOT_WINDOW
const ROOT_WINDOW = RootWindow()

############################################################################################
#                                      Initialization                                      #
############################################################################################

function __init__()
    load_ncurses()
end

############################################################################################
#                                      Precompilation                                      #
############################################################################################

include("./precompilation.jl")

end # module
