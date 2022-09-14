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
    @log INFO "destroy_tui" "TUI will be destroyed."

    @disconnect_all tui keypressed

    if tui.initialized
        @log INFO "destroy_tui" "TUI destroying windows."
        destroy_all_windows()
        endwin()

        # Mark the TUI as not initialized.
        tui.stdscr = Ptr{WINDOW}(0)
        tui.initialized = false

        # Reset internal variables.
        tui._num_of_created_objects = 0
    end

    @log INFO "destroy_tui" "TUI has been destroyed."

    # Reset all colors definitions.
    _reset_color_dict()

    # Close log.
    if logger.file !== nothing
        close(logger.file)
        logger.file = nothing
    end
end