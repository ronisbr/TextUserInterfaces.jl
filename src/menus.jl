# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   This file contains functions related to menus handling.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export create_menu, destroy_menu, set_menu_win, post_menu, unpost_menu,
       menu_down_item, menu_left_item, menu_right_item, menu_up_item,
       menu_down_line, menu_up_line, menu_down_page, menu_up_page,
       menu_first_item, menu_last_item, menu_next_item, menu_prev_item,
       menu_toggle_item, current_item, current_item_name, current_item_desc,
       selected_items, selected_items_names, selected_items_desc, menu_driver

"""
function create_menu(names::Vector{T1}, descriptions::Union{Nothing,Vector{T2}} = nothing; kwargs...)

Create a menu with the names `names` and descriptions `descriptions`. If
`descriptions` is `nothing` or is omitted, then the menu descriptions will not
be shown.

# Keywords

* `format`: If `nothing`, then the default menu format will be used. Otherwise,
            it must be a tuple with two integers describing respectively the
            number of rows and columns. (**Default** = `nothing`)
* `mark`: The menu mark. (**Default** = `-`)
* `one_value`: If `true`, then the menu cannot have multiple selections.
               (**Default** = `true`)
* `show_desc`: If `true`, then the menu description will be shown.
               (**Default** = `true`)
* `row_major`: If `true`, then the menu will be constructed in a row-major
               ordering.
* `ignore_case`: If `true`, then the case will be ignored on pattern matching.
* `show_match`: If `true`, then the cursor will be moved to within the item name
                while pattern-matching.
* `non_cyclic`: If `true`, then the menu will be non cyclic.

"""
function create_menu(names::Vector{T1},
                     descriptions::Union{Nothing,Vector{T2}} = nothing;
                     format::Union{Nothing,Tuple{Int,Int}} = nothing,
                     mark::AbstractString = "-",
                     one_value::Bool = true,
                     show_desc::Bool = true,
                     row_major::Bool = true,
                     ignore_case::Bool = true,
                     show_match::Bool = true,
                     non_cyclic::Bool = true) where {T1<:AbstractString, T2<:AbstractString}

    # Check the parameters
    # ==========================================================================

    num_items = length(names)

    descriptions != nothing && num_items != length(descriptions) &&
    error("The length of the vectors `names` and `descriptions` must be the same.")

    # Check if we must select the format of the menu.
    set_format = format != nothing ? true : false

    if set_format
        format[1] <= 0 && error("The numbers in `format` tuple must be positive")
        format[2] <= 0 && error("The numbers in `format` tuple must be positive")
    end

    descriptions == nothing && (show_desc = false)

    # Create the menu
    # ==========================================================================

    # We should copy the `names` and `descriptions` vectors to avoid
    # deallocation before the menu is destroyed.
    names_copy        = copy(names)
    descriptions_copy = descriptions == nothing ? names_copy : copy(descriptions)
    items             = Vector{Ptr{Cvoid}}(undef,num_items+1)

    @inbounds for i = 1:num_items
        items[i] = new_item(names_copy[i], descriptions_copy[i])
    end
    @inbounds items[num_items+1] = C_NULL

    menu = new_menu(items)

    # Set menu format
    # ==========================================================================

    set_format && set_menu_format(menu, format...)

    # Set menu mark
    # ==========================================================================

    set_menu_mark(menu, mark)

    # Set menu options
    # ==========================================================================

    opts = 0x00

    one_value   && (opts |= menuopts[:o_onevalue])
    show_desc   && (opts |= menuopts[:o_showdesc])
    row_major   && (opts |= menuopts[:o_rowmajor])
    ignore_case && (opts |= menuopts[:o_ignorecase])
    show_match  && (opts |= menuopts[:o_showmatch])
    non_cyclic  && (opts |= menuopts[:o_noncyclic])

    set_menu_opts(menu, opts)

    return TUI_MENU(names = names_copy, descriptions = descriptions_copy,
                    items = items, ptr = menu)
end

"""
    function destroy_menu(menu::TUI_MENU)

Destroy the menu `menu`.

"""
function destroy_menu(menu::TUI_MENU)
    unpost_menu(menu.ptr)
    free_menu(menu.ptr)

    for item in menu.items
        free_item(item)
    end
end

"""
    function post_menu(menu::TUI_MENU)

Post the menu `menu`.

"""
function post_menu(menu::TUI_MENU)
    menu.ptr != C_NULL && post_menu(menu.ptr)
    nothing
end

