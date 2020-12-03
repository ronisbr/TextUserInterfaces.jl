# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   This file contains functions to destroy windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export destroy_window!, destroy_all_windows

"""
    destroy_window!(win::Window)

Destroy the window `win`.

"""
function destroy_window!(win::Window)
    @log info "destroy_window!" "$(obj_desc(win)) will be destroyed."
    @log_ident 1

    # Destroy the widget.
    if win.widget != nothing
        # In this case, we do not need to refresh the window.
        destroy_widget!(win.widget; refresh = false)
        win.widget = nothing
    end

    # Delete everything.
    if win.panel != C_NULL
        del_panel(win.panel)
        win.panel = Ptr{Cvoid}(0)
    end

    if win.buffer != C_NULL
        delwin(win.buffer)
        win.buffer = Ptr{WINDOW}(0)
    end

    if win.view != C_NULL
        delwin(win.view)
        win.view = Ptr{WINDOW}(0)
    end

    # Remove the window from the global list.
    idx = findall(x->x == win, tui.wins)
    deleteat!(tui.wins, idx)

    @log_ident 0
    @log info "destroy_window!" "Window destroyed: $(win.id)."

    return nothing
end

"""
    destroy_all_windows()

Destroy all windows managed by the TUI.

"""
function destroy_all_windows()
    @log info "destroy_all_windows" "All windows will be destroyed."
    while length(tui.wins) > 0
        destroy_window!(tui.wins[end])
    end

    return nothing
end
