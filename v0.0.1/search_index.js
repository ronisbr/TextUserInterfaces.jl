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
    "location": "lib/library/#TextUserInterfaces.WINDOW",
    "page": "Library",
    "title": "TextUserInterfaces.WINDOW",
    "category": "type",
    "text": "struct WINDOW\n\nHandles a ncurses window.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.TYPE_ALNUM",
    "page": "Library",
    "title": "TextUserInterfaces.TYPE_ALNUM",
    "category": "function",
    "text": "function TYPE_ALNUM()\n\nReturn a pointer to the global symbol TYPE_ALNUM of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.TYPE_ALPHA",
    "page": "Library",
    "title": "TextUserInterfaces.TYPE_ALPHA",
    "category": "function",
    "text": "function TYPE_ALPHA()\n\nReturn a pointer to the global symbol TYPE_ALPHA of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.TYPE_ENUM",
    "page": "Library",
    "title": "TextUserInterfaces.TYPE_ENUM",
    "category": "function",
    "text": "function TYPE_ENUM()\n\nReturn a pointer to the global symbol TYPE_ENUM of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.TYPE_INTEGER",
    "page": "Library",
    "title": "TextUserInterfaces.TYPE_INTEGER",
    "category": "function",
    "text": "function TYPE_INTEGER()\n\nReturn a pointer to the global symbol TYPE_INTEGER of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.TYPE_IPV4",
    "page": "Library",
    "title": "TextUserInterfaces.TYPE_IPV4",
    "category": "function",
    "text": "function TYPE_IPV4()\n\nReturn a pointer to the global symbol TYPE_IPV4 of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.TYPE_IPV6",
    "page": "Library",
    "title": "TextUserInterfaces.TYPE_IPV6",
    "category": "function",
    "text": "function TYPE_IPV6()\n\nReturn a pointer to the global symbol TYPE_IPV6 of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.TYPE_NUMERIC",
    "page": "Library",
    "title": "TextUserInterfaces.TYPE_NUMERIC",
    "category": "function",
    "text": "function TYPE_NUMERIC()\n\nReturn a pointer to the global symbol TYPE_NUMERIC of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.TYPE_REGEXP",
    "page": "Library",
    "title": "TextUserInterfaces.TYPE_REGEXP",
    "category": "function",
    "text": "function TYPE_REGEXP()\n\nReturn a pointer to the global symbol TYPE_REGEXP of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.accept_focus-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.accept_focus",
    "category": "method",
    "text": "function accept_focus(widget)\n\nReturn true is the widget widget accepts focus or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.accept_focus-Tuple{TextUserInterfaces.TUI_FORM}",
    "page": "Library",
    "title": "TextUserInterfaces.accept_focus",
    "category": "method",
    "text": "function accept_focus(form::TUI_FORM)\n\nCommand executed when form form must state whether or not it accepts the focus. If the focus is accepted, then this function returns true. Otherwise, it returns false.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.accept_focus-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.accept_focus",
    "category": "method",
    "text": "function accept_focus(menu::TUI_MENU)\n\nCommand executed when menu menu must state whether or not it accepts the focus. If the focus is accepted, then this function returns true. Otherwise, it returns false.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.accept_focus-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.accept_focus",
    "category": "method",
    "text": "function accept_focus(window::Window)\n\nCheck if the window window can accept focus and, if it can, then perform the actions to change the focus.\n\n\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.bottom_panel",
    "page": "Library",
    "title": "TextUserInterfaces.bottom_panel",
    "category": "function",
    "text": "function bottom_panel(pan::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.change_text-Tuple{WidgetLabel,AbstractString}",
    "page": "Library",
    "title": "TextUserInterfaces.change_text",
    "category": "method",
    "text": "function change_text(widget::WidgetLabel, new_text::AbstractString; alignment = :l, color::Int = -1)\n\nChange to text of the label widget widget to new_text.\n\nThe text alignment in the widget can be selected by the keyword alignment, which can be:\n\n:l: left alignment (default);\n:c: Center alignment; or\n:r: Right alignment.\n\nThe text color can be selected by the keyword color. It it is negative (default), then the current color will not be changed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.change_value-Tuple{WidgetProgressBar,Integer}",
    "page": "Library",
    "title": "TextUserInterfaces.change_value",
    "category": "method",
    "text": "function change_value(widget::WidgetProgressBar, new_value::Integer; color::Int = -1)\n\nChange the value of the progress bar to new_value.\n\nThe color can be selected by the keyword color. It it is negative (default), then the current color will not be changed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.clear",
    "page": "Library",
    "title": "TextUserInterfaces.clear",
    "category": "function",
    "text": "function clear()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.copywin",
    "page": "Library",
    "title": "TextUserInterfaces.copywin",
    "category": "function",
    "text": "function copywin(scr::Ptr{WINDOW}, dest::Ptr{WINDOW}, sminrow::Integer, smincol::Integer, dminrow::Integer, dmincol::Integer, dmaxrow::Integer, dmaxcol::Integer, overlay::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_field",
    "page": "Library",
    "title": "TextUserInterfaces.create_field",
    "category": "function",
    "text": "function create_field(height::Int, width::Int, y::Int, x::Int, buffer::String = \"\", id::String = \"\", offscreen::Int = 0, nbuffers::Int = 0; ...)\n\nCreate a field with id id, height height and width width, positioned at y and x coordinates. The initial buffer string can be set by the variable buffer. The number of off-screen rows is set by offscreen and the number of buffers nbuffers.\n\nKeywords\n\ncolor_foreground: Color mask that will be used in the field foreground. See                     function ncurses_color. If negative, then the color will                     not be changed. (Default = -1)\ncolor_background: Color mask that will be used in the field background. See                     function ncurses_color. If negative, then the color will                     not be changed. (Default = -1)\njustification: Justification of the form. It can be :l for left, :c for                  center, and :r for right. For any other symbol, the left                  justification is used. (Default = :l)\nvisible: If true, then the control is visible on the screen.            (Default = true)\nactive: If true, then the control is active. (Default = true)\npublic: If true, then the data of the field is displayed during entry. For           example, set this to false for password fields.           (Default = true)\nedit: If true, then the data of the field can be modified.         (Default = true)\nwrap: If true, then the word will be wrapped in multi-line fields.         (Default = true)\nblank: If true, then entering a character at the first field position          erases the entire fields. (Default = false)\nautoskip: If true, then the field will be automatically skipped when             filled. (Default = false)\nnullok: If true, then the validation is not applied to blank fields.           (Default = true)\npassok: If true, then the validation will occur on every exit. Otherwise,           it will only occur when the field is modified.           (Default = false)\nstatic: If true, then the field is fixed to the initial dimensions.           Otherwise, it will stretch to fit the entered data.           (Default = true)\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_form-Tuple{Array{TextUserInterfaces.TUI_FIELD,1}}",
    "page": "Library",
    "title": "TextUserInterfaces.create_form",
    "category": "method",
    "text": "function create_form(fields::Vector{TUI_FIELD}; ...)\n\nCreate a new form with the fields fields.\n\nKeywords\n\nnewline_overload: Enable overloading of REQ_NEW_LINE.                     (Default = false)\nbackspace_overload: Enable overloading of REQ_DEL_PREV.                       (Default = false)\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_menu-Union{Tuple{Array{T1,1}}, Tuple{T2}, Tuple{T1}, Tuple{Array{T1,1},Union{Nothing, Array{T2,1}}}} where T2<:AbstractString where T1<:AbstractString",
    "page": "Library",
    "title": "TextUserInterfaces.create_menu",
    "category": "method",
    "text": "function create_menu(names::Vector{T1}, descriptions::Union{Nothing,Vector{T2}} = nothing; kwargs...)\n\nCreate a menu with the names names and descriptions descriptions. If descriptions is nothing or is omitted, then the menu descriptions will not be shown.\n\nKeywords\n\nformat: If nothing, then the default menu format will be used. Otherwise,           it must be a tuple with two integers describing respectively the           number of rows and columns. (Default = nothing)\nmark: The menu mark. (Default = -)\none_value: If true, then the menu cannot have multiple selections.              (Default = true)\nshow_desc: If true, then the menu description will be shown.              (Default = true)\nrow_major: If true, then the menu will be constructed in a row-major              ordering.\nignore_case: If true, then the case will be ignored on pattern matching.\nshow_match: If true, then the cursor will be moved to within the item name               while pattern-matching.\nnon_cyclic: If true, then the menu will be non cyclic.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_widget",
    "page": "Library",
    "title": "TextUserInterfaces.create_widget",
    "category": "function",
    "text": "function create_widget(T, parent::Window, begin_y::Integer, begin_x::Integer, vargs...; kwargs...)\n\nCreate the widget of type T in the parent window parent. The widget will be positioned on the coordinate (begin_y, begin_x) of the parent window.\n\nAdditional variables and keywords related to each widget can be passed using vargs and kwargs respectively.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_window",
    "page": "Library",
    "title": "TextUserInterfaces.create_window",
    "category": "function",
    "text": "function create_window(nlines::Integer, ncols::Integer, begin_y::Integer, begin_x::Integer, id::String = \"\"; bcols::Integer = 0, blines::Integer = 0, border::Bool = true, border_color::Int = -1, title::String = \"\", title_color::Int = -1)\n\nCreate a window. The new window size will be nlines × ncols and the origin will be placed at (begin_y, begin_x) coordinate of the root window. The window ID id is used to identify the new window in the global window list.\n\nKeyword\n\nbcols: Number of columns in the window buffer. This will be automatically          increased to, at least, fit the viewable part of the window          (ncols). (Default = 0)\nblines: Number of lines in the window buffer. This will be automatically           increased to, at least, fit the viewable part of the window           (nlines). (Default = 0)\nborder: If true, then the window will have a border. (Default =           true)\nborder_color: Color mask that will be used to print the border. See function                 ncurses_color. If negative, then the color will not be                 changed. (Default = -1)\nfocusable: If true, then the window can have focus. Otherwise, all focus              request will be rejected. (Default = true)\ntitle: The title of the window, which will only be printed if border is          true. (Default = \"\")\ntitle_color: Color mask that will be used to print the title. See                function ncurses_color. If negative, then the color will not                be changed. (Default = -1)\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.curses_version-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.curses_version",
    "category": "method",
    "text": "function curses_version()\n\nReturn the NCurses version in a named tuple with the following fields:\n\nmajor: Major version.\nminor: Minor version.\npatch: Patch version.\n\n\n\n\n\n"
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
    "text": "function derwin(win::Ptr{WINDOW}, nlines::Integer, ncols::Integer, begin_y::Integer, begin_x::Integer)\n\nReturn type: Ptr{WINDOW}\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_all_windows-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_all_windows",
    "category": "method",
    "text": "function destroy_all_windows()\n\nDestroy all windows managed by the TUI.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_field-Tuple{TextUserInterfaces.TUI_FIELD}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_field",
    "category": "method",
    "text": "function destroy_field(field::Ptr{Cvoid})\n\nDestroy the field field.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_form-Tuple{TextUserInterfaces.TUI_FORM}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_form",
    "category": "method",
    "text": "function destroy_form(form::TUI_FORM)\n\nDestroy the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_menu-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_menu",
    "category": "method",
    "text": "function destroy_menu(menu::TUI_MENU)\n\nDestroy the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_tui-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_tui",
    "category": "method",
    "text": "function destroy_tui()\n\nDestroy the Text User Interface (TUI).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_widget-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_widget",
    "category": "method",
    "text": "function destroy_widget(widget; refresh::Bool = true)\n\nDestroy the widget widget.\n\nIf refresh is true (default), then a full refresh will be performed on the parent window. Otherwise, no refresh will be performed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_window-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_window",
    "category": "method",
    "text": "function destroy_window(win::Window)\n\nDestroy the window win.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.field_buffer-Tuple{Ptr{Nothing},Integer}",
    "page": "Library",
    "title": "TextUserInterfaces.field_buffer",
    "category": "method",
    "text": "function field_buffer(field::Ptr{Cvoid}, buffer::Integer)\n\nReturn type: Cstring\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.focus_on_widget-Tuple{Widget}",
    "page": "Library",
    "title": "TextUserInterfaces.focus_on_widget",
    "category": "method",
    "text": "function focus_on_widget(widget::Widget)\n\nMove focus to the widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.focus_on_widget-Tuple{Window,Integer}",
    "page": "Library",
    "title": "TextUserInterfaces.focus_on_widget",
    "category": "method",
    "text": "function focus_on_widget(window::Window, id::Integer)\n\nMove focus to the widget ID id on window window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_add_char-Tuple{TextUserInterfaces.TUI_FORM,UInt32}",
    "page": "Library",
    "title": "TextUserInterfaces.form_add_char",
    "category": "method",
    "text": "function form_add_char(form::TUI_FORM, ch::Int)\n\nAdd the character ch to the active field of the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_beg_field",
    "page": "Library",
    "title": "TextUserInterfaces.form_beg_field",
    "category": "function",
    "text": "function form_beg_field(form::TUI_FORM)\n\nMove to the beginning of the active field in the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_del_char",
    "page": "Library",
    "title": "TextUserInterfaces.form_del_char",
    "category": "function",
    "text": "function form_del_char(form::TUI_FORM)\n\nDelete the character at the cursor of the active field in the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_del_prev",
    "page": "Library",
    "title": "TextUserInterfaces.form_del_prev",
    "category": "function",
    "text": "function form_del_prev(form::TUI_FORM)\n\nDelete the previous character from the cursor of the active field in the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_down_char",
    "page": "Library",
    "title": "TextUserInterfaces.form_down_char",
    "category": "function",
    "text": "function form_down_char(form::TUI_FORM)\n\nMove to the down character of the active field in the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_driver-Tuple{Ptr{Nothing},Integer}",
    "page": "Library",
    "title": "TextUserInterfaces.form_driver",
    "category": "method",
    "text": "function form_driver(form::Ptr{Cvoid}, ch::Integer)\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_end_field",
    "page": "Library",
    "title": "TextUserInterfaces.form_end_field",
    "category": "function",
    "text": "function form_end_field(form::TUI_FORM)\n\nMove to the end of the active field in the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_left_char",
    "page": "Library",
    "title": "TextUserInterfaces.form_left_char",
    "category": "function",
    "text": "function form_left_char(form::TUI_FORM)\n\nMove to the left character of the active field in the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_next_char",
    "page": "Library",
    "title": "TextUserInterfaces.form_next_char",
    "category": "function",
    "text": "function form_next_char(form::TUI_FORM)\n\nMove to the next character of the active field in the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_next_field",
    "page": "Library",
    "title": "TextUserInterfaces.form_next_field",
    "category": "function",
    "text": "function form_next_field(form::TUI_FORM)\n\nMove to the next field of the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_prev_char",
    "page": "Library",
    "title": "TextUserInterfaces.form_prev_char",
    "category": "function",
    "text": "function form_prev_char(form::TUI_FORM)\n\nMove to the previous character of the active field in the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_prev_field",
    "page": "Library",
    "title": "TextUserInterfaces.form_prev_field",
    "category": "function",
    "text": "function form_prev_field(form::TUI_FORM)\n\nMove to the previous field of the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_right_char",
    "page": "Library",
    "title": "TextUserInterfaces.form_right_char",
    "category": "function",
    "text": "function form_right_char(form::TUI_FORM)\n\nMove to the right character of the active field in the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.form_up_char",
    "page": "Library",
    "title": "TextUserInterfaces.form_up_char",
    "category": "function",
    "text": "function form_up_char(form::TUI_FORM)\n\nMove to the up character of the active field in the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.free_field-Tuple{Ptr{Nothing}}",
    "page": "Library",
    "title": "TextUserInterfaces.free_field",
    "category": "method",
    "text": "function free_field(field::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.free_form-Tuple{Ptr{Nothing}}",
    "page": "Library",
    "title": "TextUserInterfaces.free_form",
    "category": "method",
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
    "location": "lib/library/#TextUserInterfaces.get_color_pair-Tuple{Symbol,Symbol}",
    "page": "Library",
    "title": "TextUserInterfaces.get_color_pair",
    "category": "method",
    "text": "function get_color_pair(foreground::Symbol, background::Symbol)\n\nReturn the ID of the color pair (foreground, background), or nothing if the color pair is not initialized.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_field_data",
    "page": "Library",
    "title": "TextUserInterfaces.get_field_data",
    "category": "function",
    "text": "function get_field_data(form::TUI_FORM, field_id::String, buffer::Int = 0)\n\nGet the data of the field with ID field_id at buffer buffer in the form form\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_field_data",
    "page": "Library",
    "title": "TextUserInterfaces.get_field_data",
    "category": "function",
    "text": "function get_field_data(field::TUI_FIELD, buffer::Int = 0)\n\nGet the data of the field field at buffer buffer.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_focused_window-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.get_focused_window",
    "category": "method",
    "text": "function get_focused_window()\n\nReturn the focused window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.getbegx",
    "page": "Library",
    "title": "TextUserInterfaces.getbegx",
    "category": "function",
    "text": "function getbegx(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.getbegy",
    "page": "Library",
    "title": "TextUserInterfaces.getbegy",
    "category": "function",
    "text": "function getbegy(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.getch",
    "page": "Library",
    "title": "TextUserInterfaces.getch",
    "category": "function",
    "text": "function getch()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.getcurx",
    "page": "Library",
    "title": "TextUserInterfaces.getcurx",
    "category": "function",
    "text": "function getcurx(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.getcury",
    "page": "Library",
    "title": "TextUserInterfaces.getcury",
    "category": "function",
    "text": "function getcury(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.getmaxx",
    "page": "Library",
    "title": "TextUserInterfaces.getmaxx",
    "category": "function",
    "text": "function getmaxx(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.getmaxy",
    "page": "Library",
    "title": "TextUserInterfaces.getmaxy",
    "category": "function",
    "text": "function getmaxy(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.has_colors",
    "page": "Library",
    "title": "TextUserInterfaces.has_colors",
    "category": "function",
    "text": "function has_colors()\n\nReturn type: UInt8\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.has_focus-Tuple{Window,Any}",
    "page": "Library",
    "title": "TextUserInterfaces.has_focus",
    "category": "method",
    "text": "function has_focus(window::Window, widget)\n\nReturn true if the widget widget is in focus on window window, or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.hide_panel",
    "page": "Library",
    "title": "TextUserInterfaces.hide_panel",
    "category": "function",
    "text": "function hide_panel(panel::Ptr{Cvoid})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.hide_window-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.hide_window",
    "category": "method",
    "text": "function hide_window(win::Window)\n\nHide the window win.\n\n\n\n\n\n"
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
    "text": "function init_color(color::Integer, r::Integer, g::Integer, b::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.init_color-Tuple{Symbol,Int64,Int64,Int64}",
    "page": "Library",
    "title": "TextUserInterfaces.init_color",
    "category": "method",
    "text": "function init_color(name::Symbol, r::Int, g::Int, b::Int)\n\nInitialize the color with name name and RGB color r, g, and b.  Notice that the range for the last three variables is [0,1000].\n\nIf the color is already initialized, then nothing will be changed.\n\nIf the color was initialized, then it returns the color ID. Otherwise, it returns -1.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.init_color_pair-Tuple{Symbol,Symbol}",
    "page": "Library",
    "title": "TextUserInterfaces.init_color_pair",
    "category": "method",
    "text": "function init_color_pair(foreground::Symbol, background::Symbol)\n\nInitialize the color pair (foreground, background) and return its ID. If the pair already exists, then just the function just returns its ID.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.init_focus_manager-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.init_focus_manager",
    "category": "method",
    "text": "function init_focus_manager()\n\nInitialization of the focus manager. The elements in focus_chain are iterated to find the first one that can accept the focus.\n\n\n\n\n\n"
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
    "text": "function initscr()\n\nReturn type: Ptr{WINDOW}\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
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
    "text": "function jlgetch(win::Union{Ptr{WINDOW},Nothing} = nothing)\n\nWait for an keystroke in the window win and return it (see Keystroke).  If win is nothing, then getch() will be used instead of wgetch(win) to listen for the keystroke.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.keypad",
    "page": "Library",
    "title": "TextUserInterfaces.keypad",
    "category": "function",
    "text": "function keypad(win::Ptr{WINDOW}, bf::Bool)\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.leaveok",
    "page": "Library",
    "title": "TextUserInterfaces.leaveok",
    "category": "function",
    "text": "function leaveok(win::Ptr{WINDOW}, bf::Bool)\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.log_message",
    "page": "Library",
    "title": "TextUserInterfaces.log_message",
    "category": "function",
    "text": "function log_message(level::Int, msg::AbstractString, id::AbstractString = \"\")\n\nLog the message msg with level level. The ID of the called can be specified by id.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.move_panel",
    "page": "Library",
    "title": "TextUserInterfaces.move_panel",
    "category": "function",
    "text": "function move_panel(panel::Ptr{Cvoid}, starty::Integer, startx::Integer)\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.move_view-Tuple{Window,Integer,Integer}",
    "page": "Library",
    "title": "TextUserInterfaces.move_view",
    "category": "method",
    "text": "function move_view(win::Window, y::Integer, x::Integer; update::Bool = true)\n\nMove the origin of the view of window win to the position (y,x). This routine makes sure that the view will never reach positions outside the buffer.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.move_view_inc-Tuple{Window,Integer,Integer}",
    "page": "Library",
    "title": "TextUserInterfaces.move_view_inc",
    "category": "method",
    "text": "function move_view_inc(win::Window; Δy::Integer, Δx::Integer; kwargs...)\n\nMove the view of the window win to the position (y+Δy, x+Δx). This function has the same set of keywords of the function move_view.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.move_window-Tuple{Window,Integer,Integer}",
    "page": "Library",
    "title": "TextUserInterfaces.move_window",
    "category": "method",
    "text": "function move_window(win::Window, starty::Integer, startx::Integer)\n\nMove the window win to the position (starty, startx).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.move_window_to_top-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.move_window_to_top",
    "category": "method",
    "text": "function move_window_to_top(win::Window)\n\nMove window win to the top.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.ncurses_color",
    "page": "Library",
    "title": "TextUserInterfaces.ncurses_color",
    "category": "function",
    "text": "function ncurses_color([foreground::Symbol, background::Symbol,] attrs::Int = 0; kwargs...)\n\nReturn a mask to apply a color format with the foreground color foreground, background color background, and the attributes attrs.\n\nIf the pair (foreground, background) is omitted, then the foreground and background color will not be changed.\n\nKeywords\n\nbold: If true, then apply bold format mask to attrs.         (Default = false)\nunderline: If true, then apply underline format mask to attrs.              (Default = false)\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.new_form-Tuple{Array{Ptr{Nothing},1}}",
    "page": "Library",
    "title": "TextUserInterfaces.new_form",
    "category": "method",
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
    "location": "lib/library/#TextUserInterfaces.newpad",
    "page": "Library",
    "title": "TextUserInterfaces.newpad",
    "category": "function",
    "text": "function newpad(lines::Integer, cols::Integer)\n\nReturn type: Ptr{WINDOW}\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.newwin",
    "page": "Library",
    "title": "TextUserInterfaces.newwin",
    "category": "function",
    "text": "function newwin(lines::Integer, cols::Integer, y::Integer, x::Integer)\n\nReturn type: Ptr{WINDOW}\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.next_widget-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.next_widget",
    "category": "method",
    "text": "function next_widget(window::Window)\n\nMove the focus of window window to the next widget.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.obj_desc-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.obj_desc",
    "category": "method",
    "text": "function obj_desc(obj)\n\nReturn a string with the description of the object obj formed by:\n\n<Object type> (<Object address if mutable>)\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.obj_to_ptr-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.obj_to_ptr",
    "category": "method",
    "text": " function obj_to_ptr(obj)\n\nReturns the hexadecimal representation of the address of the object obj. It only works with mutable objects.  If obj is immutable, then 0x0 will be returned.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.panel_userptr",
    "page": "Library",
    "title": "TextUserInterfaces.panel_userptr",
    "category": "function",
    "text": "function panel_userptr(pan::Ptr{Cvoid})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.pnoutrefresh",
    "page": "Library",
    "title": "TextUserInterfaces.pnoutrefresh",
    "category": "function",
    "text": "function pnoutrefresh(win::Ptr{WINDOW}, pminrow::Integer, pmincol::Integer, sminrow::Integer, smincol::Integer, smaxrow::Integer, smaxcol::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.pos_form_cursor-Tuple{Ptr{Nothing}}",
    "page": "Library",
    "title": "TextUserInterfaces.pos_form_cursor",
    "category": "method",
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
    "location": "lib/library/#TextUserInterfaces.post_form-Tuple{Ptr{Nothing}}",
    "page": "Library",
    "title": "TextUserInterfaces.post_form",
    "category": "method",
    "text": "function post_form(form::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.post_form-Tuple{TextUserInterfaces.TUI_FORM}",
    "page": "Library",
    "title": "TextUserInterfaces.post_form",
    "category": "method",
    "text": "function post_form(form::TUI_FORM)\n\nPost the for form.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.prefresh",
    "page": "Library",
    "title": "TextUserInterfaces.prefresh",
    "category": "function",
    "text": "function prefresh(win::Ptr{WINDOW}, pminrow::Integer, pmincol::Integer, sminrow::Integer, smincol::Integer, smaxrow::Integer, smaxcol::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.previous_widget-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.previous_widget",
    "category": "method",
    "text": "function previous_widget(window::Window)\n\nMove the focus of window window to the previous widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.printw",
    "page": "Library",
    "title": "TextUserInterfaces.printw",
    "category": "function",
    "text": "function printw(str::T) where T<:AbstractString\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.process_focus-Tuple{Any,Keystroke}",
    "page": "Library",
    "title": "TextUserInterfaces.process_focus",
    "category": "method",
    "text": "function process_focus(widget, k::Keystroke)\n\nProcess the actions when widget widget is in focus and the keystroke k is pressed. If it returns false, then it is means that the widget was not capable to process the focus. Otherwise, it must return true.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.process_focus-Tuple{Keystroke}",
    "page": "Library",
    "title": "TextUserInterfaces.process_focus",
    "category": "method",
    "text": "function process_focus(k::Keystroke)\n\nProcess the focus considering the user\'s keystorke k.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.process_focus-Tuple{TextUserInterfaces.TUI_FORM,Keystroke}",
    "page": "Library",
    "title": "TextUserInterfaces.process_focus",
    "category": "method",
    "text": "function process_focus(form::TUI_FORM, k::Keystroke)\n\nProcess the actions when the form form is in focus and the keystroke k was issued by the user.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.process_focus-Tuple{TextUserInterfaces.TUI_MENU,Keystroke}",
    "page": "Library",
    "title": "TextUserInterfaces.process_focus",
    "category": "method",
    "text": "function process_focus(menu::TUI_MENU, k::Keystroke)\n\nProcess the actions when the menu menu is in focus and the keystroke k was issued by the user.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.process_focus-Tuple{Window,Keystroke}",
    "page": "Library",
    "title": "TextUserInterfaces.process_focus",
    "category": "method",
    "text": "function process_focus(window::Window, k::Keystroke)\n\nProcess the focus on window window due to keystroke k.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.redraw",
    "page": "Library",
    "title": "TextUserInterfaces.redraw",
    "category": "function",
    "text": "function redraw(widget)\n\nRedraw the widget inside its content window cwin.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.refresh_window-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.refresh_window",
    "category": "method",
    "text": "function refresh_window(win::Window; update = true, backpropagation = true)\n\nRefresh the window win and all its child windows. If the view needs to be updated (see view_needs_update), then the content of the buffer will be copied to the view before updating.\n\nIf update is true, then doupdate() is called and the physical screen is updated.\n\nIf backpropagation is true, then all the parents windows (except from the root window) will also be refreshed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.release_focus-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.release_focus",
    "category": "method",
    "text": "function release_focus(widget)\n\nRequest focus to be released. It should return true if the focus can be released or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.release_focus-Tuple{TextUserInterfaces.TUI_FORM}",
    "page": "Library",
    "title": "TextUserInterfaces.release_focus",
    "category": "method",
    "text": "function release_focus(form::TUI_FORM)\n\nRelease the focus from the form form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.release_focus-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.release_focus",
    "category": "method",
    "text": "function release_focus(menu::TUI_MENU)\n\nRelease the focus from the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_update-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.request_update",
    "category": "method",
    "text": "function request_update(widget)\n\nRequest update of the widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.resizeterm",
    "page": "Library",
    "title": "TextUserInterfaces.resizeterm",
    "category": "function",
    "text": "function resizeterm(lines::Integer, columns::Integer)\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.set_color-Tuple{Int64}",
    "page": "Library",
    "title": "TextUserInterfaces.set_color",
    "category": "method",
    "text": "function set_color([win::Window,] color::Int)\n\nSet the color of the window win to color (see ncurses_color). If win is omitted, then it defaults to the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_field_back-Tuple{Ptr{Nothing},Integer}",
    "page": "Library",
    "title": "TextUserInterfaces.set_field_back",
    "category": "method",
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
    "location": "lib/library/#TextUserInterfaces.set_field_just-Tuple{Ptr{Nothing},Integer}",
    "page": "Library",
    "title": "TextUserInterfaces.set_field_just",
    "category": "method",
    "text": "function set_field_just(field::Ptr{Cvoid}, justification::Integer)\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_field_opts-Tuple{Ptr{Nothing},Integer}",
    "page": "Library",
    "title": "TextUserInterfaces.set_field_opts",
    "category": "method",
    "text": "function set_field_opts(field::Ptr{Cvoid}, field_options::Integer)\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_field_type-Tuple{Ptr{Nothing},Ptr{Nothing},Array{T,1} where T,Integer,Integer}",
    "page": "Library",
    "title": "TextUserInterfaces.set_field_type",
    "category": "method",
    "text": "function set_field_type(field::Ptr{Cvoid}, type::Ptr{Cvoid}, valuelist::Vector, checkcase::Integer, checkunique::Integer)\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_field_type-Tuple{Ptr{Nothing},Ptr{Nothing},Integer,Float64,Float64}",
    "page": "Library",
    "title": "TextUserInterfaces.set_field_type",
    "category": "method",
    "text": "function set_field_type(field::Ptr{Cvoid}, type::Ptr{Cvoid}, padding::Integer, vmin::Float64, vmax::Float64)\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_field_type-Tuple{Ptr{Nothing},Ptr{Nothing},Integer,Integer,Integer}",
    "page": "Library",
    "title": "TextUserInterfaces.set_field_type",
    "category": "method",
    "text": "function set_field_type(field::Ptr{Cvoid}, type::Ptr{Cvoid}, padding::Integer, vmin::Integer, vmax::Integer)\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_field_type-Tuple{Ptr{Nothing},Ptr{Nothing},Integer}",
    "page": "Library",
    "title": "TextUserInterfaces.set_field_type",
    "category": "method",
    "text": "function set_field_type(field::Ptr{Cvoid}, type::Ptr{Cvoid}, arg::Integer)\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_field_type-Tuple{Ptr{Nothing},Ptr{Nothing},String}",
    "page": "Library",
    "title": "TextUserInterfaces.set_field_type",
    "category": "method",
    "text": "function set_field_type(field::Ptr{Cvoid}, type::Ptr{Cvoid}, regex::String)\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_focus_chain-Tuple{Vararg{Window,N} where N}",
    "page": "Library",
    "title": "TextUserInterfaces.set_focus_chain",
    "category": "method",
    "text": "function set_focus_chain(wins::Window...; new_focus_id::Integer = 1)\n\nSet the focus chain, i.e. the ordered list of windows that can receive the focus. The keyword new_focus_id can be set to specify which element is currently focused in the new chain.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_form_opts-Tuple{Ptr{Nothing},Integer}",
    "page": "Library",
    "title": "TextUserInterfaces.set_form_opts",
    "category": "method",
    "text": "function set_form_opts(form::Ptr{Cvoid}, form_options::Integer)\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_form_sub-Tuple{Ptr{Nothing},Ptr{WINDOW}}",
    "page": "Library",
    "title": "TextUserInterfaces.set_form_sub",
    "category": "method",
    "text": "function set_form_sub(form::Ptr{Cvoid}, win_form::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_form_win-Tuple{Ptr{Nothing},Ptr{WINDOW}}",
    "page": "Library",
    "title": "TextUserInterfaces.set_form_win",
    "category": "method",
    "text": "function set_form_win(form::Ptr{Cvoid}, win_form::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_form_win-Tuple{TextUserInterfaces.TUI_FORM,Window}",
    "page": "Library",
    "title": "TextUserInterfaces.set_form_win",
    "category": "method",
    "text": "function set_form_win(form::TUI_FORM, win::Window)\n\nSet the form form window to win.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.set_menu_win",
    "page": "Library",
    "title": "TextUserInterfaces.set_menu_win",
    "category": "function",
    "text": "function set_menu_win(menu::Ptr{Cvoid}, win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_menu_win-Tuple{TextUserInterfaces.TUI_MENU,Window}",
    "page": "Library",
    "title": "TextUserInterfaces.set_menu_win",
    "category": "method",
    "text": "function set_menu_win(menu::TUI_MENU, win::Window)\n\nSet menu menu window to win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_next_window_func-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.set_next_window_func",
    "category": "method",
    "text": "function set_next_window_func(f)\n\nSet the function f to be the one that will be called to check whether the user wants the next window. The signature must be:\n\nf(k::Keystroke)::Bool\n\nIt must return true if the next window is required of false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_panel_userptr",
    "page": "Library",
    "title": "TextUserInterfaces.set_panel_userptr",
    "category": "function",
    "text": "function set_panel_userptr(pan::Ptr{Cvoid}, ptr::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_previous_window_func-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.set_previous_window_func",
    "category": "method",
    "text": "function set_previous_window_func(f)\n\nSet the function f to be the one that will be called to check whether the user wants the previous window. The signature must be:\n\nf(k::Keystroke)::Bool\n\nIt must return true if the previous window is required of false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_window_title-Tuple{Window,AbstractString}",
    "page": "Library",
    "title": "TextUserInterfaces.set_window_title",
    "category": "method",
    "text": "function set_window_title(win::Window, title::AbstractString; ...)\n\nSet the title of the window win to title.\n\nKeywords\n\ntitle_color: Color mask that will be used to print the title. See                function ncurses_color. If negative, then the color will not                be changed. (Default = -1)\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.show_panel",
    "page": "Library",
    "title": "TextUserInterfaces.show_panel",
    "category": "function",
    "text": "function show_panel(panel::Ptr{Cvoid})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.show_window-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.show_window",
    "category": "method",
    "text": "function show_window(win::Window)\n\nShow the window win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.start_color",
    "page": "Library",
    "title": "TextUserInterfaces.start_color",
    "category": "function",
    "text": "function start_color()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.subpad",
    "page": "Library",
    "title": "TextUserInterfaces.subpad",
    "category": "function",
    "text": "function subpad(win::Ptr{WINDOW}, nlines::Integer, ncols::Integer, begin_y::Integer, begin_x::Integer)\n\nReturn type: Ptr{WINDOW}\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.sync_cursor-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.sync_cursor",
    "category": "method",
    "text": "function sync_cursor(window::Window)\n\nSynchronize the cursor to the position of the focused widget in window window. This is necessary because all the operations are done in the buffer and then copied to the view.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.top_panel",
    "page": "Library",
    "title": "TextUserInterfaces.top_panel",
    "category": "function",
    "text": "function top_panel(pan::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.touchwin",
    "page": "Library",
    "title": "TextUserInterfaces.touchwin",
    "category": "function",
    "text": "function touchwin(win::Ptr{WINDOW})\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.unpost_form-Tuple{Ptr{Nothing}}",
    "page": "Library",
    "title": "TextUserInterfaces.unpost_form",
    "category": "method",
    "text": "function unpost_form(form::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.unpost_form-Tuple{TextUserInterfaces.TUI_FORM}",
    "page": "Library",
    "title": "TextUserInterfaces.unpost_form",
    "category": "method",
    "text": "function unpost_form(form::TUI_FORM)\n\nUnpost the form form.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.unset_color-Tuple{Int64}",
    "page": "Library",
    "title": "TextUserInterfaces.unset_color",
    "category": "method",
    "text": "function unset_color([win::Window,] color::Number)\n\nUnset the color color (see ncurses_color) in the window win. If win is omitted, then it defaults to the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.update-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.update",
    "category": "method",
    "text": "function update(widget; force_redraw = false)\n\nUpdate the widget by calling the function redraw. This function returns true if the widget needed to be updated of false otherwise.\n\nIf force_redraw is true, then the widget will be updated even if it is not needed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.update_panels",
    "page": "Library",
    "title": "TextUserInterfaces.update_panels",
    "category": "function",
    "text": "function update_panels()\n\nReturn type: Nothing\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.update_view-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.update_view",
    "category": "method",
    "text": "function update_view(win::Window; force::Bool = false)\n\nUpdate the view of window win by copying the contents from the buffer. If the view does not need to be updated (see view_needs_update), then nothing is done. If the keyword force is true, then the copy will always happen.\n\nReturn\n\nIt returns true if the view has been updated and false otherwise.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.wborder-Tuple{Ptr{WINDOW}}",
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
    "location": "lib/library/#TextUserInterfaces.@log-Tuple{Any,Any,Any}",
    "page": "Library",
    "title": "TextUserInterfaces.@log",
    "category": "macro",
    "text": "macro log(level, msg, id)\n\nLog the messagem msg with level level of the caller id\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@log-Tuple{Any,Any}",
    "page": "Library",
    "title": "TextUserInterfaces.@log",
    "category": "macro",
    "text": "macro log(level, msg)\n\nLog the message msg with level level.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.NCURSES",
    "page": "Library",
    "title": "TextUserInterfaces.NCURSES",
    "category": "type",
    "text": "struct NCURSES\n\nThis private structure handles some global variables that are used in the ncurses wrapper.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_window_cur_pos-Tuple{Ptr{WINDOW}}",
    "page": "Library",
    "title": "TextUserInterfaces._get_window_cur_pos",
    "category": "method",
    "text": "function _get_window_cur_pos(win::Ptr{WINDOW})\n\nGet the cursor position of the window win and return it on a tuple (cur_y,cur_x).  If the window is not initialized, then this function returns (-1,-1).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_window_dims-Tuple{Ptr{WINDOW}}",
    "page": "Library",
    "title": "TextUserInterfaces._get_window_dims",
    "category": "method",
    "text": "function _get_window_dims(win::Ptr{WINDOW})\n\nGet the dimensions of the window win and return it on a tuple (dim_y,dim_x). If the window is not initialized, then this function returns (-1,-1).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.next_window-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.next_window",
    "category": "method",
    "text": "function next_window()\n\nMove the focus to the next window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.previous_window-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.previous_window",
    "category": "method",
    "text": "function previous_window()\n\nMove the focus to the previous window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_view_update-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.request_view_update",
    "category": "method",
    "text": "function request_view_update(win::Window)\n\nRequest to update the view of window win. Notice that this must also request update on all parent windows until the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.require_cursor-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.require_cursor",
    "category": "method",
    "text": "function require_cursor()\n\nIf true, then the physical cursor will be shown and the position will be updated according to its position in the widget window. Otherwise, the physical cursor will be hidden.\n\n\n\n\n\n"
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