"""
    function unpost_menu(menu::TUI_MENU)

Unpost the menu `menu`.

"""
function unpost_menu(menu::TUI_MENU)
    menu.ptr != C_NULL && unpost_menu(menu.ptr)
    nothing
end

"""
    function set_menu_win(menu::TUI_MENU, win::Window)

Set menu `menu` window to `win`.

"""
function set_menu_win(menu::TUI_MENU, win::Window)
    if (menu.ptr != C_NULL) && (win.ptr != C_NULL)
        menu.win = win
        set_menu_win(menu.ptr, win.ptr)
        set_menu_sub(menu.ptr, win.ptr)
        push!(win.children, menu)

        # Show the menu.
        post_menu(menu)
        request_view_update(win)
        refresh_window(win)
    end

    return nothing
end

# Functions to get the menu information
# ==============================================================================

"""
    current_item(menu::TUI_MENU) = current_item(menu.ptr)

Return the current item of the menu `menu`.

"""
current_item(menu::TUI_MENU) = current_item(menu.ptr)

"""
    function current_item_name(menu::TUI_MENU)

Return the item name of the menu `menu`.

"""
function current_item_name(menu::TUI_MENU)
    cur_item = current_item(menu)
    idx = findfirst(x -> x == cur_item, menu.items)
    idx == nothing && error("Could not get the current item.")
    return menu.names[idx]
end

"""
    function current_item_desc(menu::TUI_MENU)

Return the item description of the menu `menu`.

"""
function current_item_desc(menu::TUI_MENU)
    cur_item = current_item(menu)
    idx = findfirst(x -> x == cur_item, menu.items)
    idx == nothing && error("Could not get the current item.")
    return menu.descriptions[idx]
end

"""
    function selected_items(menu::TUI_MENU)

Return a `Vector` with the selected items in the menu `menu`.

"""
function selected_items(menu::TUI_MENU)
    selected_items = Vector{Ptr{Cvoid}}(undef, 0)

    for item in menu.items
        item_value(item) && push!(selected_items, item)
    end

    return selected_items
end

"""
    function selected_items_names(menu::TUI_MENU)

Return a `Vector` with the selected items names in the menu `menu`.

"""
function selected_items_names(menu::TUI_MENU)
    selected_items_names = Vector{String}(undef, 0)

    @inbounds for i = 1:length(menu.items)
        item_value(menu.items[i]) == 1 && push!(selected_items_names, menu.names[i])
    end

    return selected_items_names
end

"""
    function selected_items_desc(menu::TUI_MENU)

Return a `Vector` with the selected items descriptions in the menu `menu`.

"""
function selected_items_desc(menu::TUI_MENU)
    selected_items_desc = Vector{String}(undef, 0)

    @inbounds for i = 1:length(menu.items)
        item_value(menu.items[i]) == 1 && push!(selected_items_desc, menu.descriptions[i])
    end

    return selected_items_descriptions
end

# Commands to the menu
# ==============================================================================

"""
    function menu_down_item(menu::TUI_MENU)

Move down to an item of the menu `menu`.

"""
function menu_down_item(menu::TUI_MENU)
    menu.ptr != C_NULL && menu_driver(menu.ptr, menucmd[:req_down_item])
    nothing
end

"""
    function menu_left_item(menu::TUI_MENU)

Move left to an item of the menu `menu`.

"""
function menu_left_item(menu::TUI_MENU)
    menu.ptr != C_NULL && menu_driver(menu.ptr, menucmd[:req_left_item])
    nothing
end

"""
    function menu_right_item(menu::TUI_MENU)

Move right to an item of the menu `menu`.

"""
function menu_right_item(menu::TUI_MENU)
    menu.ptr != C_NULL && menu_driver(menu.ptr, menucmd[:req_right_item])
    nothing
end

"""
    function menu_up_item(menu::TUI_MENU)

Move up to an item of the menu `menu`.

"""
function menu_up_item(menu::TUI_MENU)
    menu.ptr != C_NULL && menu_driver(menu.ptr, menucmd[:req_up_item])
    nothing
end

"""
    function menu_down_line(menu::TUI_MENU)

Scroll down a line of the menu `menu`.

"""
function menu_down_line(menu::TUI_MENU)
    menu.ptr != C_NULL && menu_driver(menu.ptr, menucmd[:req_scr_dline])
    nothing
end

"""
    function menu_up_line(menu::TUI_MENU)

Scroll up a line of the menu `menu`.

"""
function menu_up_line(menu::TUI_MENU)
    menu.ptr != C_NULL && menu_driver(menu.ptr, menucmd[:req_scr_uline])
    nothing
