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
    "location": "lib/library/#TextUserInterfaces.Keystroke",
    "page": "Library",
    "title": "TextUserInterfaces.Keystroke",
    "category": "type",
    "text": "struct Keystorke\n\nStructure that defines a keystroke.\n\nFields\n\nvalue: String representing the keystroke.\nktype: Type of the key (:char, :F1, :up, etc.).\nalt: true if ALT key was pressed (only valid if ktype != :char).\nctrl: true if CTRL key was pressed (only valid if ktype != :char).\nshift: true if SHIFT key was pressed (only valid if ktype != :char).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.accept_focus-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.accept_focus",
    "category": "method",
    "text": "accept_focus(widget)\n\nReturn true is the widget widget accepts focus or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.accept_focus-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.accept_focus",
    "category": "method",
    "text": "accept_focus(menu::TUI_MENU)\n\nCommand executed when menu menu must state whether or not it accepts the focus. If the focus is accepted, then this function returns true. Otherwise, it returns false.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.accept_focus-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.accept_focus",
    "category": "method",
    "text": "accept_focus(window::Window)\n\nCheck if the window window can accept focus and, if it can, then perform the actions to change the focus.\n\n\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.add_widget-Tuple{WidgetContainer,Widget}",
    "page": "Library",
    "title": "TextUserInterfaces.add_widget",
    "category": "method",
    "text": "add_widget(container::WidgetContainer, widget::Widget)\n\nAdd the widget widget to the container `container.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.add_widget-Tuple{Window,Widget}",
    "page": "Library",
    "title": "TextUserInterfaces.add_widget",
    "category": "method",
    "text": "add_widget(win::Window, widget::Widget)\n\nAdd widget widget to the window win. If the win already have a widget, then it will be replaced.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.change_label-Tuple{WidgetButton,AbstractString}",
    "page": "Library",
    "title": "TextUserInterfaces.change_label",
    "category": "method",
    "text": "change_label(button::WidgetButton, label::AbstractString)\n\nChange the label of button button to label.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.change_text-Tuple{WidgetANSILabel,AbstractString}",
    "page": "Library",
    "title": "TextUserInterfaces.change_text",
    "category": "method",
    "text": "change_text(widget::WidgetANSILabel, new_text::AbstractString; alignment = :l, color::Int = -1)\n\nChange to text of the label widget widget to new_text.\n\nThe text alignment in the widget can be selected by the keyword alignment, which can be:\n\n:l: left alignment (default);\n:c: Center alignment; or\n:r: Right alignment.\n\nThe text color can be selected by the keyword color. It it is negative (default), then the current color will not be changed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.change_text-Tuple{WidgetLabel,AbstractString}",
    "page": "Library",
    "title": "TextUserInterfaces.change_text",
    "category": "method",
    "text": "change_text(widget::WidgetLabel, new_text::AbstractString; alignment = :l, color::Int = -1)\n\nChange to text of the label widget widget to new_text.\n\nThe text alignment in the widget can be selected by the keyword alignment, which can be:\n\n:l: left alignment (default);\n:c: Center alignment; or\n:r: Right alignment.\n\nThe text color can be selected by the keyword color. It it is negative (default), then the current color will not be changed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.change_value-Tuple{WidgetProgressBar,Int64}",
    "page": "Library",
    "title": "TextUserInterfaces.change_value",
    "category": "method",
    "text": "change_value(widget::WidgetProgressBar, new_value::Int; color::Int = -1)\n\nChange the value of the progress bar to new_value.\n\nThe color can be selected by the keyword color. It it is negative (default), then the current color will not be changed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.clear_data!-Tuple{WidgetForm}",
    "page": "Library",
    "title": "TextUserInterfaces.clear_data!",
    "category": "method",
    "text": "clear_data!(widget::WidgetForm)\n\nClear the data in all the input fields in the form widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.clear_data!-Tuple{WidgetInputField}",
    "page": "Library",
    "title": "TextUserInterfaces.clear_data!",
    "category": "method",
    "text": "clear_data!(widget::WidgetInputField)\n\nClear the data in the input field widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.compute_object_positioning-Tuple{ObjectPositioningConfiguration,Any}",
    "page": "Library",
    "title": "TextUserInterfaces.compute_object_positioning",
    "category": "method",
    "text": "compute_object_positioning(opc::ObjectPositioningConfiguration, parent)\n\nCompute the object position based on the configuration opc and on its parent object parent.\n\nReturn\n\nThe object height.\nThe object width.\nThe top position w.r.t. the parent object.\nThe left position w.r.t. the parent object.\n\n\n\n\n\n"
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
    "text": "create_widget(T, parent::Window, begin_y::Int, begin_x::Int, vargs...; kwargs...)\n\nCreate the widget of type T in the parent window parent. The widget will be positioned on the coordinate (begin_y, begin_x) of the parent window.\n\nAdditional variables and keywords related to each widget can be passed using vargs and kwargs respectively.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_window",
    "page": "Library",
    "title": "TextUserInterfaces.create_window",
    "category": "function",
    "text": "function create_window(opc::ObjectPositioningConfiguration = newopc(), id::String = \"\";  kwargs...)\n\nCreate a window. The window ID id is used to identify the new window in the global window list. The size and location of the window is configured by the object opc.\n\nKeyword\n\nbcols: Number of columns in the window buffer. This will be automatically          increased to, at least, fit the viewable part of the window.          (Default = 0)\nblines: Number of lines in the window buffer. This will be automatically           increased to, at least, fit the viewable part of the window.           (Default = 0)\nborder: If true, then the window will have a border.           (Default = true)\nborder_color: Color mask that will be used to print the border. See function                 ncurses_color. If negative, then the color will not be                 changed. (Default = -1)\nfocusable: If true, then the window can have focus. Otherwise, all focus              request will be rejected. (Default = true)\ntitle: The title of the window, which will only be printed if border is          true. (Default = \"\")\ntitle_color: Color mask that will be used to print the title. See                function ncurses_color. If negative, then the color will not                be changed. (Default = -1)\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_window_with_container-Tuple",
    "page": "Library",
    "title": "TextUserInterfaces.create_window_with_container",
    "category": "method",
    "text": "create_window_with_container(vargs...; kwargs...)\n\nCreate a window with a container as its widget. The arguments and keywords are the same ones of the function create_window. The container will have the same size of the window buffer.\n\nReturn\n\nThe created window.\nThe created container.\n\n\n\n\n\n"
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
    "text": "current_item_desc(menu::TUI_MENU)\n\nReturn the item description of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.current_item_name-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.current_item_name",
    "category": "method",
    "text": "current_item_name(menu::TUI_MENU)\n\nReturn the item name of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_all_windows-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_all_windows",
    "category": "method",
    "text": "destroy_all_windows()\n\nDestroy all windows managed by the TUI.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_menu-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_menu",
    "category": "method",
    "text": "destroy_menu(menu::TUI_MENU)\n\nDestroy the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_tui-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_tui",
    "category": "method",
    "text": "destroy_tui()\n\nDestroy the Text User Interface (TUI).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_widget-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_widget",
    "category": "method",
    "text": "destroy_widget(widget; refresh::Bool = true)\n\nDestroy the widget widget.\n\nIf refresh is true (default), then a full refresh will be performed on the parent window. Otherwise, no refresh will be performed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_window-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.destroy_window",
    "category": "method",
    "text": "destroy_window(win::Window)\n\nDestroy the window win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_buffer-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.get_buffer",
    "category": "method",
    "text": "get_buffer(widget)\n\nReturn the buffer of the widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_buffer-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.get_buffer",
    "category": "method",
    "text": "get_buffer(win::Window)\n\nReturn the buffer of the window win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_color_pair-Tuple{Int64,Int64}",
    "page": "Library",
    "title": "TextUserInterfaces.get_color_pair",
    "category": "method",
    "text": "get_color_pair(foreground::Int, background::Int)\n\nReturn the ID of the color pair (foreground, background), or nothing if the color pair is not initialized.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_data-Tuple{WidgetForm}",
    "page": "Library",
    "title": "TextUserInterfaces.get_data",
    "category": "method",
    "text": "get_data(widget::WidgetInputField)\n\nReturn a vector with the data of all fields.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_data-Tuple{WidgetListBox}",
    "page": "Library",
    "title": "TextUserInterfaces.get_data",
    "category": "method",
    "text": "get_data(widget::WidgetListBox)\n\nReturn the data of the list box widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_data-Union{Tuple{WidgetInputField{P}}, Tuple{P}} where P<:String",
    "page": "Library",
    "title": "TextUserInterfaces.get_data",
    "category": "method",
    "text": "get_data(widget::WidgetInputField)\n\nGet the data of widget. If a validator of type DataType is provided, then it will return the parsed data. Otherwise, it will return a string.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_focused_window-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.get_focused_window",
    "category": "method",
    "text": "get_focused_window()\n\nReturn the focused window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_height",
    "page": "Library",
    "title": "TextUserInterfaces.get_height",
    "category": "function",
    "text": "get_height(object)\n\nReturn the usable height of object object.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_left",
    "page": "Library",
    "title": "TextUserInterfaces.get_left",
    "category": "function",
    "text": "get_bottom(object)\n\nReturn the left of the object w.r.t. its parent.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_selected-Tuple{AbstractString}",
    "page": "Library",
    "title": "TextUserInterfaces.get_selected",
    "category": "method",
    "text": "get_selected(group_name::AbstractString)\n\nReturn the WidgetRadioButton that is selected in group with name group_name. If the group_name does not exists or if no button is selected, then nothing is returned.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_selected-Tuple{WidgetListBox}",
    "page": "Library",
    "title": "TextUserInterfaces.get_selected",
    "category": "method",
    "text": "get_selected(widget::WidgetListBox)\n\nReturn an array of Bool indicating which elements of the list box widget are selected.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_top",
    "page": "Library",
    "title": "TextUserInterfaces.get_top",
    "category": "function",
    "text": "get_top(object)\n\nReturn the top of the object w.r.t. its parent.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_width",
    "page": "Library",
    "title": "TextUserInterfaces.get_width",
    "category": "function",
    "text": "get_width(object)\n\nReturn the usable width of object object.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.has_focus-Tuple{WidgetContainer,Any}",
    "page": "Library",
    "title": "TextUserInterfaces.has_focus",
    "category": "method",
    "text": "has_focus(container::WidgetContainer, widget)\n\nReturn true if the widget widget is in focus on container container, or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.has_focus-Tuple{Window,Any}",
    "page": "Library",
    "title": "TextUserInterfaces.has_focus",
    "category": "method",
    "text": "has_focus(window::Window, widget)\n\nReturn true if the widget widget is in focus on window window, or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.hide_window-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.hide_window",
    "category": "method",
    "text": "hide_window(win::Window)\n\nHide the window win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.init_color_pair-Tuple{Symbol,Symbol}",
    "page": "Library",
    "title": "TextUserInterfaces.init_color_pair",
    "category": "method",
    "text": "init_color_pair(foreground::Symbol, background::Symbol)\n\nInitialize the color pair (foreground, background) and return its ID. If the pair already exists, then just the function just returns its ID.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.init_focus_manager-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.init_focus_manager",
    "category": "method",
    "text": "init_focus_manager()\n\nInitialization of the focus manager. The elements in focus_chain are iterated to find the first one that can accept the focus.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.init_tui",
    "page": "Library",
    "title": "TextUserInterfaces.init_tui",
    "category": "function",
    "text": "init_tui(dir::String = \"\")\n\nInitialize the Text User Interface (TUI). The full-path of the ncurses directory can be specified by dir. If it is empty or omitted, then it will look on the default library directories.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.init_widget!-Tuple{Widget}",
    "page": "Library",
    "title": "TextUserInterfaces.init_widget!",
    "category": "method",
    "text": "init_widget!(widget::Widget)\n\nInitialize the widget widget. It allocates the buffer and also compute the positioning of the widget. The variables opc and parent must be set before calling this function.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.jlgetch",
    "page": "Library",
    "title": "TextUserInterfaces.jlgetch",
    "category": "function",
    "text": "jlgetch(win::Union{Ptr{WINDOW},Nothing} = nothing)\n\nWait for an keystroke in the window win and return it (see Keystroke).  If win is nothing, then getch() will be used instead of wgetch(win) to listen for the keystroke.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.log_message",
    "page": "Library",
    "title": "TextUserInterfaces.log_message",
    "category": "function",
    "text": "log_message(level::Int, msg::AbstractString, id::AbstractString = \"\")\n\nLog the message msg with level level. The ID of the called can be specified by id.\n\nIf a line is @log_pad X, then the following lines will have a padding of X.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_down_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_down_item",
    "category": "method",
    "text": "menu_down_item(menu::TUI_MENU)\n\nMove down to an item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_down_line-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_down_line",
    "category": "method",
    "text": "menu_down_line(menu::TUI_MENU)\n\nScroll down a line of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_down_page-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_down_page",
    "category": "method",
    "text": "menu_down_page(menu::TUI_MENU)\n\nScroll down a page of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_first_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_first_item",
    "category": "method",
    "text": "menu_first_item(menu::TUI_MENU)\n\nMove to the first item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_last_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_last_item",
    "category": "method",
    "text": "menu_last_item(menu::TUI_MENU)\n\nMove to the last item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_left_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_left_item",
    "category": "method",
    "text": "menu_left_item(menu::TUI_MENU)\n\nMove left to an item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_next_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_next_item",
    "category": "method",
    "text": "menu_next_item(menu::TUI_MENU)\n\nMove to the next item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_prev_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_prev_item",
    "category": "method",
    "text": "menu_prev_item(menu::TUI_MENU)\n\nMove to the previous menu item of the menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_right_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_right_item",
    "category": "method",
    "text": "menu_right_item(menu::TUI_MENU)\n\nMove right to an item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_toggle_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_toggle_item",
    "category": "method",
    "text": "menu_toggle_item(menu::TUI_MENU)\n\nToggle the current item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_up_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_up_item",
    "category": "method",
    "text": "menu_up_item(menu::TUI_MENU)\n\nMove up to an item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_up_line-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_up_line",
    "category": "method",
    "text": "menu_up_line(menu::TUI_MENU)\n\nScroll up a line of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_up_page-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.menu_up_page",
    "category": "method",
    "text": "menu_up_page(menu::TUI_MENU)\n\nScroll up a page of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.modify_color-Tuple{Symbol,Int64,Int64,Int64,Int64}",
    "page": "Library",
    "title": "TextUserInterfaces.modify_color",
    "category": "method",
    "text": "modify_color([name::Symbol, ]id::Int, r::Int, g::Int, b::Int)\n\nModify the color ID id to the RGB value (r,g,b). If the symbol name is available, then the user can select this color ID by using name instead of the id.\n\nIf the color name name already exists, then nothing will be changed.\n\nNotice that the range for the RGB color components is [0,1000].\n\nIf the color was initialized, then it returns the color ID. Otherwise, it returns -1.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.move_view-Tuple{Window,Int64,Int64}",
    "page": "Library",
    "title": "TextUserInterfaces.move_view",
    "category": "method",
    "text": "move_view(win::Window, y::Int, x::Int; update::Bool = true)\n\nMove the origin of the view of window win to the position (y,x). This routine makes sure that the view will never reach positions outside the buffer.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.move_view_inc-Tuple{Window,Int64,Int64}",
    "page": "Library",
    "title": "TextUserInterfaces.move_view_inc",
    "category": "method",
    "text": "move_view_inc(win::Window; Δy::Int, Δx::Int; kwargs...)\n\nMove the view of the window win to the position (y+Δy, x+Δx). This function has the same set of keywords of the function move_view.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.move_window-Tuple{Window,Int64,Int64}",
    "page": "Library",
    "title": "TextUserInterfaces.move_window",
    "category": "method",
    "text": "move_window(win::Window, starty::Int, startx::Int)\n\nMove the window win to the position (starty, startx).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.move_window_to_top-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.move_window_to_top",
    "category": "method",
    "text": "move_window_to_top(win::Window)\n\nMove window win to the top.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.ncurses_color",
    "page": "Library",
    "title": "TextUserInterfaces.ncurses_color",
    "category": "function",
    "text": "ncurses_color([foreground, background,] attrs::Int = 0; kwargs...)\n\nReturn a mask to apply a color format with the foreground color foreground, background color background, and the attributes attrs.\n\nIf the pair (foreground, background) is omitted, then the foreground and background color will not be changed.\n\nThe colors can be specified by their names using Symbol or by their indices using Int.\n\nKeywords\n\nbold: If true, then apply bold format mask to attrs.         (Default = false)\nunderline: If true, then apply underline format mask to attrs.              (Default = false)\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.obj_desc-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.obj_desc",
    "category": "method",
    "text": "obj_desc(obj)\n\nReturn a string with the description of the object obj formed by:\n\n<Object type> (<Object address if mutable>)\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.obj_to_ptr-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.obj_to_ptr",
    "category": "method",
    "text": " function obj_to_ptr(obj)\n\nReturns the hexadecimal representation of the address of the object obj. It only works with mutable objects.  If obj is immutable, then 0x0 will be returned.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.post_menu-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.post_menu",
    "category": "method",
    "text": "post_menu(menu::TUI_MENU)\n\nPost the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.process_focus-Tuple{Any,Keystroke}",
    "page": "Library",
    "title": "TextUserInterfaces.process_focus",
    "category": "method",
    "text": "process_focus(widget, k::Keystroke)\n\nProcess the actions when widget widget is in focus and the keystroke k is pressed. If it returns false, then it is means that the widget was not capable to process the focus. Otherwise, it must return true.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.process_focus-Tuple{Keystroke}",
    "page": "Library",
    "title": "TextUserInterfaces.process_focus",
    "category": "method",
    "text": "process_focus(k::Keystroke)\n\nProcess the focus considering the user\'s keystorke k.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.process_focus-Tuple{TextUserInterfaces.TUI_MENU,Keystroke}",
    "page": "Library",
    "title": "TextUserInterfaces.process_focus",
    "category": "method",
    "text": "process_focus(menu::TUI_MENU, k::Keystroke)\n\nProcess the actions when the menu menu is in focus and the keystroke k was issued by the user.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.process_focus-Tuple{Window,Keystroke}",
    "page": "Library",
    "title": "TextUserInterfaces.process_focus",
    "category": "method",
    "text": "process_focus(window::Window, k::Keystroke)\n\nProcess the focus on window window due to keystroke k.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.redraw",
    "page": "Library",
    "title": "TextUserInterfaces.redraw",
    "category": "function",
    "text": "redraw(widget)\n\nRedraw the widget inside its content window cwin.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.refresh_all_windows-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.refresh_all_windows",
    "category": "method",
    "text": "refresh_all_windows()\n\nRefresh all the windows, including the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.refresh_window-Tuple{String}",
    "page": "Library",
    "title": "TextUserInterfaces.refresh_window",
    "category": "method",
    "text": "refresh_window(id::String)\n\nRefresh the window with id id and all its parents windows except for the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.refresh_window-Tuple{WidgetContainer}",
    "page": "Library",
    "title": "TextUserInterfaces.refresh_window",
    "category": "method",
    "text": "refresh_window(container::WidgetContainer; force_redraw::Bool = false)\n\nAsk the parent widget to refresh the window. If force_redraw is true, then all widgets in the window will be updated.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.refresh_window-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.refresh_window",
    "category": "method",
    "text": "refresh_window(win::Window; force_redraw = false)\n\nRefresh the window win and its widget. If the view needs to be updated (see view_needs_update) or if force_redraw is true, then the content of the buffer will be copied to the view before updating.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.release_focus-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.release_focus",
    "category": "method",
    "text": "release_focus(widget)\n\nRequest focus to be released. It should return true if the focus can be released or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.release_focus-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.release_focus",
    "category": "method",
    "text": "release_focus(menu::TUI_MENU)\n\nRelease the focus from the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.remove_widget-Tuple{WidgetContainer,Widget}",
    "page": "Library",
    "title": "TextUserInterfaces.remove_widget",
    "category": "method",
    "text": "remove_widget(container::WidgetContainer, widget::Widget)\n\nRemove the widget widget from the container container.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.remove_widget-Tuple{Window,Widget}",
    "page": "Library",
    "title": "TextUserInterfaces.remove_widget",
    "category": "method",
    "text": "remove_widget(win::Window, widget::Widget)\n\nRemove the widget widget from the window win. If widget does not belong to win, then nothing is done.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.reposition!",
    "page": "Library",
    "title": "TextUserInterfaces.reposition!",
    "category": "function",
    "text": "reposition!(object)\n\nReposition the object baesd on the stored configuration.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_focus-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.request_focus",
    "category": "method",
    "text": "request_focus(widget)\n\nRequest to focus to the widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_focus-Tuple{WidgetContainer,Any}",
    "page": "Library",
    "title": "TextUserInterfaces.request_focus",
    "category": "method",
    "text": "request_focus(container::WidgetContainer, widget)\n\nRequest the focus to the widget widget of the container container. It returns true if the focus could be changed or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_focus-Tuple{Window,Any}",
    "page": "Library",
    "title": "TextUserInterfaces.request_focus",
    "category": "method",
    "text": "request_focus(win::Window, widget)\n\nRequest the focus to the widget widget of the window win. This function is only necessary to make Window comply to the containers API. Since a window can contain only one widget, then a function to change the focus is not meaningful.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_focus-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.request_focus",
    "category": "method",
    "text": "request_focus(win::Window)\n\nRequest the focus to the window win. If win cannot get the focus, then nothing happens and it returns false. If wincan get the focus, then the focus is passed to it and the function returns true.\n\nRemarks\n\nEven if win is in the focus chain, the focus_id will not change by requesting focus to win. This means that the window focus order is not altered by this function.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_update-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.request_update",
    "category": "method",
    "text": "request_update(widget)\n\nRequest update of the widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_update-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.request_update",
    "category": "method",
    "text": "request_update(win::Window)\n\nRequest update of the window win because its widget was updated.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.select_item-Tuple{WidgetListBox,Int64}",
    "page": "Library",
    "title": "TextUserInterfaces.select_item",
    "category": "method",
    "text": "select_item(widget::WidgetListBox, id::Int)\n\nSelect the item id in the list box widget. Notice that id refers to the position of the item in the array data.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.selected_items-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.selected_items",
    "category": "method",
    "text": "selected_items(menu::TUI_MENU)\n\nReturn a Vector with the selected items in the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.selected_items_desc-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.selected_items_desc",
    "category": "method",
    "text": "selected_items_desc(menu::TUI_MENU)\n\nReturn a Vector with the selected items descriptions in the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.selected_items_names-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.selected_items_names",
    "category": "method",
    "text": "selected_items_names(menu::TUI_MENU)\n\nReturn a Vector with the selected items names in the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_color-Tuple{Int64}",
    "page": "Library",
    "title": "TextUserInterfaces.set_color",
    "category": "method",
    "text": "set_color([win::Window,] color::Int)\n\nSet the color of the window win to color (see ncurses_color). If win is omitted, then it defaults to the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_focus_chain-Tuple{Vararg{Window,N} where N}",
    "page": "Library",
    "title": "TextUserInterfaces.set_focus_chain",
    "category": "method",
    "text": "set_focus_chain(wins::Window...; new_focus_id::Int = 1)\n\nSet the focus chain, i.e. the ordered list of windows that can receive the focus. The keyword new_focus_id can be set to specify which element is currently focused in the new chain.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_menu_win-Tuple{TextUserInterfaces.TUI_MENU,Window}",
    "page": "Library",
    "title": "TextUserInterfaces.set_menu_win",
    "category": "method",
    "text": "set_menu_win(menu::TUI_MENU, win::Window)\n\nSet menu menu window to win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_next_window_func-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.set_next_window_func",
    "category": "method",
    "text": "set_next_window_func(f)\n\nSet the function f to be the one that will be called to check whether the user wants the next window. The signature must be:\n\nf(k::Keystroke)::Bool\n\nIt must return true if the next window is required of false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_previous_window_func-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.set_previous_window_func",
    "category": "method",
    "text": "set_previous_window_func(f)\n\nSet the function f to be the one that will be called to check whether the user wants the previous window. The signature must be:\n\nf(k::Keystroke)::Bool\n\nIt must return true if the previous window is required of false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_widget_color-Tuple{Any,Int64}",
    "page": "Library",
    "title": "TextUserInterfaces.set_widget_color",
    "category": "method",
    "text": "set_widget_color(widget, color::Int)\n\nSet the background color of widget to color.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_window_title-Tuple{Window,AbstractString}",
    "page": "Library",
    "title": "TextUserInterfaces.set_window_title",
    "category": "method",
    "text": "set_window_title(win::Window, title::AbstractString; ...)\n\nSet the title of the window win to title.\n\nKeywords\n\ntitle_color: Color mask that will be used to print the title. See                function ncurses_color. If negative, then the color will not                be changed. (Default = -1)\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.show_window-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.show_window",
    "category": "method",
    "text": "show_window(win::Window)\n\nShow the window win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.sync_cursor-Tuple{WidgetContainer}",
    "page": "Library",
    "title": "TextUserInterfaces.sync_cursor",
    "category": "method",
    "text": "sync_cursor(widget::WidgetContainer)\n\nSynchronize the cursor to the position of the focused widget in container container. This is necessary because all the operations are done in the buffer and then copied to the view.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.sync_cursor-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.sync_cursor",
    "category": "method",
    "text": "sync_cursor(window::Window)\n\nSynchronize the cursor to the position of the focused widget in window window. This is necessary because all the operations are done in the buffer and then copied to the view.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.unpost_menu-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.unpost_menu",
    "category": "method",
    "text": "unpost_menu(menu::TUI_MENU)\n\nUnpost the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.unset_color-Tuple{Int64}",
    "page": "Library",
    "title": "TextUserInterfaces.unset_color",
    "category": "method",
    "text": "unset_color([win::Window,] color::Number)\n\nUnset the color color (see ncurses_color) in the window win. If win is omitted, then it defaults to the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.update-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.update",
    "category": "method",
    "text": "update(widget; force_redraw = false)\n\nUpdate the widget by calling the function redraw. This function returns true if the widget needed to be updated of false otherwise.\n\nIf force_redraw is true, then the widget will be updated even if it is not needed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.update_view-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.update_view",
    "category": "method",
    "text": "update_view(win::Window; force::Bool = false)\n\nUpdate the view of window win by copying the contents from the buffer. If the view does not need to be updated (see view_needs_update), then nothing is done. If the keyword force is true, then the copy will always happen.\n\nReturn\n\nIt returns true if the view has been updated and false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.validate_str-Union{Tuple{T}, Tuple{AbstractString,T}} where T",
    "page": "Library",
    "title": "TextUserInterfaces.validate_str",
    "category": "method",
    "text": "validate_str(str::AbstractString, v)\n\nValidate the string str using the validator v. v is an element of the type that will be used to validate or a regex.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@composed_widget-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.@composed_widget",
    "category": "macro",
    "text": "@composed_widget(ex)\n\nDeclare a structure of a composed widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@connect_signal-Tuple{Any,Symbol,Any,Vararg{Any,N} where N}",
    "page": "Library",
    "title": "TextUserInterfaces.@connect_signal",
    "category": "macro",
    "text": "@connect_signal(obj, signal::Symbol, f::Symbol, vargs...)\n\nConnect the signal signal of the object obj to the function f passing the additional arguments vargs. Thus, when signal is emitted by obj, then fcall will be executed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@disconnect_signal-Tuple{Any,Symbol}",
    "page": "Library",
    "title": "TextUserInterfaces.@disconnect_signal",
    "category": "macro",
    "text": "@disconnect_signal(obj, signal::Symbol)\n\nDisconnect the signal signal from object obj.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@emit_signal-Tuple{Any,Symbol,Vararg{Any,N} where N}",
    "page": "Library",
    "title": "TextUserInterfaces.@emit_signal",
    "category": "macro",
    "text": "@emit_signal(obj, signal::Symbol, params...)\n\nEmit the signal signal of the object obj with the parameters params..., causing to execute the connected function.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@forward_signal-Tuple{Any,Any,Symbol}",
    "page": "Library",
    "title": "TextUserInterfaces.@forward_signal",
    "category": "macro",
    "text": "@forward_signal(src, dest, signal::Symbol)\n\nForward the signal signal from src to dest. This means that every time that the signal signal is generated in src, then the function in dest will be called.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.@widget-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.@widget",
    "category": "macro",
    "text": "@widget(ex)\n\nDeclare a structure of a widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._check_horizontal_anchor-Tuple{Anchor}",
    "page": "Library",
    "title": "TextUserInterfaces._check_horizontal_anchor",
    "category": "method",
    "text": "_check_horizontal_anchor(anchor::Anchor)\n\nCheck if the side parameter of anchor is valid for horizontal positioning. If anchor is _no_anchor, then true is always returned.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._check_vertical_anchor-Tuple{Anchor}",
    "page": "Library",
    "title": "TextUserInterfaces._check_vertical_anchor",
    "category": "method",
    "text": "_check_vertical_anchor(anchor::Nothing)\n_check_vertical_anchor(anchor::Anchor)\n\nCheck if the side parameter of anchor is valid for vertical positioning. If anchor is _no_anchor, then true is always returned.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._deselect_radio_button-Tuple{WidgetRadioButton}",
    "page": "Library",
    "title": "TextUserInterfaces._deselect_radio_button",
    "category": "method",
    "text": "_select_radio_button(rb::WidgetRadioButton)\n\nDeselect the radio button rb in its group name.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._destroy_widget-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces._destroy_widget",
    "category": "method",
    "text": "_destroy_widget(widget; refresh::Bool = true)\n\nPrivate function that destroys a widget. This can be used if a new widget needs to reimplement the destroy function.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._draw_title-Tuple{WidgetContainer}",
    "page": "Library",
    "title": "TextUserInterfaces._draw_title",
    "category": "method",
    "text": "_draw_title(container::WidgetContainer)\n\nDraw the title in the container container.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_anchor-Tuple{Anchor,Any}",
    "page": "Library",
    "title": "TextUserInterfaces._get_anchor",
    "category": "method",
    "text": "_get_anchor(anchor::Anchor, parent)\n\nReturn the line or column related to the anchor anchor. If the object in anchor is the parent, then the positioning will be computed relative to the parent.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_color_index-Tuple{Symbol}",
    "page": "Library",
    "title": "TextUserInterfaces._get_color_index",
    "category": "method",
    "text": "_get_color_index(color::Symbol)\n\nReturn the index related to the color color.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_window_cur_pos-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "Library",
    "title": "TextUserInterfaces._get_window_cur_pos",
    "category": "method",
    "text": "_get_window_cur_pos(win::Ptr{WINDOW})\n\nGet the cursor position of the window win and return it on a tuple (cur_y,cur_x).  If the window is not initialized, then this function returns (-1,-1).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_window_dims-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "Library",
    "title": "TextUserInterfaces._get_window_dims",
    "category": "method",
    "text": "_get_window_dims(win::Ptr{WINDOW})\n\nGet the dimensions of the window win and return it on a tuple (dim_y,dim_x). If the window is not initialized, then this function returns (-1,-1).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._next_widget-Tuple{WidgetContainer}",
    "page": "Library",
    "title": "TextUserInterfaces._next_widget",
    "category": "method",
    "text": "_next_widget(container::WidgetContainer)\n\nMove the focus of container container to the next widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._previous_widget-Tuple{WidgetContainer}",
    "page": "Library",
    "title": "TextUserInterfaces._previous_widget",
    "category": "method",
    "text": "_previous_widget(container::WidgetContainer)\n\nMove the focus of container container to the previous widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._process_horizontal_info!-Tuple{ObjectPositioningConfiguration}",
    "page": "Library",
    "title": "TextUserInterfaces._process_horizontal_info!",
    "category": "method",
    "text": "_process_horizontal_info!(opc::ObjectPositioningConfiguration)\n\nProcess the horizontal positioning information in opc and write the variable horizontal of the same structure. The possible horizontal positioning information are:\n\n:aleft_aright: Left and right anchors were specified.\n:aleft_height: Left anchor and height were specified.\n:aright_height: Right anchor and height were specified.\n:acenter_height: Center anchor and height were specified.\n:right_height: Right and height were specified.\n:unknown: Insufficient information to compute the horizontal positioning.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._process_vertical_info!-Tuple{ObjectPositioningConfiguration}",
    "page": "Library",
    "title": "TextUserInterfaces._process_vertical_info!",
    "category": "method",
    "text": "_process_vertical_info!(opc::ObjectPositioningConfiguration)\n\nProcess the vertical positioning information in opc and write the variable vertical of the same structure. The possible vertical positioning information are:\n\n:abottom_atop: Bottom and top anchors were specified.\n:abottom_height: Bottom anchor and height were specified.\n:atop_height: Top anchor and height were specified.\n:amiddle_height: Middle anchor and height were specified.\n:top_height: Top and height were specified.\n:unknown: Insufficient information to compute the vertical positioning.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._select_radio_button-Tuple{WidgetRadioButton}",
    "page": "Library",
    "title": "TextUserInterfaces._select_radio_button",
    "category": "method",
    "text": "_select_radio_button(rb::WidgetRadioButton)\n\nSelect the radio button rb in its group name.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._str-Tuple{ObjectPositioningConfiguration}",
    "page": "Library",
    "title": "TextUserInterfaces._str",
    "category": "method",
    "text": "_str(wpc::ObjectPositioningConfiguration)\n\nConvert the information in wpc to a string for debugging purposes.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._try_focus-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces._try_focus",
    "category": "method",
    "text": "_try_focus(win::Window)\n\nTry to set to focus to the window win. If it was possible to make win the focused windows, then it returns true. Otherwise, it returns false.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_current_item-Tuple{WidgetListBox}",
    "page": "Library",
    "title": "TextUserInterfaces.get_current_item",
    "category": "method",
    "text": "get_selected_item(widget::WidgetListBox)\n\nReturn the ID of the current item of the list box widget and the data associated with it.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_height_for_child",
    "page": "Library",
    "title": "TextUserInterfaces.get_height_for_child",
    "category": "function",
    "text": "get_height_for_child\n\nReturn the usable height of the object for a child object.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_left_for_child",
    "page": "Library",
    "title": "TextUserInterfaces.get_left_for_child",
    "category": "function",
    "text": "get_left_for_child\n\nReturn the left of the object for a child object.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_parent-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.get_parent",
    "category": "method",
    "text": "get_parent(widget)\n\nReturn the parent of the widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_parent-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.get_parent",
    "category": "method",
    "text": "get_parent(win::Window)\n\nReturn nothing since the window has no parent.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_top_for_child",
    "page": "Library",
    "title": "TextUserInterfaces.get_top_for_child",
    "category": "function",
    "text": "get_top_for_child\n\nReturn the top of the object for a child object.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_width_for_child",
    "page": "Library",
    "title": "TextUserInterfaces.get_width_for_child",
    "category": "function",
    "text": "get_width_for_child\n\nReturn the usable width of object object for a child object.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.next_window-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.next_window",
    "category": "method",
    "text": "next_window()\n\nMove the focus to the next window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.previous_window-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.previous_window",
    "category": "method",
    "text": "previous_window()\n\nMove the focus to the previous window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_next_widget-Tuple{WidgetContainer}",
    "page": "Library",
    "title": "TextUserInterfaces.request_next_widget",
    "category": "method",
    "text": "request_next_widget(container::WidgetContainer)\n\nRequest the next widget in container. It returns true if a widget has get the focus or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_prev_widget-Tuple{WidgetContainer}",
    "page": "Library",
    "title": "TextUserInterfaces.request_prev_widget",
    "category": "method",
    "text": "request_prev_widget(container::WidgetContainer)\n\nRequest the previous widget in container. It returns true if a widget has get the focus or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_view_update-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.request_view_update",
    "category": "method",
    "text": "request_view_update(win::Window)\n\nRequest to update the view of window win. Notice that this must also request update on all parent windows until the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.require_cursor-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.require_cursor",
    "category": "method",
    "text": "require_cursor()\n\nIf true, then the physical cursor will be shown and the position will be updated according to its position in the widget window. Otherwise, the physical cursor will be hidden.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@derived_widget-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.@derived_widget",
    "category": "macro",
    "text": "@derived_widget(ex)\n\nDeclare a structure of a derived widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@signal-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.@signal",
    "category": "macro",
    "text": "@signal(name)\n\nCreate the signal named name. This must be used inside the widget structure that must be declared with @with_kw option (see package Parameters.jl).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#Library-1",
    "page": "Library",
    "title": "Library",
    "category": "section",
    "text": "Documentation for TextUserInterfaces.jl.Modules = [TextUserInterfaces]"
},

]}
