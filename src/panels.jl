# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains functions related to panels handling.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export create_panel, create_panel_chain, destroy_panel, destroy_all_panels,
       hide_panel, move_panel_to_top, next_panel, prev_panel, show_panel

"""
    function create_panel(win::TUI_WINDOW, prev::Union{Nothing,TUI_PANEL} = nothing, next::Union{Nothing,TUI_PANEL} = nothing)

Create a panel for the window `win` in which the previous panel is `prev` and
the next panel is `next`.

"""
function create_panel(win::TUI_WINDOW, prev::Union{Nothing,TUI_PANEL} = nothing,
                                       next::Union{Nothing,TUI_PANEL} = nothing)

    ptr_border = win.border != C_NULL ? new_panel(win.border) : Ptr{Cvoid}(0)
    panel      = new_panel(win.ptr)
    tui_panel  = TUI_PANEL(ptr = panel, ptr_border = ptr_border, win = win,
                           prev = prev, next = next)
    push!(tui.panels, tui_panel)

    return tui_panel
end

"""
    function create_panel_chain(panels::TUI_PANEL...; circular = true)

Create a chain of panels by assigning the `prev` and `next` pointers of each
one. If the keyword `circular` is `true`, then the list will be circular.

# Example

    create_panel_chain(panel1, panel2, panel3; circular = false)

    nothing <--> panel1 <--> panel2 <--> panel3 <--> nothing

    create_panel_chain(panel1, panel2, panel3; circular = true)

    .---> panel1 <--> panel2 <--> panel3 <--.
    |                                       |
    |                                       |
    '---------------------------------------'

"""
function create_panel_chain(panels::TUI_PANEL...; circular = true)
    num_panels = length(panels)

    num_panels <= 1 && return nothing

    @inbounds for i = 1:num_panels
        panels[i].prev = i != 1          ? panels[i-1] : circular ? panels[num_panels] : nothing
        panels[i].next = i != num_panels ? panels[i+1] : circular ? panels[1]          : nothing
    end

    return nothing
end

"""
    function destroy_panel(panel::TUI_PANEL)

Destroy the panel `panel`.

"""
function destroy_panel(panel::TUI_PANEL)
    # Delete the panel in the ncurses system.
    del_panel(panel.ptr)
    panel.ptr = Ptr{WINDOW}(0)

    if panel.ptr_border != C_NULL
        del_panel(panel.ptr_border)
        panel.ptr_border = Ptr{WINDOW}(0)
    end

    # Remove the window from the global list.
    idx = findall(x->x == panel, tui.panels)
    deleteat!(tui.panels, idx)

    nothing
end

"""
    function destroy_all_panels()

Destroy all panels managed by the TUI.

"""
function destroy_all_panels()
    while length(tui.panels) > 0
        destroy_panel(tui.panels[1])
    end
end

"""
    function hide_panel(panel::TUI_PANEL)

Hide the panel `panel`.

"""
function hide_panel(panel::TUI_PANEL)
    hide_panel(panel.ptr)
    panel.ptr_border != C_NULL && hide_panel(panel.ptr_border)
end

"""
    function move_panel_to_top(panel::TUI_PANEL)

Move the panel `panel` to the top.

"""
function move_panel_to_top(panel::TUI_PANEL)
    panel.ptr_border != C_NULL && top_panel(panel.ptr_border)
    top_panel(panel.ptr)
    update_panels()
    tui.top_panel = panel
    nothing
end

"""
    function next_panel([panel::TUI_PANEL])

Make the next panel of `panel` be the top panel. If `panel` is not specified,
then it will use the current top panel in the structure `tui`.

"""
function next_panel()
    top_panel = tui.top_panel
    top_panel != nothing && next_panel(top_panel)
    nothing
end

function next_panel(panel::TUI_PANEL)
    panel.next != nothing && move_panel_to_top(panel.next)
    nothing
end

"""
    function prev_panel([panel::TUI_PANEL])

Make the previous panel of `panel` be the top panel. If `panel` is not
specified, then it will use the current top panel in the structure `tui`.

"""
function prev_panel()
    top_panel = tui.top_panel
    top_panel != nothing && prev_panel(top_panel)
    nothing
end

function prev_panel(panel::TUI_PANEL)
    panel.prev != nothing && move_panel_to_top(panel)
    nothing
end

"""
    function show_panel(panel::TUI_PANEL)

Show the panel `panel`.

"""
function show_panel(panel::TUI_PANEL)
    show_panel(panel.ptr)
    panel.ptr_border != C_NULL && show_panel(panel.ptr_border)
end