end

"""
    function menu_down_page(menu::TUI_MENU)

Scroll down a page of the menu `menu`.

"""
function menu_down_page(menu::TUI_MENU)
    menu.ptr != C_NULL && menu_driver(menu.ptr, menucmd[:req_scr_dpage])
    nothing
end

"""
    function menu_up_page(menu::TUI_MENU)

Scroll up a page of the menu `menu`.

"""
function menu_up_page(menu::TUI_MENU)
    menu.ptr != C_NULL && menu_driver(menu.ptr, menucmd[:req_scr_upage])
    nothing
end

"""
    function menu_first_item(menu::TUI_MENU)

Move to the first item of the menu `menu`.

"""
function menu_first_item(menu::TUI_MENU)
    menu.ptr != C_NULL && menu_driver(menu.ptr, menucmd[:req_first_item])
    nothing
end

"""
    function menu_last_item(menu::TUI_MENU)

Move to the last item of the menu `menu`.

"""
function menu_last_item(menu::TUI_MENU)
    menu.ptr != C_NULL && menu_driver(menu.ptr, menucmd[:req_last_item])
    nothing
end

"""
    function menu_next_item(menu::TUI_MENU)

Move to the next item of the menu `menu`.

"""
function menu_next_item(menu::TUI_MENU)
    menu.ptr != C_NULL && menu_driver(menu.ptr, menucmd[:req_next_item])
    nothing
end

"""
    function menu_prev_item(menu::TUI_MENU)

Move to the previous menu item of the `menu`.

"""
function menu_prev_item(menu::TUI_MENU)
    menu.ptr != C_NULL && menu_driver(menu.ptr, menucmd[:req_prev_item])
    nothing
end

"""
    function menu_toggle_item(menu::TUI_MENU)

Toggle the current item of the menu `menu`.

"""
function menu_toggle_item(menu::TUI_MENU)
    menu.ptr != C_NULL && menu_driver(menu.ptr, menucmd[:req_toggle_item])
    nothing
end

# Menu driver helper
# ==============================================================================

# Default commands.
const _default_menu_cmds = Dict{Union{String,Tuple{Symbol,Bool,Bool,Bool}},Function}(
    (:down,     false,false,false) => menu_down_item,
    (:left,     false,false,false) => menu_left_item,
    (:right,    false,false,false) => menu_right_item,
    (:up,       false,false,false) => menu_up_item,
    (:home,     false,false,false) => menu_first_item,
    (:end,      false,false,false) => menu_last_item,
    (:pageup,   false,false,false) => menu_down_page,
    (:pagedown, false,false,false) => menu_up_page,
)

function menu_driver(menu::TUI_MENU, k::Keystroke;
                     user_cmds::Dict{Union{String,Tuple{Symbol,Bool,Bool,Bool}},Function} =
                     Dict{Union{String,Tuple{Symbol,Bool,Bool,Bool}},Function}())

    # Merge the commands to the default.
    cmds = merge(_default_menu_cmds, user_cmds)

    # Check if we must execute a command.
    menu_func = nothing

    if haskey( cmds, (k.ktype,k.alt,k.ctrl,k.shift) )
        menu_func = cmds[(k.ktype,k.alt,k.ctrl,k.shift)]
    elseif haskey(cmds, k.value)
        menu_func = cmds[k.value]
    end

    if menu_func != nothing
        menu_func(menu)
        request_view_update(menu.win)
        update_cursor(menu.win)
        return true
    elseif k.ktype == :enter
        menu.on_return_pressed(menu)
        request_view_update(menu.win)
        update_cursor(menu.win)
        return true
    else
        return false
    end
end

################################################################################
#                                     API
################################################################################

# Focus manager
# ==============================================================================

"""
    function accept_focus(menu::TUI_MENU)

Command executed when menu `menu` must state whether or not it accepts the
focus. If the focus is accepted, then this function returns `true`. Otherwise,
it returns `false`.

"""
function accept_focus(menu::TUI_MENU)
    menu.has_focus = true
    update_cursor(menu.win)
    request_view_update(menu.win)
    return true
end

"""
    function process_focus(menu::TUI_MENU, k::Keystroke)

Process the actions when the menu `menu` is in focus and the keystroke `k` was
issued by the user.

"""
function process_focus(menu::TUI_MENU, k::Keystroke)
    return menu_driver(menu, k)
end

"""
    function release_focus(menu::TUI_MENU)

Release the focus from the menu `menu`.

"""
function release_focus(menu::TUI_MENU)
    menu.has_focus = false
    return nothing
end
