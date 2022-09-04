# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Function related to the destruction of TUI.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export destroy_tui

"""
    destroy_tui()

Destroy the text user interface (TUI).
"""
function destroy_tui()
    @log info "destroy_tui" "TUI will be destroyed."

    if tui.init
        # Mark the TUI as not initialized.
        tui.stdscr = Ptr{WINDOW}(0)
        tui.init = false
    end

    @log info "destroy_tui" "TUI has been destroyed."

    # Reset all colors definitions.
    _reset_color_dir()

    # Close log.
    if logger.file !== nothing
        close(logger.file)
        logger.file = nothing
    end
end
