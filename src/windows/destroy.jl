# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains functions to destroy windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export destroy_all_windows

"""
    destroy_all_windows()

Destroy all windows managed by the TUI.
"""
function destroy_all_windows()
    @log INFO "destroy_all_windows" "All windows will be destroyed."

    while !isempty(tui.windows)
        destroy!(tui.windows |> first)
    end

    return nothing
end
