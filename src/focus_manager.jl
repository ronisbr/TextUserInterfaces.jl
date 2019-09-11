# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Description
#
#   Focus manager.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export force_focus_change, init_focus_manager, process_focus,
       request_focus_change, set_focus_chain

"""
    function force_focus_change(new_focus_id::Integer)

Force the focus to change to the element with ID `new_focus_id` in the focus
chain.

"""
function force_focus_change(new_focus_id::Integer)
    # With no panels, there is nothing to process.
    num_panels = length(tui.focus_chain)
    num_panels == 0 && return nothing

    tui.focus_ptr != nothing && release_focus(tui.focus_ptr)

    # Check if the new element ID is valid.
    if (0 < new_focus_id <= num_panels)

        # If the selected `id` cannot accept the focus, search for any other
        # component that can.
        for i = 1:num_panels
            if accept_focus(tui.focus_chain[new_focus_id])
                tui.focus_id  = new_focus_id
                tui.focus_ptr = tui.focus_chain[new_focus_id]
                break
            end

            new_focus_id += 1
            new_focus_id > num_panels && (new_focus_id = 1)
        end
   end
end

"""
    function init_focus_manager()

Initialization of the focus manager. The elements in `focus_chain` are iterated
to find the first one that can accept the focus.

"""
function init_focus_manager()
    # With no panels, there is nothing to process.
    num_panels = length(tui.focus_chain)
    num_panels == 0 && return nothing

    for i = 1:num_panels
        if accept_focus(tui.focus_chain[i])
            tui.focus_id  = i
            tui.focus_ptr = tui.focus_chain[i]

            update_panels()
            doupdate()

            return true
        end
    end

    return false
end

"""
    function process_focus(k::Keystroke)

Process the focus considering the user's keystorke `k`.

"""
function process_focus(k::Keystroke)
    # With no panels, there is nothing to process.
    num_panels = length(tui.focus_chain)
    num_panels == 0 && return nothing

    # Check if the keystroke asks for change focus.
    if k.ktype == :F2
        request_focus_change()
    else
        process_focus(tui.focus_ptr, k)
    end

    update_panels()
    doupdate()

    return nothing
end

"""
    function request_focus_change()

Request that the current panel (in focus) changes its child that has the focus.
If the panel has cycled all its children elements, than search for the next
panel that can accept the focus.

"""
function request_focus_change()
    # With no panels, there is nothing to process.
    num_panels = length(tui.focus_chain)
    num_panels == 0 && return nothing

    if (tui.focus_ptr == nothing) || request_focus_change(tui.focus_ptr)
        # If the window is no longer in focus, we must search for the next
        # one in which the focus is accepted.
        tui.focus_ptr = nothing
        for i = 1:num_panels
            tui.focus_id += 1
            tui.focus_id > num_panels && (tui.focus_id = 1)
            if accept_focus(tui.focus_chain[tui.focus_id])
                tui.focus_ptr = tui.focus_chain[tui.focus_id]
                break
            end
        end
    end
end

"""
    function set_focus_chain(panels::TUI_PANEL...; new_focus_id::Integer = 1)

Set the focus chain, *i.e.* the ordered list of panels that can receive the
focus. The keyword `new_focus_id` can be set to specify which element is
currently focused in the new chain.

"""
function set_focus_chain(panels::TUI_PANEL...; new_focus_id::Integer = 1)
    tui.focus_ptr != nothing && release_focus(tui.focus_ptr)
    tui.focus_ptr = nothing
    tui.focus_chain = [panels...]
    force_focus_change(new_focus_id)
    return nothing
end

