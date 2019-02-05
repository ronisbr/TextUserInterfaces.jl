var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#TextUserInterfaces.jl-1",
    "page": "Home",
    "title": "TextUserInterfaces.jl",
    "category": "section",
    "text": "This package wraps the C library ncurses and provide a Julia-like API to build text user interfaces. The development was highly based on the package TermWin.jl.warning: Warning\nThe documentation and the package are under development!"
},

{
    "location": "lib/library/#",
    "page": "Library",
    "title": "Library",
    "category": "page",
    "text": ""
},

{
    "location": "lib/library/#TextUserInterfaces.fieldjust",
    "page": "Library",
    "title": "TextUserInterfaces.fieldjust",
    "category": "constant",
    "text": "Dictionary defining values of the field justification.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.fieldopts",
    "page": "Library",
    "title": "TextUserInterfaces.fieldopts",
    "category": "constant",
    "text": "Dictionary defining values of the field options.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.formcmd",
    "page": "Library",
    "title": "TextUserInterfaces.formcmd",
    "category": "constant",
    "text": "Dictionary defining values of the form commands.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menucmd",
    "page": "Library",
    "title": "TextUserInterfaces.menucmd",
    "category": "constant",
    "text": "Dictionary defining values of the menu commands.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.Keystroke",
    "page": "Library",
    "title": "TextUserInterfaces.Keystroke",
    "category": "type",
    "text": "struct Keystorke\n\nStructure that defines a keystroke.\n\nFields\n\nvalue: String representing the keystroke.\nktype: Type of the key (:char, :F1, :up, etc.).\nalt: true if ALT key was pressed (only valid if ktype != :char).\nctrl: true if CTRL key was pressed (only valid if ktype != :char).\nshift: true if SHIFT key was pressed (only valid if ktype != :char).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.ACS_-Tuple{Symbol}",
    "page": "Library",
    "title": "TextUserInterfaces.ACS_",
    "category": "method",
    "text": "function ACS_(s::Symbol)\n\nReturn the symbol s of the acs_map. For example, ACS_HLINE can be obtained from ACS_(:HLINE).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.COLS-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.COLS",
    "category": "method",
    "text": "function COLS()\n\nReturn the number of columns in the root window. It must be called after initscr().\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.LINES-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.LINES",
    "category": "method",
    "text": "function LINES()\n\nReturn the number of lines in the root window. It must be called after initscr().\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.attroff",
    "page": "Library",
    "title": "TextUserInterfaces.attroff",
    "category": "function",
    "text": "function attroff(attrs::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.attron",
    "page": "Library",
    "title": "TextUserInterfaces.attron",
    "category": "function",
    "text": "function attron(attrs::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.box",
    "page": "Library",
    "title": "TextUserInterfaces.box",
    "category": "function",
    "text": "function box(win::Ptr{WINDOW}, verch::jlchtype, horch::jlchtype)\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.cbreak",
    "page": "Library",
    "title": "TextUserInterfaces.cbreak",
    "category": "function",
    "text": "function cbreak()\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.clear",
    "page": "Library",
    "title": "TextUserInterfaces.clear",
    "category": "function",
    "text": "function clear()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.clear_window-Tuple{TextUserInterfaces.TUI_WINDOW}",
    "page": "Library",
    "title": "TextUserInterfaces.clear_window",
    "category": "method",
    "text": "function clear_window(win::TUI_WINDOW; clear_type = :all)\n\nClear the window win according the to clearing type in clear_type:\n\n:all: Clears the entire window.\n:to_screen_bottom: Clears everything from the cursor position to the bottom                      of the screen.\n:to_eol: Clear everything from the cursor position to the end of line.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.clrtobot",
    "page": "Library",
    "title": "TextUserInterfaces.clrtobot",
    "category": "function",
    "text": "function clrtobot()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.clrtoeol",
    "page": "Library",
    "title": "TextUserInterfaces.clrtoeol",
    "category": "function",
    "text": "function clrtoeol()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_menu-Union{Tuple{Array{T1,1}}, Tuple{T2}, Tuple{T1}, Tuple{Array{T1,1},Union{Nothing, Array{T2,1}}}} where T2<:AbstractString where T1<:AbstractString",
    "page": "Library",
    "title": "TextUserInterfaces.create_menu",
    "category": "method",
    "text": "function create_menu(names::Vector{T1}, descriptions::Union{Nothing,Vector{T2}} = nothing; kwargs...)\n\nCreate a menu with the names names and descriptions descriptions. If descriptions is nothing or is omitted, then the menu descriptions will not be shown.\n\nKeywords\n\nformat: If nothing, then the default menu format will be used. Otherwise,           it must be a tuple with two integers describing respectively the           number of rows and columns. (Default = nothing)\nmark: The menu mark. (Default = -)\none_value: If true, then the menu cannot have multiple selections.              (Default = true)\nshow_desc: If true, then the menu description will be shown.              (Default = true)\nrow_major: If true, then the menu will be constructed in a row-major              ordering.\nignore_case: If true, then the case will be ignored on pattern matching.\nshow_match: If true, then the cursor will be moved to within the item name               while pattern-matching.\nnon_cyclic: If true, then the menu will be non cyclic.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_panel",
    "page": "Library",
    "title": "TextUserInterfaces.create_panel",
    "category": "function",
    "text": "function create_panel(win::TUI_WINDOW, prev::Union{Nothing,TUI_PANEL} = nothing, next::Union{Nothing,TUI_PANEL} = nothing)\n\nCreate a panel for the window win in which the previous panel is prev and the next panel is next.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_panel_chain-Tuple{Vararg{TextUserInterfaces.TUI_PANEL,N} where N}",
    "page": "Library",
    "title": "TextUserInterfaces.create_panel_chain",
    "category": "method",
    "text": "function create_panel_chain(panels::TUI_PANEL...; circular = true)\n\nCreate a chain of panels by assigning the prev and next pointers of each one. If the keyword circular is true, then the list will be circular.\n\nExample\n\ncreate_panel_chain(panel1, panel2, panel3; circular = false)\n\nnothing <--> panel1 <--> panel2 <--> panel3 <--> nothing\n\ncreate_panel_chain(panel1, panel2, panel3; circular = true)\n\n.---> panel1 <--> panel2 <--> panel3 <--.\n|                                       |\n|                                       |\n\'---------------------------------------\'\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_window",
    "page": "Library",
    "title": "TextUserInterfaces.create_window",
    "category": "function",
    "text": "function createwindow([parent::Union{Nothing,TUIWINDOW}, ]nlines::Integer, ncols::Integer, beginy::Integer, beginx::Integer, id::String = \"\"; border = true)\n\nCreate a window inside the parent window parent. If parent is nothing or if it is omitted, then the root window will be used as the parent window. The new window size will be nlines × ncols and the origin will be placed at (begin_y, begin_x) coordinate of the parent window. The window ID id is used to identify the new window in the global window list.\n\nKeyword\n\nborder: If true, then the window will have a border. (Default =           true)\ntitle: The title of the window, which will only be printed if border is          true. (Default = \"\")\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_window_layout-Union{Tuple{T2}, Tuple{T1}, Tuple{Array{T1,1},Array{T2,1}}} where T2<:Number where T1<:Number",
    "page": "Library",
    "title": "TextUserInterfaces.create_window_layout",
    "category": "method",
    "text": "function create_window_layout(parent::TUI_WINDOW, vert::Vector{T1}, horz::Vector{T2}) where {T1<:Number, T2<:Number}\n\nCreate a window layout inside the parent window parent. If it is omitted, then the root window will be used as parent.\n\nThe layout dimensions is obtained from the vectors vert and horz. They will be interpreted as a percentage of the total size. For example, if vert = [50,25,25], then the layout will have three lines in each the first will have 50% of the total size, and the second and third 25%. The same applies for the horz vector for the columns size of the layout.\n\nThis function return a matrix with the windows references.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.current_item",
    "page": "Library",
    "title": "TextUserInterfaces.current_item",
    "category": "function",
    "text": "function current_item(menu::Ptr{Cvoid})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.current_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.current_item",
    "category": "method",
    "text": "current_item(menu::TUI_MENU) = current_item(menu.ptr)\n\nReturn the current item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.current_item_desc-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.current_item_desc",
    "category": "method",
    "text": "function current_item_desc(menu::TUI_MENU)\n\nReturn the item description of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.current_item_name-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.current_item_name",
    "category": "method",
    "text": "function current_item_name(menu::TUI_MENU)\n\nReturn the item name of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.curs_set",
    "page": "Library",
    "title": "TextUserInterfaces.curs_set",
    "category": "function",
    "text": "function curs_set(visibility::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.del_panel",
    "page": "Library",
    "title": "TextUserInterfaces.del_panel",
    "category": "function",
    "text": "function del_panel(panel::Ptr{Cvoid})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.delwin",
    "page": "Library",
    "title": "TextUserInterfaces.delwin",
    "category": "function",
    "text": "function delwin(win::Ptr{WINDOW})\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.derwin",
    "page": "Library",
    "title": "TextUserInterfaces.derwin",
    "category": "function",
    "text": "function derwin(win::Ptr{WINDOW}, nlines::Integer, ncols::Integer, begin_y::Integer, begin_x::Integer)\n\nReturn type: Ptr{TextUserInterfaces.WINDOW}\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_all_panels-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_all_panels",
    "category": "method",
    "text": "function destroy_all_panels()\n\nDestroy all panels managed by the TUI.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_all_windows-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_all_windows",
    "category": "method",
    "text": "function destroy_all_windows()\n\nDestroy all windows managed by the TUI.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_menu-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_menu",
    "category": "method",
    "text": "function destroy_menu(menu::TUI_MENU)\n\nDestroy the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_panel-Tuple{TextUserInterfaces.TUI_PANEL}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_panel",
    "category": "method",
    "text": "function destroy_panel(panel::TUI_PANEL)\n\nDestroy the panel panel.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_tui-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_tui",
    "category": "method",
    "text": "function destroy_tui()\n\nDestroy the Text User Interface (TUI).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_window-Tuple{TextUserInterfaces.TUI_WINDOW}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_window",
    "category": "method",
    "text": "function destroy_window(win::TUI_WINDOW)\n\nDestroy the window win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.doupdate",
    "page": "Library",
    "title": "TextUserInterfaces.doupdate",
    "category": "function",
    "text": "function doupdate()\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.endwin",
    "page": "Library",
    "title": "TextUserInterfaces.endwin",
    "category": "function",
    "text": "function endwin()\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.erase",
    "page": "Library",
    "title": "TextUserInterfaces.erase",
    "category": "function",
    "text": "function erase()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.field_buffer",
    "page": "Library",
    "title": "TextUserInterfaces.field_buffer",
    "category": "function",
    "text": "function field_buffer(field::Ptr{Cvoid}, buffer::Integer)\n\nReturn type: Cstring\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_driver",
    "page": "Library",
    "title": "TextUserInterfaces.form_driver",
    "category": "function",
    "text": "function form_driver(form::Ptr{Cvoid}, ch::Integer)\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.free_field",
    "page": "Library",
    "title": "TextUserInterfaces.free_field",
    "category": "function",
    "text": "function free_field(field::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.free_form",
    "page": "Library",
    "title": "TextUserInterfaces.free_form",
    "category": "function",
    "text": "function free_form(form::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.free_item",
    "page": "Library",
    "title": "TextUserInterfaces.free_item",
    "category": "function",
    "text": "function free_item(item::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.free_menu",
    "page": "Library",
    "title": "TextUserInterfaces.free_menu",
    "category": "function",
    "text": "function free_menu(menu::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.getch",
    "page": "Library",
    "title": "TextUserInterfaces.getch",
    "category": "function",
    "text": "function getch()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.hide_panel",
    "page": "Library",
    "title": "TextUserInterfaces.hide_panel",
    "category": "function",
    "text": "function hide_panel(panel::Ptr{Cvoid})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.hide_panel-Tuple{TextUserInterfaces.TUI_PANEL}",
    "page": "Library",
    "title": "TextUserInterfaces.hide_panel",
    "category": "method",
    "text": "function hide_panel(panel::TUI_PANEL)\n\nHide the panel panel.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.hline",
    "page": "Library",
    "title": "TextUserInterfaces.hline",
    "category": "function",
    "text": "function hline(ch::jlchtype, n::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.init_color",
    "page": "Library",
    "title": "TextUserInterfaces.init_color",
    "category": "function",
    "text": "function init_color(color::Integer, f::Integer, b::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.init_pair",
    "page": "Library",
    "title": "TextUserInterfaces.init_pair",
    "category": "function",
    "text": "function init_pair(pair::Integer, f::Integer, b::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.init_tui",
    "page": "Library",
    "title": "TextUserInterfaces.init_tui",
    "category": "function",
    "text": "function init_tui(dir::String = \"\")\n\nInitialize the Text User Interface (TUI). The full-path of the ncurses directory can be specified by dir. If it is empty or omitted, then it will look on the default library directories.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.initscr",
    "page": "Library",
    "title": "TextUserInterfaces.initscr",
    "category": "function",
    "text": "function initscr()\n\nReturn type: Ptr{TextUserInterfaces.WINDOW}\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.item_description",
    "page": "Library",
    "title": "TextUserInterfaces.item_description",
    "category": "function",
    "text": "function item_description(menu::Ptr{Cvoid})\n\nReturn type: Cstring\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.item_index",
    "page": "Library",
    "title": "TextUserInterfaces.item_index",
    "category": "function",
    "text": "function item_index(menu::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.item_name",
    "page": "Library",
    "title": "TextUserInterfaces.item_name",
    "category": "function",
    "text": "function item_name(menu::Ptr{Cvoid})\n\nReturn type: Cstring\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.item_value",
    "page": "Library",
    "title": "TextUserInterfaces.item_value",
    "category": "function",
    "text": "function item_value(item::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.jlgetch",
    "page": "Library",
    "title": "TextUserInterfaces.jlgetch",
    "category": "function",
    "text": "function jlgetch(win::Union{Ptr{WINDOW},Nothing} = nothing)\n\nWait for an keystroke in the window win. If win is nothing, then getch() will be used instead of wgetch(win) to listen for the keystroke.\n\nReturns\n\nThe raw value from the functions getch() or wgetch(win).\nAn instance of the structure Keystroke descrebing the keystroke.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.keypad",
    "page": "Library",
    "title": "TextUserInterfaces.keypad",
    "category": "function",
    "text": "function keypad(win::Ptr{WINDOW}, bf::Bool)\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_down_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_down_item",
    "category": "method",
    "text": "function menu_down_item(menu::TUI_MENU)\n\nMove down to an item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_down_line-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_down_line",
    "category": "method",
    "text": "function menu_down_line(menu::TUI_MENU)\n\nScroll down a line of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_down_page-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_down_page",
    "category": "method",
    "text": "function menu_down_page(menu::TUI_MENU)\n\nScroll down a page of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_driver",
    "page": "Library",
    "title": "TextUserInterfaces.menu_driver",
    "category": "function",
    "text": "function menu_driver(menu::Ptr{Cvoid}, c::Integer)\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_first_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_first_item",
    "category": "method",
    "text": "function menu_first_item(menu::TUI_MENU)\n\nMove to the first item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_last_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_last_item",
    "category": "method",
    "text": "function menu_last_item(menu::TUI_MENU)\n\nMove to the last item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_left_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_left_item",
    "category": "method",
    "text": "function menu_left_item(menu::TUI_MENU)\n\nMove left to an item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_next_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_next_item",
    "category": "method",
    "text": "function menu_next_item(menu::TUI_MENU)\n\nMove to the next item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_prev_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_prev_item",
    "category": "method",
    "text": "function menu_prev_item(menu::TUI_MENU)\n\nMove to the previous menu item of the menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_right_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_right_item",
    "category": "method",
    "text": "function menu_right_item(menu::TUI_MENU)\n\nMove right to an item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_toggle_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_toggle_item",
    "category": "method",
    "text": "function menu_toggle_item(menu::TUI_MENU)\n\nToggle the current item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_up_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_up_item",
    "category": "method",
    "text": "function menu_up_item(menu::TUI_MENU)\n\nMove up to an item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_up_line-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_up_line",
    "category": "method",
    "text": "function menu_up_line(menu::TUI_MENU)\n\nScroll up a line of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_up_page-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_up_page",
    "category": "method",
    "text": "function menu_up_page(menu::TUI_MENU)\n\nScroll up a page of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.mouseinterval",
    "page": "Library",
    "title": "TextUserInterfaces.mouseinterval",
    "category": "function",
    "text": "function mouseinterval(n::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.move_panel_to_top-Tuple{TextUserInterfaces.TUI_PANEL}",
    "page": "Library",
    "title": "TextUserInterfaces.move_panel_to_top",
    "category": "method",
    "text": "function move_panel_to_top(panel::TUI_PANEL)\n\nMove the panel panel to the top.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.mvhline",
    "page": "Library",
    "title": "TextUserInterfaces.mvhline",
    "category": "function",
    "text": "function mvhline(y::Integer, x::Integer, ch::jlchtype, n::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.mvprintw",
    "page": "Library",
    "title": "TextUserInterfaces.mvprintw",
    "category": "function",
    "text": "function mvprintw(y::Integer, x::Integer, str::T) where T<:AbstractString\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.mvvline",
    "page": "Library",
    "title": "TextUserInterfaces.mvvline",
    "category": "function",
    "text": "function mvvline(y::Integer, x::Integer, ch::jlchtype, n::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.mvwhline",
    "page": "Library",
    "title": "TextUserInterfaces.mvwhline",
    "category": "function",
    "text": "function mvwhline(win::Ptr{WINDOW}, y::Integer, x::Integer, ch::jlchtype, n::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.mvwprintw",
    "page": "Library",
    "title": "TextUserInterfaces.mvwprintw",
    "category": "function",
    "text": "function mvwprintw(win::Ptr{WINDOW}, y::Integer, x::Integer, str::T) where T<:AbstractString\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.mvwvline",
    "page": "Library",
    "title": "TextUserInterfaces.mvwvline",
    "category": "function",
    "text": "function mvwvline(win::Ptr{WINDOW}, y::Integer, x::Integer, ch::jlchtype, n::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.new_form",
    "page": "Library",
    "title": "TextUserInterfaces.new_form",
    "category": "function",
    "text": "function new_form(fields::Vector{Ptr{Cvoid}})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.new_item",
    "page": "Library",
    "title": "TextUserInterfaces.new_item",
    "category": "function",
    "text": "function new_item(name::T, description::T) where T<:AbstractString\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.new_menu",
    "page": "Library",
    "title": "TextUserInterfaces.new_menu",
    "category": "function",
    "text": "function new_menu(items::Vector{Ptr{Cvoid}})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.new_panel",
    "page": "Library",
    "title": "TextUserInterfaces.new_panel",
    "category": "function",
    "text": "function new_panel(win::Ptr{WINDOW})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.newwin",
    "page": "Library",
    "title": "TextUserInterfaces.newwin",
    "category": "function",
    "text": "function newwin(lines::Integer, cols::Integer, y::Integer, x::Integer)\n\nReturn type: Ptr{TextUserInterfaces.WINDOW}\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.next_panel-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.next_panel",
    "category": "method",
    "text": "function next_panel([panel::TUI_PANEL])\n\nMake the next panel of panel be the top panel. If panel is not specified, then it will use the current top panel in the structure tui.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.nodelay",
    "page": "Library",
    "title": "TextUserInterfaces.nodelay",
    "category": "function",
    "text": "function nodelay(win::Ptr{WINDOW}, bf::Bool)\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.noecho",
    "page": "Library",
    "title": "TextUserInterfaces.noecho",
    "category": "function",
    "text": "function noecho()\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.notimeout",
    "page": "Library",
    "title": "TextUserInterfaces.notimeout",
    "category": "function",
    "text": "function notimeout(win::Ptr{WINDOW}, bf::Bool)\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.panel_userptr",
    "page": "Library",
    "title": "TextUserInterfaces.panel_userptr",
    "category": "function",
    "text": "function panel_userptr(pan::Ptr{Cvoid})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.pos_form_cursor",
    "page": "Library",
    "title": "TextUserInterfaces.pos_form_cursor",
    "category": "function",
    "text": "function pos_form_cursor(form::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.pos_menu_cursor",
    "page": "Library",
    "title": "TextUserInterfaces.pos_menu_cursor",
    "category": "function",
    "text": "function pos_menu_cursor(menu::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.post_form",
    "page": "Library",
    "title": "TextUserInterfaces.post_form",
    "category": "function",
    "text": "function post_form(form::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.post_menu",
    "page": "Library",
    "title": "TextUserInterfaces.post_menu",
    "category": "function",
    "text": "function post_menu(menu::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.post_menu-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.post_menu",
    "category": "method",
    "text": "function post_menu(menu::TUI_MENU)\n\nPost the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.prev_panel-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.prev_panel",
    "category": "method",
    "text": "function prev_panel([panel::TUI_PANEL])\n\nMake the previous panel of panel be the top panel. If panel is not specified, then it will use the current top panel in the structure tui.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.printw",
    "page": "Library",
    "title": "TextUserInterfaces.printw",
    "category": "function",
    "text": "function printw(str::T) where T<:AbstractString\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.refresh",
    "page": "Library",
    "title": "TextUserInterfaces.refresh",
    "category": "function",
    "text": "function refresh()\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.refresh_all_windows-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.refresh_all_windows",
    "category": "method",
    "text": "function refresh_all_windows()\n\nRefresh all the windows, including the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.refresh_window-Tuple{String}",
    "page": "Library",
    "title": "TextUserInterfaces.refresh_window",
    "category": "method",
    "text": "function refresh_window(id::String)\n\nRefresh the window with id id and all its parents windows except for the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.refresh_window-Tuple{TextUserInterfaces.TUI_WINDOW}",
    "page": "Library",
    "title": "TextUserInterfaces.refresh_window",
    "category": "method",
    "text": "function refresh_window(win::Ptr{WINDOW}; update = true)\n\nRefresh the window win and all its parents windows except for the root window. If update is true, then doupdate() is called and the physical screen is updated.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.selected_items-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.selected_items",
    "category": "method",
    "text": "function selected_items(menu::TUI_MENU)\n\nReturn a Vector with the selected items in the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.selected_items_desc-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.selected_items_desc",
    "category": "method",
    "text": "function selected_items_desc(menu::TUI_MENU)\n\nReturn a Vector with the selected items descriptions in the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.selected_items_names-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.selected_items_names",
    "category": "method",
    "text": "function selected_items_names(menu::TUI_MENU)\n\nReturn a Vector with the selected items names in the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_field_back",
    "page": "Library",
    "title": "TextUserInterfaces.set_field_back",
    "category": "function",
    "text": "function set_field_back(field::Ptr{Cvoid}, value::Integer)\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_field_buffer",
    "page": "Library",
    "title": "TextUserInterfaces.set_field_buffer",
    "category": "function",
    "text": "function set_field_buffer(field::Ptr{Cvoid}, buf::Int, c::T) where T<:AbstractString\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_field_opts",
    "page": "Library",
    "title": "TextUserInterfaces.set_field_opts",
    "category": "function",
    "text": "function set_field_opts(field::Ptr{Cvoid}, form_options::Integer)\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_form_sub",
    "page": "Library",
    "title": "TextUserInterfaces.set_form_sub",
    "category": "function",
    "text": "function set_form_sub(form::Ptr{Cvoid}, win_form::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_form_win",
    "page": "Library",
    "title": "TextUserInterfaces.set_form_win",
    "category": "function",
    "text": "function set_form_win(form::Ptr{Cvoid}, win_form::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_menu_format",
    "page": "Library",
    "title": "TextUserInterfaces.set_menu_format",
    "category": "function",
    "text": "function set_menu_format(menu::Ptr{Cvoid}, rows::Integer, cols::Integer)\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_menu_mark",
    "page": "Library",
    "title": "TextUserInterfaces.set_menu_mark",
    "category": "function",
    "text": "function set_menu_mark(menu::Ptr{Cvoid}, mark::T) where T<:AbstractString\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_menu_opts",
    "page": "Library",
    "title": "TextUserInterfaces.set_menu_opts",
    "category": "function",
    "text": "function set_menu_opts(menu::Ptr{Cvoid}, opts::Integer)\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_menu_sub",
    "page": "Library",
    "title": "TextUserInterfaces.set_menu_sub",
    "category": "function",
    "text": "function set_menu_sub(menu::Ptr{Cvoid}, win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_menu_sub-Tuple{TextUserInterfaces.TUI_MENU,TextUserInterfaces.TUI_WINDOW}",
    "page": "Library",
    "title": "TextUserInterfaces.set_menu_sub",
    "category": "method",
    "text": "function set_menu_sub(menu::TUI_MENU, win::TUI_WINDOW)\n\nSet the menu menu sub-window to win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_menu_win",
    "page": "Library",
    "title": "TextUserInterfaces.set_menu_win",
    "category": "function",
    "text": "function set_menu_win(menu::Ptr{Cvoid}, win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_menu_win-Tuple{TextUserInterfaces.TUI_MENU,TextUserInterfaces.TUI_WINDOW}",
    "page": "Library",
    "title": "TextUserInterfaces.set_menu_win",
    "category": "method",
    "text": "function set_menu_win(menu::TUI_MENU, win::TUI_WINDOW)\n\nSet menu menu window to win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_panel_userptr",
    "page": "Library",
    "title": "TextUserInterfaces.set_panel_userptr",
    "category": "function",
    "text": "function set_panel_userptr(pan::Ptr{Cvoid}, ptr::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_window_title!-Tuple{TextUserInterfaces.TUI_WINDOW,AbstractString}",
    "page": "Library",
    "title": "TextUserInterfaces.set_window_title!",
    "category": "method",
    "text": "function set_window_title!(win::TUI_WINDOW, title::AbstractString)\n\nSet the title of the window win to title.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.show_panel",
    "page": "Library",
    "title": "TextUserInterfaces.show_panel",
    "category": "function",
    "text": "function show_panel(panel::Ptr{Cvoid})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.show_panel-Tuple{TextUserInterfaces.TUI_PANEL}",
    "page": "Library",
    "title": "TextUserInterfaces.show_panel",
    "category": "method",
    "text": "function show_panel(panel::TUI_PANEL)\n\nShow the panel panel.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.start_color",
    "page": "Library",
    "title": "TextUserInterfaces.start_color",
    "category": "function",
    "text": "function start_color()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.top_panel",
    "page": "Library",
    "title": "TextUserInterfaces.top_panel",
    "category": "function",
    "text": "function top_panel(pan::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.unpost_form",
    "page": "Library",
    "title": "TextUserInterfaces.unpost_form",
    "category": "function",
    "text": "function unpost_form(form::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.unpost_menu",
    "page": "Library",
    "title": "TextUserInterfaces.unpost_menu",
    "category": "function",
    "text": "function unpost_menu(menu::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.unpost_menu-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.unpost_menu",
    "category": "method",
    "text": "function unpost_menu(menu::TUI_MENU)\n\nUnpost the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.update_panels",
    "page": "Library",
    "title": "TextUserInterfaces.update_panels",
    "category": "function",
    "text": "function update_panels()\n\nReturn type: Nothing\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.vline",
    "page": "Library",
    "title": "TextUserInterfaces.vline",
    "category": "function",
    "text": "function vline(ch::jlchtype, n::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.waddch",
    "page": "Library",
    "title": "TextUserInterfaces.waddch",
    "category": "function",
    "text": "function waddch(win::Ptr{WINDOW}, ch::jlchtype)\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wattroff",
    "page": "Library",
    "title": "TextUserInterfaces.wattroff",
    "category": "function",
    "text": "function wattroff(win::Ptr{WINDOW}, attrs::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wattron",
    "page": "Library",
    "title": "TextUserInterfaces.wattron",
    "category": "function",
    "text": "function wattron(win::Ptr{WINDOW}, attrs::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wborder",
    "page": "Library",
    "title": "TextUserInterfaces.wborder",
    "category": "function",
    "text": "function wborder(win::Ptr{WINDOW}, ls::jlchtype, rs::jlchtype, ts::jlchtype, bs::jlchtype, tl::jlchtype, tr::jlchtype, bl::jlchtype, br::jlchtype)\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wborder-Tuple{Ptr{TextUserInterfaces.WINDOW}}",
    "page": "Library",
    "title": "TextUserInterfaces.wborder",
    "category": "method",
    "text": "function wborder(win::Ptr{WINDOW})\n\nCall the function wborder(win, 0, 0, 0, 0, 0, 0, 0, 0).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wclear",
    "page": "Library",
    "title": "TextUserInterfaces.wclear",
    "category": "function",
    "text": "function wclear(win::Ptr{WINDOW})\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wclrtobot",
    "page": "Library",
    "title": "TextUserInterfaces.wclrtobot",
    "category": "function",
    "text": "function wclrtobot(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wclrtoeol",
    "page": "Library",
    "title": "TextUserInterfaces.wclrtoeol",
    "category": "function",
    "text": "function wclrtoeol(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.werase",
    "page": "Library",
    "title": "TextUserInterfaces.werase",
    "category": "function",
    "text": "function werase(win::Ptr{WINDOW})\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wgetch",
    "page": "Library",
    "title": "TextUserInterfaces.wgetch",
    "category": "function",
    "text": "function wgetch(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.whline",
    "page": "Library",
    "title": "TextUserInterfaces.whline",
    "category": "function",
    "text": "function whline(win::Ptr{WINDOW}, ch::jlchtype, n::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.window_print-Tuple{TextUserInterfaces.TUI_WINDOW,AbstractString}",
    "page": "Library",
    "title": "TextUserInterfaces.window_print",
    "category": "method",
    "text": "function window_print(win::TUI_WINDOW, [row::Integer,] str::AbstractString; ...)\n\nPrint the string str at the window win in the row row. If the row is negative or omitted, then the current row will be used.\n\nKeywords\n\nalignment: Text alignemnt: :r for left, :c for center, and:lfor              left. (**Default** =:l`)\npad: Padding to print the text. (Default = 0)\n\nRemarks\n\nIf str has multiple lines, then all the lines will be aligned.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.window_println-Tuple{TextUserInterfaces.TUI_WINDOW,AbstractString}",
    "page": "Library",
    "title": "TextUserInterfaces.window_println",
    "category": "method",
    "text": "function window_println(win::TUI_WINDOW, [row::Integer,] str::AbstractString; ...)\n\nPrint the string str at the window win in the row row adding a break line character at the end. If the row is negative or omitted, then the current row will be used.\n\nKeywords\n\nalignment: Text alignemnt: :r for left, :c for center, and:lfor              left. (**Default** =:l`)\npad: Padding to print the text. (Default = 0)\n\nRemarks\n\nIf str has multiple lines, then all the lines will be aligned.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wmove",
    "page": "Library",
    "title": "TextUserInterfaces.wmove",
    "category": "function",
    "text": "function wmove(win::Ptr{WINDOW}, y::Integer, x::Integer)\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wnoutrefresh",
    "page": "Library",
    "title": "TextUserInterfaces.wnoutrefresh",
    "category": "function",
    "text": "function wnoutrefresh(win::Ptr{WINDOW})\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wprintw",
    "page": "Library",
    "title": "TextUserInterfaces.wprintw",
    "category": "function",
    "text": "function wprintw(win::Ptr{WINDOW}, str::T) where T<:AbstractString\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wrefresh",
    "page": "Library",
    "title": "TextUserInterfaces.wrefresh",
    "category": "function",
    "text": "function wrefresh(win::Ptr{WINDOW})\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wtimeout",
    "page": "Library",
    "title": "TextUserInterfaces.wtimeout",
    "category": "function",
    "text": "function wtimeout(win::Ptr{WINDOW}, delay::Integer)\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wvline",
    "page": "Library",
    "title": "TextUserInterfaces.wvline",
    "category": "function",
    "text": "function wvline(win::Ptr{WINDOW}, ch::jlchtype, n::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.NCURSES",
    "page": "Library",
    "title": "TextUserInterfaces.NCURSES",
    "category": "type",
    "text": "struct NCURSES\n\nThis private structure handles some global variables that are used in the ncurses wrapper.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.WINDOW",
    "page": "Library",
    "title": "TextUserInterfaces.WINDOW",
    "category": "type",
    "text": "struct WINDOW\n\nHandles a ncurses window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_window_cur_pos-Tuple{TextUserInterfaces.TUI_WINDOW}",
    "page": "Library",
    "title": "TextUserInterfaces._get_window_cur_pos",
    "category": "method",
    "text": "function _get_window_cur_pos(win::TUI_WINDOW)\n\nGet the cursor position of the window win and return it on a tuple (cur_y,cur_x).  If the window is not initialized, then this function returns (-1,-1).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_window_dims-Tuple{TextUserInterfaces.TUI_WINDOW}",
    "page": "Library",
    "title": "TextUserInterfaces._get_window_dims",
    "category": "method",
    "text": "function _get_window_dims(win::TUI_WINDOW)\n\nGet the dimensions of the window win and return it on a tuple (dim_y,dim_x). If the window is not initialized, then this function returns (-1,-1).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@_ccallf-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.@_ccallf",
    "category": "macro",
    "text": "macro _ccallf(expr)\n\nMake a ccall to a libform function. The usage should be:\n\n@_ccallf function(arg1::Type1, arg2::Type2, ...)::TypeReturn\n\nIt uses the global constant structure ncurses to call the function. Hence, it must be initialized.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@_ccallm-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.@_ccallm",
    "category": "macro",
    "text": "macro _ccallm(expr)\n\nMake a ccall to a libmenu function. The usage should be:\n\n@_ccallf function(arg1::Type1, arg2::Type2, ...)::TypeReturn\n\nIt uses the global constant structure ncurses to call the function. Hence, it must be initialized.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@_ccalln-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.@_ccalln",
    "category": "macro",
    "text": "macro _ccalln(expr)\n\nMake a ccall to a libncurses function. The usage should be:\n\n@_ccalln function(arg1::Type1, arg2::Type2, ...)::TypeReturn\n\nIt uses the global constant structure ncurses to call the function. Hence, it must be initialized.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@_ccallp-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.@_ccallp",
    "category": "macro",
    "text": "macro _ccallm(expr)\n\nMake a ccall to a libpanel function. The usage should be:\n\n@_ccallf function(arg1::Type1, arg2::Type2, ...)::TypeReturn\n\nIt uses the global constant structure ncurses to call the function. Hence, it must be initialized.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#Library-1",
    "page": "Library",
    "title": "Library",
    "category": "section",
    "text": "Documentation for TextUserInterfaces.jl.Modules = [TextUserInterfaces]"
},

]}
