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
    "location": "man/object_positioning/#",
    "page": "Object positioning",
    "title": "Object positioning",
    "category": "page",
    "text": ""
},

{
    "location": "man/object_positioning/#Object-positioning-1",
    "page": "Object positioning",
    "title": "Object positioning",
    "category": "section",
    "text": "The positioning of an object in TextUserInterfaces.jl means its position and size in the screen. This information is stored in an instance of the structure ObjectPositioningConfiguration. It can be created by the function newopc:newopc(;kwargs...)Create an instance of the structure ObjectPositioningConfiguration. The following keywords are available to specify the positioning:anchor_bottom: Bottom anchor specification. (Default = _no_anchor)\nanchor_left: Left anchor specification. (Default = _no_anchor)\nanchor_right: Right anchor specification. (Default = _no_anchor)\nanchor_top: Top anchor specification. (Default = _no_anchor)\nanchor_center: Center anchor specification. (Default = _no_anchor)\nanchor_middle: Middle anchor specification. (Default = _no_anchor)\ntop: Absolute position of the object top side. (Default = -1)\nleft: Absolute position of the object left side. (Default = -1)\nheight: Height of the object. (Default = -1)\nwidth: Width of the object. (Default = -1)info: Info\nIf the absolute positioning arguments (top, left, height, and width) are negative, then it means that there is no information about them. Hence, the relative arguments (anchors) must provide the missing information.Notice that the position of the object can be defined by relative terms or absolute terms. They can be mixed, but the user must be sure that the system can infer the position and size of the object given the provided set of parameters."
},

{
    "location": "man/object_positioning/#Anchors-1",
    "page": "Object positioning",
    "title": "Anchors",
    "category": "section",
    "text": "Every object has three horizontal anchors and three vertical anchors:Horizontal anchors\n===============================================================================\n\n+-----------------------------------------------------------------------------+\n|                                                                             |\n| <- Left anchor                 Center anchor                Right anchor -> |\n|                                                                             |\n+-----------------------------------------------------------------------------+\n\nVertical anchors\n===============================================================================\n\n+--------------------------------- Top anchor --------------------------------+\n|                                                                             |\n|                                Middle anchor                                |\n|                                                                             |\n+------------------------------- Bottom anchor -------------------------------+The positioning information of an object can be informed by attaching those anchors to the anchors of another object. This is accomplished by creating an instance of the structure Anchor:struct Anchor\n    obj::Object\n    side::Symbol\n    pad::Int\nendto the desired anchor, where obj defines the object we want anchor, side defines which side will be anchored, and pad defines a space.info: Info\nside is one of the following symbols: :left, :right, :top, :bottom, :center, or :middle.Thus, suppose that we want that the object B is positioned on the left of object A with the same height and width 9:                   <-- 9 -->\n+-----------------++-------+\n|                 ||       |\n|                 ||       |\n|                 ||       |\n|        A        ||   B   |\n|                 ||       |\n|                 ||       |\n|                 ||       |\n+-----------------++-------+Thus, we should create the following ObjectPositioningConfiguration for B:newopc(anchor_top    = Anchor(A, :top, 0),\n       anchor_left   = Anchor(A, :right, 0),\n       anchor_bottom = Anchor(A, :bottom, 0),\n       width         = 9)Notice that we attached the anchors top, left, and bottom of B to the anchors top, right, and bottom, respectively, of A. With only this information, the width would be undefined. Thus, we provided this information with the absolute parameter width.warning: Warning\nVertical anchors can only be attached to another vertical anchor, and horizontal anchors can only be attached to another horizontal anchor. The system checks if the anchor specification is correct and throws an error if not."
},

{
    "location": "lib/library/#",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces",
    "category": "page",
    "text": ""
},

{
    "location": "lib/library/#TextUserInterfaces.Anchor",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.Anchor",
    "category": "type",
    "text": "struct Anchor\n\nThis structure defines an anchor to another object. It should be used in one of the fields anchor_* of ObjectPositioningConfiguration.\n\nFields\n\nobj: Reference object.\nside: Side of the reference object to which we will apply the attachment.\npad: A space between the anchors of the two objects.\n\ninfo: Info\nside is one of the following symbols: :left, :right, :top, :bottom, :center, or :middle.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.Keystroke",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.Keystroke",
    "category": "type",
    "text": "struct Keystorke\n\nStructure that defines a keystroke.\n\nFields\n\nvalue: String representing the keystroke.\nktype: Type of the key (:char, :F1, :up, etc.).\nalt: true if ALT key was pressed (only valid if ktype != :char).\nctrl: true if CTRL key was pressed (only valid if ktype != :char).\nshift: true if SHIFT key was pressed (only valid if ktype != :char).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.ObjectPositioningConfiguration",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.ObjectPositioningConfiguration",
    "category": "type",
    "text": "struct ObjectPositioningConfiguration\n\nThis structure defines the positioning of an object. It can also be created with the function newopc.\n\nFields\n\nanchor_bottom: Bottom anchor specification. (Default = _no_anchor)\nanchor_left: Left anchor specification. (Default = _no_anchor)\nanchor_right: Right anchor specification. (Default = _no_anchor)\nanchor_top: Top anchor specification. (Default = _no_anchor)\nanchor_center: Center anchor specification. (Default = _no_anchor)\nanchor_middle: Middle anchor specification. (Default = _no_anchor)\ntop: Absolute position of the object top side. (Default = -1)\nleft: Absolute position of the object left side. (Default = -1)\nheight: Height of the object. (Default = -1)\nwidth: Width of the object. (Default = -1)\n\ninfo: Info\nIf the absolute positioning arguments (top, left, height, and width) are negative, then it means that there is no information about them. Hence, the relative arguments (anchors) must provide the missing information.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.newopc",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.newopc",
    "category": "type",
    "text": "newopc(;kwargs...)\n\nCreate an instance of the structure ObjectPositioningConfiguration. The following keywords are available to specify the positioning:\n\nanchor_bottom: Bottom anchor specification. (Default = _no_anchor)\nanchor_left: Left anchor specification. (Default = _no_anchor)\nanchor_right: Right anchor specification. (Default = _no_anchor)\nanchor_top: Top anchor specification. (Default = _no_anchor)\nanchor_center: Center anchor specification. (Default = _no_anchor)\nanchor_middle: Middle anchor specification. (Default = _no_anchor)\ntop: Absolute position of the object top side. (Default = -1)\nleft: Absolute position of the object left side. (Default = -1)\nheight: Height of the object. (Default = -1)\nwidth: Width of the object. (Default = -1)\n\ninfo: Info\nIf the absolute positioning arguments (top, left, height, and width) are negative, then it means that there is no information about them. Hence, the relative arguments (anchors) must provide the missing information.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.accept_focus-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.accept_focus",
    "category": "method",
    "text": "accept_focus(widget)\n\nReturn true is the widget widget accepts focus or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.accept_focus-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.accept_focus",
    "category": "method",
    "text": "accept_focus(menu::TUI_MENU)\n\nCommand executed when menu menu must state whether or not it accepts the focus. If the focus is accepted, then this function returns true. Otherwise, it returns false.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.accept_focus-Tuple{Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.accept_focus",
    "category": "method",
    "text": "accept_focus(window::Window)\n\nCheck if the window window can accept focus and, if it can, then perform the actions to change the focus.\n\n\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.add_widget-Tuple{WidgetContainer,Widget}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.add_widget",
    "category": "method",
    "text": "add_widget(container::WidgetContainer, widget::Widget)\n\nAdd the widget widget to the container `container.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.add_widget-Tuple{Window,Widget}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.add_widget",
    "category": "method",
    "text": "add_widget(win::Window, widget::Widget)\n\nAdd widget widget to the window win. If the win already have a widget, then it will be replaced.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.change_label-Tuple{WidgetButton,AbstractString}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.change_label",
    "category": "method",
    "text": "change_label(button::WidgetButton, label::AbstractString)\n\nChange the label of button button to label.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.change_text-Tuple{WidgetANSILabel,AbstractString}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.change_text",
    "category": "method",
    "text": "change_text(widget::WidgetANSILabel, new_text::AbstractString; alignment = :l, color::Int = -1)\n\nChange to text of the label widget widget to new_text.\n\nThe text alignment in the widget can be selected by the keyword alignment, which can be:\n\n:l: left alignment (default);\n:c: Center alignment; or\n:r: Right alignment.\n\nThe text color can be selected by the keyword color. It it is negative (default), then the current color will not be changed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.change_text-Tuple{WidgetLabel,AbstractString}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.change_text",
    "category": "method",
    "text": "change_text(widget::WidgetLabel, new_text::AbstractString; alignment = :l, color::Int = -1)\n\nChange to text of the label widget widget to new_text.\n\nThe text alignment in the widget can be selected by the keyword alignment, which can be:\n\n:l: left alignment (default);\n:c: Center alignment; or\n:r: Right alignment.\n\nThe text color can be selected by the keyword color. It it is negative (default), then the current color will not be changed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.change_value-Tuple{WidgetProgressBar,Int64}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.change_value",
    "category": "method",
    "text": "change_value(widget::WidgetProgressBar, new_value::Int; color::Int = -1)\n\nChange the value of the progress bar to new_value.\n\nThe color can be selected by the keyword color. It it is negative (default), then the current color will not be changed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.clear_data!-Tuple{WidgetForm}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.clear_data!",
    "category": "method",
    "text": "clear_data!(widget::WidgetForm)\n\nClear the data in all the input fields in the form widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.clear_data!-Tuple{WidgetInputField}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.clear_data!",
    "category": "method",
    "text": "clear_data!(widget::WidgetInputField)\n\nClear the data in the input field widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.compute_object_positioning-Tuple{ObjectPositioningConfiguration,Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.compute_object_positioning",
    "category": "method",
    "text": "compute_object_positioning(opc::ObjectPositioningConfiguration, parent)\n\nCompute the object position based on the configuration opc and on its parent object parent.\n\nReturn\n\nThe object height.\nThe object width.\nThe top position w.r.t. the parent object.\nThe left position w.r.t. the parent object.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_menu-Union{Tuple{Array{T1,1}}, Tuple{T2}, Tuple{T1}, Tuple{Array{T1,1},Union{Nothing, Array{T2,1}}}} where T2<:AbstractString where T1<:AbstractString",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.create_menu",
    "category": "method",
    "text": "function create_menu(names::Vector{T1}, descriptions::Union{Nothing,Vector{T2}} = nothing; kwargs...)\n\nCreate a menu with the names names and descriptions descriptions. If descriptions is nothing or is omitted, then the menu descriptions will not be shown.\n\nKeywords\n\nformat: If nothing, then the default menu format will be used. Otherwise,           it must be a tuple with two integers describing respectively the           number of rows and columns. (Default = nothing)\nmark: The menu mark. (Default = -)\none_value: If true, then the menu cannot have multiple selections.              (Default = true)\nshow_desc: If true, then the menu description will be shown.              (Default = true)\nrow_major: If true, then the menu will be constructed in a row-major              ordering.\nignore_case: If true, then the case will be ignored on pattern matching.\nshow_match: If true, then the cursor will be moved to within the item name               while pattern-matching.\nnon_cyclic: If true, then the menu will be non cyclic.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_widget",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.create_widget",
    "category": "function",
    "text": "create_widget(T, parent::Window, begin_y::Int, begin_x::Int, vargs...; kwargs...)\n\nCreate the widget of type T in the parent window parent. The widget will be positioned on the coordinate (begin_y, begin_x) of the parent window.\n\nAdditional variables and keywords related to each widget can be passed using vargs and kwargs respectively.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_window",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.create_window",
    "category": "function",
    "text": "function create_window(opc::ObjectPositioningConfiguration = newopc(), id::String = \"\";  kwargs...)\n\nCreate a window. The window ID id is used to identify the new window in the global window list. The size and location of the window is configured by the object opc.\n\nKeyword\n\nbcols: Number of columns in the window buffer. This will be automatically          increased to, at least, fit the viewable part of the window.          (Default = 0)\nblines: Number of lines in the window buffer. This will be automatically           increased to, at least, fit the viewable part of the window.           (Default = 0)\nborder: If true, then the window will have a border.           (Default = true)\nborder_color: Color mask that will be used to print the border. See function                 ncurses_color. If negative, then the color will not be                 changed. (Default = -1)\nfocusable: If true, then the window can have focus. Otherwise, all focus              request will be rejected. (Default = true)\ntitle: The title of the window, which will only be printed if border is          true. (Default = \"\")\ntitle_color: Color mask that will be used to print the title. See                function ncurses_color. If negative, then the color will not                be changed. (Default = -1)\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_window_with_container-Tuple",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.create_window_with_container",
    "category": "method",
    "text": "create_window_with_container(vargs...; kwargs...)\n\nCreate a window with a container as its widget. The arguments and keywords are the same ones of the function create_window. The container will have the same size of the window buffer.\n\nReturn\n\nThe created window.\nThe created container.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.current_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.current_item",
    "category": "method",
    "text": "current_item(menu::TUI_MENU) = current_item(menu.ptr)\n\nReturn the current item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.current_item_desc-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.current_item_desc",
    "category": "method",
    "text": "current_item_desc(menu::TUI_MENU)\n\nReturn the item description of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.current_item_name-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.current_item_name",
    "category": "method",
    "text": "current_item_name(menu::TUI_MENU)\n\nReturn the item name of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_all_windows-Tuple{}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.destroy_all_windows",
    "category": "method",
    "text": "destroy_all_windows()\n\nDestroy all windows managed by the TUI.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_menu-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.destroy_menu",
    "category": "method",
    "text": "destroy_menu(menu::TUI_MENU)\n\nDestroy the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_tui-Tuple{}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.destroy_tui",
    "category": "method",
    "text": "destroy_tui()\n\nDestroy the Text User Interface (TUI).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_widget-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.destroy_widget",
    "category": "method",
    "text": "destroy_widget(widget; refresh::Bool = true)\n\nDestroy the widget widget.\n\nIf refresh is true (default), then a full refresh will be performed on the parent window. Otherwise, no refresh will be performed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.destroy_window-Tuple{Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.destroy_window",
    "category": "method",
    "text": "destroy_window(win::Window)\n\nDestroy the window win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_buffer-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_buffer",
    "category": "method",
    "text": "get_buffer(widget)\n\nReturn the buffer of the widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_buffer-Tuple{Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_buffer",
    "category": "method",
    "text": "get_buffer(win::Window)\n\nReturn the buffer of the window win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_color_pair-Tuple{Int64,Int64}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_color_pair",
    "category": "method",
    "text": "get_color_pair(foreground::Int, background::Int)\n\nReturn the ID of the color pair (foreground, background), or nothing if the color pair is not initialized.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_data-Tuple{WidgetForm}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_data",
    "category": "method",
    "text": "get_data(widget::WidgetInputField)\n\nReturn a vector with the data of all fields.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_data-Tuple{WidgetInputField}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_data",
    "category": "method",
    "text": "get_data(widget::WidgetInputField)\n\nGet the data of widget as a string. If the validator is enabled and the data is not valid, then return nothing.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_data-Tuple{WidgetListBox}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_data",
    "category": "method",
    "text": "get_data(widget::WidgetListBox)\n\nReturn the data of the list box widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_focused_window-Tuple{}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_focused_window",
    "category": "method",
    "text": "get_focused_window()\n\nReturn the focused window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_height",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_height",
    "category": "function",
    "text": "get_height(object)\n\nReturn the usable height of object object.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_left",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_left",
    "category": "function",
    "text": "get_bottom(object)\n\nReturn the left of the object w.r.t. its parent.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_selected-Tuple{AbstractString}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_selected",
    "category": "method",
    "text": "get_selected(group_name::AbstractString)\n\nReturn the WidgetRadioButton that is selected in group with name group_name. If the group_name does not exists or if no button is selected, then nothing is returned.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_selected-Tuple{WidgetListBox}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_selected",
    "category": "method",
    "text": "get_selected(widget::WidgetListBox)\n\nReturn an array of Bool indicating which elements of the list box widget are selected.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_top",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_top",
    "category": "function",
    "text": "get_top(object)\n\nReturn the top of the object w.r.t. its parent.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_width",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_width",
    "category": "function",
    "text": "get_width(object)\n\nReturn the usable width of object object.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.has_focus-Tuple{WidgetContainer,Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.has_focus",
    "category": "method",
    "text": "has_focus(container::WidgetContainer, widget)\n\nReturn true if the widget widget is in focus on container container, or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.has_focus-Tuple{Window,Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.has_focus",
    "category": "method",
    "text": "has_focus(window::Window, widget)\n\nReturn true if the widget widget is in focus on window window, or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.hide_window-Tuple{Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.hide_window",
    "category": "method",
    "text": "hide_window(win::Window)\n\nHide the window win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.init_color_pair-Tuple{Symbol,Symbol}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.init_color_pair",
    "category": "method",
    "text": "init_color_pair(foreground::Symbol, background::Symbol)\n\nInitialize the color pair (foreground, background) and return its ID. If the pair already exists, then just the function just returns its ID.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.init_focus_manager-Tuple{}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.init_focus_manager",
    "category": "method",
    "text": "init_focus_manager()\n\nInitialization of the focus manager. The elements in focus_chain are iterated to find the first one that can accept the focus.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.init_tui",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.init_tui",
    "category": "function",
    "text": "init_tui(dir::String = \"\")\n\nInitialize the Text User Interface (TUI). The full-path of the ncurses directory can be specified by dir. If it is empty or omitted, then it will look on the default library directories.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.init_widget!-Tuple{Widget}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.init_widget!",
    "category": "method",
    "text": "init_widget!(widget::Widget)\n\nInitialize the widget widget. It allocates the buffer and also compute the positioning of the widget. The variables opc and parent must be set before calling this function.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.jlgetch",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.jlgetch",
    "category": "function",
    "text": "jlgetch(win::Union{Ptr{WINDOW},Nothing} = nothing)\n\nWait for an keystroke in the window win and return it (see Keystroke).  If win is nothing, then getch() will be used instead of wgetch(win) to listen for the keystroke.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.log_message",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.log_message",
    "category": "function",
    "text": "log_message(level::Int, msg::AbstractString, id::AbstractString = \"\")\n\nLog the message msg with level level. The ID of the called can be specified by id.\n\nIf a line is @log_pad X, then the following lines will have a padding of X.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_down_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.menu_down_item",
    "category": "method",
    "text": "menu_down_item(menu::TUI_MENU)\n\nMove down to an item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_down_line-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.menu_down_line",
    "category": "method",
    "text": "menu_down_line(menu::TUI_MENU)\n\nScroll down a line of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_down_page-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.menu_down_page",
    "category": "method",
    "text": "menu_down_page(menu::TUI_MENU)\n\nScroll down a page of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_first_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.menu_first_item",
    "category": "method",
    "text": "menu_first_item(menu::TUI_MENU)\n\nMove to the first item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_last_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.menu_last_item",
    "category": "method",
    "text": "menu_last_item(menu::TUI_MENU)\n\nMove to the last item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_left_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.menu_left_item",
    "category": "method",
    "text": "menu_left_item(menu::TUI_MENU)\n\nMove left to an item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_next_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.menu_next_item",
    "category": "method",
    "text": "menu_next_item(menu::TUI_MENU)\n\nMove to the next item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_prev_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.menu_prev_item",
    "category": "method",
    "text": "menu_prev_item(menu::TUI_MENU)\n\nMove to the previous menu item of the menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_right_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.menu_right_item",
    "category": "method",
    "text": "menu_right_item(menu::TUI_MENU)\n\nMove right to an item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_toggle_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.menu_toggle_item",
    "category": "method",
    "text": "menu_toggle_item(menu::TUI_MENU)\n\nToggle the current item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_up_item-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.menu_up_item",
    "category": "method",
    "text": "menu_up_item(menu::TUI_MENU)\n\nMove up to an item of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_up_line-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.menu_up_line",
    "category": "method",
    "text": "menu_up_line(menu::TUI_MENU)\n\nScroll up a line of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.menu_up_page-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.menu_up_page",
    "category": "method",
    "text": "menu_up_page(menu::TUI_MENU)\n\nScroll up a page of the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.modify_color-Tuple{Symbol,Int64,Int64,Int64,Int64}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.modify_color",
    "category": "method",
    "text": "modify_color([name::Symbol, ]id::Int, r::Int, g::Int, b::Int)\n\nModify the color ID id to the RGB value (r,g,b). If the symbol name is available, then the user can select this color ID by using name instead of the id.\n\nIf the color name name already exists, then nothing will be changed.\n\nNotice that the range for the RGB color components is [0,1000].\n\nIf the color was initialized, then it returns the color ID. Otherwise, it returns -1.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.move_view-Tuple{Window,Int64,Int64}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.move_view",
    "category": "method",
    "text": "move_view(win::Window, y::Int, x::Int; update::Bool = true)\n\nMove the origin of the view of window win to the position (y,x). This routine makes sure that the view will never reach positions outside the buffer.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.move_view_inc-Tuple{Window,Int64,Int64}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.move_view_inc",
    "category": "method",
    "text": "move_view_inc(win::Window; Δy::Int, Δx::Int; kwargs...)\n\nMove the view of the window win to the position (y+Δy, x+Δx). This function has the same set of keywords of the function move_view.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.move_window-Tuple{Window,Int64,Int64}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.move_window",
    "category": "method",
    "text": "move_window(win::Window, starty::Int, startx::Int)\n\nMove the window win to the position (starty, startx).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.move_window_to_top-Tuple{Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.move_window_to_top",
    "category": "method",
    "text": "move_window_to_top(win::Window)\n\nMove window win to the top.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.ncurses_color",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.ncurses_color",
    "category": "function",
    "text": "ncurses_color([foreground, background,] attrs::Int = 0; kwargs...)\n\nReturn a mask to apply a color format with the foreground color foreground, background color background, and the attributes attrs.\n\nIf the pair (foreground, background) is omitted, then the foreground and background color will not be changed.\n\nThe colors can be specified by their names using Symbol or by their indices using Int.\n\nKeywords\n\nbold: If true, then apply bold format mask to attrs.         (Default = false)\nunderline: If true, then apply underline format mask to attrs.              (Default = false)\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.obj_desc-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.obj_desc",
    "category": "method",
    "text": "obj_desc(obj)\n\nReturn a string with the description of the object obj formed by:\n\n<Object type> (<Object address if mutable>)\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.obj_to_ptr-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.obj_to_ptr",
    "category": "method",
    "text": " function obj_to_ptr(obj)\n\nReturns the hexadecimal representation of the address of the object obj. It only works with mutable objects.  If obj is immutable, then 0x0 will be returned.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.post_menu-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.post_menu",
    "category": "method",
    "text": "post_menu(menu::TUI_MENU)\n\nPost the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.process_focus-Tuple{Any,Keystroke}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.process_focus",
    "category": "method",
    "text": "process_focus(widget, k::Keystroke)\n\nProcess the actions when widget widget is in focus and the keystroke k is pressed. If it returns false, then it is means that the widget was not capable to process the focus. Otherwise, it must return true.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.process_focus-Tuple{Keystroke}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.process_focus",
    "category": "method",
    "text": "process_focus(k::Keystroke)\n\nProcess the focus considering the user\'s keystorke k.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.process_focus-Tuple{TextUserInterfaces.TUI_MENU,Keystroke}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.process_focus",
    "category": "method",
    "text": "process_focus(menu::TUI_MENU, k::Keystroke)\n\nProcess the actions when the menu menu is in focus and the keystroke k was issued by the user.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.process_focus-Tuple{Window,Keystroke}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.process_focus",
    "category": "method",
    "text": "process_focus(window::Window, k::Keystroke)\n\nProcess the focus on window window due to keystroke k.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.redraw",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.redraw",
    "category": "function",
    "text": "redraw(widget)\n\nRedraw the widget inside its content window cwin.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.refresh_all_windows-Tuple{}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.refresh_all_windows",
    "category": "method",
    "text": "refresh_all_windows()\n\nRefresh all the windows, including the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.refresh_window-Tuple{String}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.refresh_window",
    "category": "method",
    "text": "refresh_window(id::String)\n\nRefresh the window with id id and all its parents windows except for the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.refresh_window-Tuple{WidgetContainer}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.refresh_window",
    "category": "method",
    "text": "refresh_window(container::WidgetContainer; force_redraw::Bool = false)\n\nAsk the parent widget to refresh the window. If force_redraw is true, then all widgets in the window will be updated.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.refresh_window-Tuple{Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.refresh_window",
    "category": "method",
    "text": "refresh_window(win::Window; force_redraw = false)\n\nRefresh the window win and its widget. If the view needs to be updated (see view_needs_update) or if force_redraw is true, then the content of the buffer will be copied to the view before updating.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.release_focus-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.release_focus",
    "category": "method",
    "text": "release_focus(widget)\n\nRequest focus to be released. It should return true if the focus can be released or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.release_focus-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.release_focus",
    "category": "method",
    "text": "release_focus(menu::TUI_MENU)\n\nRelease the focus from the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.remove_widget-Tuple{WidgetContainer,Widget}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.remove_widget",
    "category": "method",
    "text": "remove_widget(container::WidgetContainer, widget::Widget)\n\nRemove the widget widget from the container container.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.remove_widget-Tuple{Window,Widget}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.remove_widget",
    "category": "method",
    "text": "remove_widget(win::Window, widget::Widget)\n\nRemove the widget widget from the window win. If widget does not belong to win, then nothing is done.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.reposition!",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.reposition!",
    "category": "function",
    "text": "reposition!(object)\n\nReposition the object baesd on the stored configuration.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_focus-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.request_focus",
    "category": "method",
    "text": "request_focus(widget)\n\nRequest to focus to the widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_focus-Tuple{WidgetContainer,Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.request_focus",
    "category": "method",
    "text": "request_focus(container::WidgetContainer, widget)\n\nRequest the focus to the widget widget of the container container. It returns true if the focus could be changed or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_focus-Tuple{Window,Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.request_focus",
    "category": "method",
    "text": "request_focus(win::Window, widget)\n\nRequest the focus to the widget widget of the window win. This function is only necessary to make Window comply to the containers API. Since a window can contain only one widget, then a function to change the focus is not meaningful.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_focus-Tuple{Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.request_focus",
    "category": "method",
    "text": "request_focus(win::Window)\n\nRequest the focus to the window win. If win cannot get the focus, then nothing happens and it returns false. If wincan get the focus, then the focus is passed to it and the function returns true.\n\nRemarks\n\nEven if win is in the focus chain, the focus_id will not change by requesting focus to win. This means that the window focus order is not altered by this function.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_update-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.request_update",
    "category": "method",
    "text": "request_update(widget)\n\nRequest update of the widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_update-Tuple{Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.request_update",
    "category": "method",
    "text": "request_update(win::Window)\n\nRequest update of the window win because its widget was updated.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.select_item-Tuple{WidgetListBox,Int64}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.select_item",
    "category": "method",
    "text": "select_item(widget::WidgetListBox, id::Int)\n\nSelect the item id in the list box widget. Notice that id refers to the position of the item in the array data.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.selected_items-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.selected_items",
    "category": "method",
    "text": "selected_items(menu::TUI_MENU)\n\nReturn a Vector with the selected items in the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.selected_items_desc-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.selected_items_desc",
    "category": "method",
    "text": "selected_items_desc(menu::TUI_MENU)\n\nReturn a Vector with the selected items descriptions in the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.selected_items_names-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.selected_items_names",
    "category": "method",
    "text": "selected_items_names(menu::TUI_MENU)\n\nReturn a Vector with the selected items names in the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_color-Tuple{Int64}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.set_color",
    "category": "method",
    "text": "set_color([win::Window,] color::Int)\n\nSet the color of the window win to color (see ncurses_color). If win is omitted, then it defaults to the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_focus_chain-Tuple{Vararg{Window,N} where N}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.set_focus_chain",
    "category": "method",
    "text": "set_focus_chain(wins::Window...; new_focus_id::Int = 1)\n\nSet the focus chain, i.e. the ordered list of windows that can receive the focus. The keyword new_focus_id can be set to specify which element is currently focused in the new chain.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_menu_win-Tuple{TextUserInterfaces.TUI_MENU,Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.set_menu_win",
    "category": "method",
    "text": "set_menu_win(menu::TUI_MENU, win::Window)\n\nSet menu menu window to win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_next_window_func-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.set_next_window_func",
    "category": "method",
    "text": "set_next_window_func(f)\n\nSet the function f to be the one that will be called to check whether the user wants the next window. The signature must be:\n\nf(k::Keystroke)::Bool\n\nIt must return true if the next window is required of false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_previous_window_func-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.set_previous_window_func",
    "category": "method",
    "text": "set_previous_window_func(f)\n\nSet the function f to be the one that will be called to check whether the user wants the previous window. The signature must be:\n\nf(k::Keystroke)::Bool\n\nIt must return true if the previous window is required of false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_widget_color-Tuple{Any,Int64}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.set_widget_color",
    "category": "method",
    "text": "set_widget_color(widget, color::Int)\n\nSet the background color of widget to color.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_window_title-Tuple{Window,AbstractString}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.set_window_title",
    "category": "method",
    "text": "set_window_title(win::Window, title::AbstractString; ...)\n\nSet the title of the window win to title.\n\nKeywords\n\ntitle_color: Color mask that will be used to print the title. See                function ncurses_color. If negative, then the color will not                be changed. (Default = -1)\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.show_window-Tuple{Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.show_window",
    "category": "method",
    "text": "show_window(win::Window)\n\nShow the window win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.sync_cursor-Tuple{WidgetContainer}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.sync_cursor",
    "category": "method",
    "text": "sync_cursor(widget::WidgetContainer)\n\nSynchronize the cursor to the position of the focused widget in container container. This is necessary because all the operations are done in the buffer and then copied to the view.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.sync_cursor-Tuple{Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.sync_cursor",
    "category": "method",
    "text": "sync_cursor(window::Window)\n\nSynchronize the cursor to the position of the focused widget in window window. This is necessary because all the operations are done in the buffer and then copied to the view.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.unpost_menu-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.unpost_menu",
    "category": "method",
    "text": "unpost_menu(menu::TUI_MENU)\n\nUnpost the menu menu.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.unset_color-Tuple{Int64}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.unset_color",
    "category": "method",
    "text": "unset_color([win::Window,] color::Number)\n\nUnset the color color (see ncurses_color) in the window win. If win is omitted, then it defaults to the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.update-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.update",
    "category": "method",
    "text": "update(widget; force_redraw = false)\n\nUpdate the widget by calling the function redraw. This function returns true if the widget needed to be updated of false otherwise.\n\nIf force_redraw is true, then the widget will be updated even if it is not needed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.update_view-Tuple{Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.update_view",
    "category": "method",
    "text": "update_view(win::Window; force::Bool = false)\n\nUpdate the view of window win by copying the contents from the buffer. If the view does not need to be updated (see view_needs_update), then nothing is done. If the keyword force is true, then the copy will always happen.\n\nReturn\n\nIt returns true if the view has been updated and false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.validate_str-Union{Tuple{T}, Tuple{AbstractString,T}} where T",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.validate_str",
    "category": "method",
    "text": "validate_str(str::AbstractString, v)\n\nValidate the string str using the validator v. v is an element of the type that will be used to validate or a regex.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@composed_widget-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.@composed_widget",
    "category": "macro",
    "text": "@composed_widget(ex)\n\nDeclare a structure of a composed widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@connect_signal-Tuple{Any,Symbol,Any,Vararg{Any,N} where N}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.@connect_signal",
    "category": "macro",
    "text": "@connect_signal(obj, signal::Symbol, f::Symbol, vargs...)\n\nConnect the signal signal of the object obj to the function f passing the additional arguments vargs. Thus, when signal is emitted by obj, then fcall will be executed.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@disconnect_signal-Tuple{Any,Symbol}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.@disconnect_signal",
    "category": "macro",
    "text": "@disconnect_signal(obj, signal::Symbol)\n\nDisconnect the signal signal from object obj.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@emit_signal-Tuple{Any,Symbol,Vararg{Any,N} where N}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.@emit_signal",
    "category": "macro",
    "text": "@emit_signal(obj, signal::Symbol, params...)\n\nEmit the signal signal of the object obj with the parameters params..., causing to execute the connected function.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@forward_signal-Tuple{Any,Any,Symbol}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.@forward_signal",
    "category": "macro",
    "text": "@forward_signal(src, dest, signal::Symbol)\n\nForward the signal signal from src to dest. This means that every time that the signal signal is generated in src, then the function in dest will be called.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@log-Tuple{Any,Any,Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.@log",
    "category": "macro",
    "text": "macro log(level, msg, id)\n\nLog the messagem msg with level level of the caller id\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@log-Tuple{Any,Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.@log",
    "category": "macro",
    "text": "macro log(level, msg)\n\nLog the message msg with level level.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@widget-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.@widget",
    "category": "macro",
    "text": "@widget(ex)\n\nDeclare a structure of a widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._check_horizontal_anchor-Tuple{Anchor}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._check_horizontal_anchor",
    "category": "method",
    "text": "_check_horizontal_anchor(anchor::Anchor)\n\nCheck if the side parameter of anchor is valid for horizontal positioning. If anchor is _no_anchor, then true is always returned.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._check_vertical_anchor-Tuple{Anchor}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._check_vertical_anchor",
    "category": "method",
    "text": "_check_vertical_anchor(anchor::Nothing)\n_check_vertical_anchor(anchor::Anchor)\n\nCheck if the side parameter of anchor is valid for vertical positioning. If anchor is _no_anchor, then true is always returned.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._deselect_radio_button-Tuple{WidgetRadioButton}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._deselect_radio_button",
    "category": "method",
    "text": "_select_radio_button(rb::WidgetRadioButton)\n\nDeselect the radio button rb in its group name.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._destroy_widget-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._destroy_widget",
    "category": "method",
    "text": "_destroy_widget(widget; refresh::Bool = true)\n\nPrivate function that destroys a widget. This can be used if a new widget needs to reimplement the destroy function.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._draw_title-Tuple{WidgetContainer}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._draw_title",
    "category": "method",
    "text": "_draw_title(container::WidgetContainer)\n\nDraw the title in the container container.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_anchor-Tuple{Anchor,Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._get_anchor",
    "category": "method",
    "text": "_get_anchor(anchor::Anchor, parent)\n\nReturn the line or column related to the anchor anchor. If the object in anchor is the parent, then the positioning will be computed relative to the parent.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_color_index-Tuple{Symbol}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._get_color_index",
    "category": "method",
    "text": "_get_color_index(color::Symbol)\n\nReturn the index related to the color color.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_window_cur_pos-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._get_window_cur_pos",
    "category": "method",
    "text": "_get_window_cur_pos(win::Ptr{WINDOW})\n\nGet the cursor position of the window win and return it on a tuple (cur_y,cur_x).  If the window is not initialized, then this function returns (-1,-1).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_window_dims-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._get_window_dims",
    "category": "method",
    "text": "_get_window_dims(win::Ptr{WINDOW})\n\nGet the dimensions of the window win and return it on a tuple (dim_y,dim_x). If the window is not initialized, then this function returns (-1,-1).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._next_widget-Tuple{WidgetContainer}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._next_widget",
    "category": "method",
    "text": "_next_widget(container::WidgetContainer)\n\nMove the focus of container container to the next widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._previous_widget-Tuple{WidgetContainer}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._previous_widget",
    "category": "method",
    "text": "_previous_widget(container::WidgetContainer)\n\nMove the focus of container container to the previous widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._process_horizontal_info!-Tuple{ObjectPositioningConfiguration}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._process_horizontal_info!",
    "category": "method",
    "text": "_process_horizontal_info!(opc::ObjectPositioningConfiguration)\n\nProcess the horizontal positioning information in opc and write the variable horizontal of the same structure. The possible horizontal positioning information are:\n\n:aleft_aright: Left and right anchors were specified.\n:aleft_height: Left anchor and height were specified.\n:aright_height: Right anchor and height were specified.\n:acenter_height: Center anchor and height were specified.\n:right_height: Right and height were specified.\n:unknown: Insufficient information to compute the horizontal positioning.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._process_vertical_info!-Tuple{ObjectPositioningConfiguration}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._process_vertical_info!",
    "category": "method",
    "text": "_process_vertical_info!(opc::ObjectPositioningConfiguration)\n\nProcess the vertical positioning information in opc and write the variable vertical of the same structure. The possible vertical positioning information are:\n\n:abottom_atop: Bottom and top anchors were specified.\n:abottom_height: Bottom anchor and height were specified.\n:atop_height: Top anchor and height were specified.\n:amiddle_height: Middle anchor and height were specified.\n:top_height: Top and height were specified.\n:unknown: Insufficient information to compute the vertical positioning.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._select_radio_button-Tuple{WidgetRadioButton}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._select_radio_button",
    "category": "method",
    "text": "_select_radio_button(rb::WidgetRadioButton)\n\nSelect the radio button rb in its group name.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._str-Tuple{ObjectPositioningConfiguration}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._str",
    "category": "method",
    "text": "_str(wpc::ObjectPositioningConfiguration)\n\nConvert the information in wpc to a string for debugging purposes.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._try_focus-Tuple{Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces._try_focus",
    "category": "method",
    "text": "_try_focus(win::Window)\n\nTry to set to focus to the window win. If it was possible to make win the focused windows, then it returns true. Otherwise, it returns false.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_current_item-Tuple{WidgetListBox}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_current_item",
    "category": "method",
    "text": "get_selected_item(widget::WidgetListBox)\n\nReturn the ID of the current item of the list box widget and the data associated with it.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_height_for_child",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_height_for_child",
    "category": "function",
    "text": "get_height_for_child\n\nReturn the usable height of the object for a child object.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_left_for_child",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_left_for_child",
    "category": "function",
    "text": "get_left_for_child\n\nReturn the left of the object for a child object.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_parent-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_parent",
    "category": "method",
    "text": "get_parent(widget)\n\nReturn the parent of the widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_parent-Tuple{Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_parent",
    "category": "method",
    "text": "get_parent(win::Window)\n\nReturn nothing since the window has no parent.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_top_for_child",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_top_for_child",
    "category": "function",
    "text": "get_top_for_child\n\nReturn the top of the object for a child object.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_width_for_child",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.get_width_for_child",
    "category": "function",
    "text": "get_width_for_child\n\nReturn the usable width of object object for a child object.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.next_window-Tuple{}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.next_window",
    "category": "method",
    "text": "next_window()\n\nMove the focus to the next window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.previous_window-Tuple{}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.previous_window",
    "category": "method",
    "text": "previous_window()\n\nMove the focus to the previous window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_next_widget-Tuple{WidgetContainer}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.request_next_widget",
    "category": "method",
    "text": "request_next_widget(container::WidgetContainer)\n\nRequest the next widget in container. It returns true if a widget has get the focus or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_prev_widget-Tuple{WidgetContainer}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.request_prev_widget",
    "category": "method",
    "text": "request_prev_widget(container::WidgetContainer)\n\nRequest the previous widget in container. It returns true if a widget has get the focus or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_view_update-Tuple{Window}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.request_view_update",
    "category": "method",
    "text": "request_view_update(win::Window)\n\nRequest to update the view of window win. Notice that this must also request update on all parent windows until the root window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.require_cursor-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.require_cursor",
    "category": "method",
    "text": "require_cursor()\n\nIf true, then the physical cursor will be shown and the position will be updated according to its position in the widget window. Otherwise, the physical cursor will be hidden.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@derived_widget-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.@derived_widget",
    "category": "macro",
    "text": "@derived_widget(ex)\n\nDeclare a structure of a derived widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.@signal-Tuple{Any}",
    "page": "TextUserInterfaces",
    "title": "TextUserInterfaces.@signal",
    "category": "macro",
    "text": "@signal(name)\n\nCreate the signal named name. This must be used inside the widget structure that must be declared with @with_kw option (see package Parameters.jl).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#Library-1",
    "page": "TextUserInterfaces",
    "title": "Library",
    "category": "section",
    "text": "Documentation for TextUserInterfaces.Modules = [TextUserInterfaces]"
},

{
    "location": "lib/library_ncurses/#",
    "page": "NCurses",
    "title": "NCurses",
    "category": "page",
    "text": ""
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.fieldjust",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.fieldjust",
    "category": "constant",
    "text": "Dictionary defining values of the field justification.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.fieldopts",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.fieldopts",
    "category": "constant",
    "text": "Dictionary defining values of the field options.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.formcmd",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.formcmd",
    "category": "constant",
    "text": "Dictionary defining values of the form commands.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.menucmd",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.menucmd",
    "category": "constant",
    "text": "Dictionary defining values of the menu commands.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.WINDOW",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.WINDOW",
    "category": "type",
    "text": "struct WINDOW\n\nHandles a ncurses window.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.ACS_-Tuple{Symbol}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.ACS_",
    "category": "method",
    "text": "ACS_(s::Symbol)\n\nReturn the symbol s of the acs_map. For example, ACS_HLINE can be obtained from ACS_(:HLINE).\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.COLS-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.COLS",
    "category": "method",
    "text": "COLS()\n\nReturn the number of columns in the root window. It must be called after initscr().\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.LINES-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.LINES",
    "category": "method",
    "text": "LINES()\n\nReturn the number of lines in the root window. It must be called after initscr().\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.TYPE_ALNUM-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.TYPE_ALNUM",
    "category": "method",
    "text": "TYPE_ALNUM()\n\nReturn a pointer to the global symbol TYPE_ALNUM of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.TYPE_ALPHA-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.TYPE_ALPHA",
    "category": "method",
    "text": "TYPE_ALPHA()\n\nReturn a pointer to the global symbol TYPE_ALPHA of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.TYPE_ENUM-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.TYPE_ENUM",
    "category": "method",
    "text": "TYPE_ENUM()\n\nReturn a pointer to the global symbol TYPE_ENUM of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.TYPE_INTEGER-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.TYPE_INTEGER",
    "category": "method",
    "text": "TYPE_INTEGER()\n\nReturn a pointer to the global symbol TYPE_INTEGER of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.TYPE_IPV4-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.TYPE_IPV4",
    "category": "method",
    "text": "TYPE_IPV4()\n\nReturn a pointer to the global symbol TYPE_IPV4 of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.TYPE_IPV6-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.TYPE_IPV6",
    "category": "method",
    "text": "TYPE_IPV6()\n\nReturn a pointer to the global symbol TYPE_IPV6 of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.TYPE_NUMERIC-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.TYPE_NUMERIC",
    "category": "method",
    "text": "TYPE_NUMERIC()\n\nReturn a pointer to the global symbol TYPE_NUMERIC of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.TYPE_REGEXP-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.TYPE_REGEXP",
    "category": "method",
    "text": "TYPE_REGEXP()\n\nReturn a pointer to the global symbol TYPE_REGEXP of libform.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.attroff-Union{Tuple{T}, Tuple{T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.attroff",
    "category": "method",
    "text": "attroff(attrs::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.attron-Union{Tuple{T}, Tuple{T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.attron",
    "category": "method",
    "text": "attron(attrs::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.bkgd-Union{Tuple{T}, Tuple{T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.bkgd",
    "category": "method",
    "text": "bkgd(ch::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.bottom_panel-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.bottom_panel",
    "category": "method",
    "text": "bottom_panel(pan::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.box-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T,T}} where T<:Union{Char, Integer}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.box",
    "category": "method",
    "text": "box(win::Ptr{WINDOW}, verch::T, horch::T) where T<:jlchtype\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.can_change_color-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.can_change_color",
    "category": "method",
    "text": "can_change_color()\n\nReturn type: UInt8\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.cbreak-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.cbreak",
    "category": "method",
    "text": "cbreak()\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.clear-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.clear",
    "category": "method",
    "text": "clear()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.clrtobot-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.clrtobot",
    "category": "method",
    "text": "clrtobot()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.clrtoeol-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.clrtoeol",
    "category": "method",
    "text": "clrtoeol()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.copywin-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},Ptr{TextUserInterfaces.NCurses.WINDOW},T,T,T,T,T,T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.copywin",
    "category": "method",
    "text": "copywin(scr::Ptr{WINDOW}, dest::Ptr{WINDOW}, sminrow::T, smincol::T, dminrow::T, dmincol::T, dmaxrow::T, dmaxcol::T, overlay::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.current_item-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.current_item",
    "category": "method",
    "text": "function current_item(menu::Ptr{Cvoid})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.curs_set-Union{Tuple{T}, Tuple{T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.curs_set",
    "category": "method",
    "text": "curs_set(visibility::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.curses_version-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.curses_version",
    "category": "method",
    "text": "curses_version()\n\nReturn the NCurses version in a named tuple with the following fields:\n\nmajor: Major version.\nminor: Minor version.\npatch: Patch version.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.del_panel-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.del_panel",
    "category": "method",
    "text": "del_panel(panel::Ptr{Cvoid})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.delwin-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.delwin",
    "category": "method",
    "text": "delwin(win::Ptr{WINDOW})\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.derwin-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T,T,T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.derwin",
    "category": "method",
    "text": "derwin(win::Ptr{WINDOW}, nlines::T, ncols::T, begin_y::T, begin_x::T) where T<:Integer\n\nReturn type: Ptr{TextUserInterfaces.NCurses.WINDOW}\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.doupdate-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.doupdate",
    "category": "method",
    "text": "doupdate()\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.endwin-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.endwin",
    "category": "method",
    "text": "endwin()\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.erase-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.erase",
    "category": "method",
    "text": "erase()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.field_buffer-Union{Tuple{T}, Tuple{Ptr{Nothing},T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.field_buffer",
    "category": "method",
    "text": "field_buffer(field::Ptr{Cvoid}, buffer::T) where T<:Integer\n\nReturn type: Cstring\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.form_driver-Union{Tuple{T}, Tuple{Ptr{Nothing},T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.form_driver",
    "category": "method",
    "text": "form_driver(form::Ptr{Cvoid}, ch::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.free_field-Union{Tuple{Ptr{Nothing}}, Tuple{T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.free_field",
    "category": "method",
    "text": "free_field(field::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.free_form-Union{Tuple{Ptr{Nothing}}, Tuple{T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.free_form",
    "category": "method",
    "text": "free_form(form::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.free_item-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.free_item",
    "category": "method",
    "text": "function free_item(item::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.free_menu-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.free_menu",
    "category": "method",
    "text": "function free_menu(menu::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.getbegx-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.getbegx",
    "category": "method",
    "text": "getbegx(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.getbegy-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.getbegy",
    "category": "method",
    "text": "getbegy(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.getch-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.getch",
    "category": "method",
    "text": "getch()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.getcurx-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.getcurx",
    "category": "method",
    "text": "getcurx(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.getcury-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.getcury",
    "category": "method",
    "text": "getcury(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.getmaxx-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.getmaxx",
    "category": "method",
    "text": "getmaxx(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.getmaxy-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.getmaxy",
    "category": "method",
    "text": "getmaxy(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.has_colors-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.has_colors",
    "category": "method",
    "text": "has_colors()\n\nReturn type: UInt8\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.hide_panel-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.hide_panel",
    "category": "method",
    "text": "hide_panel(panel::Ptr{Cvoid})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.hline-Union{Tuple{Ti}, Tuple{Tc}, Tuple{Tc,Ti}} where Ti<:Integer where Tc<:Union{Char, Integer}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.hline",
    "category": "method",
    "text": "hline(ch::Tc, n::Ti) where {Tc<:jlchtype,Ti<:Integer}\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.init_color-Union{Tuple{T}, NTuple{4,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.init_color",
    "category": "method",
    "text": "init_color(color::T, r::T, g::T, b::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.init_pair-Union{Tuple{T}, Tuple{T,T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.init_pair",
    "category": "method",
    "text": "init_pair(pair::T, f::T, b::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.initscr-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.initscr",
    "category": "method",
    "text": "initscr()\n\nReturn type: Ptr{TextUserInterfaces.NCurses.WINDOW}\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.item_description-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.item_description",
    "category": "method",
    "text": "function item_description(menu::Ptr{Cvoid})\n\nReturn type: Cstring\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.item_index-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.item_index",
    "category": "method",
    "text": "function item_index(menu::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.item_name-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.item_name",
    "category": "method",
    "text": "function item_name(menu::Ptr{Cvoid})\n\nReturn type: Cstring\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.item_value-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.item_value",
    "category": "method",
    "text": "function item_value(item::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.keypad-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},Bool}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.keypad",
    "category": "method",
    "text": "keypad(win::Ptr{WINDOW}, bf::Bool)\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.leaveok-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},Bool}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.leaveok",
    "category": "method",
    "text": "leaveok(win::Ptr{WINDOW}, bf::Bool)\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.load_ncurses-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.load_ncurses",
    "category": "method",
    "text": "load_ncurses([dir::String])\n\nLoad ncurses libraries at directory dir. If it is omitted or if it is empty, then the bundled Ncurses version in the package Ncurses_jll will be used.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.menu_driver-Union{Tuple{T}, Tuple{Ptr{Nothing},T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.menu_driver",
    "category": "method",
    "text": "function menu_driver(menu::Ptr{Cvoid}, c::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.mouseinterval-Union{Tuple{T}, Tuple{T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.mouseinterval",
    "category": "method",
    "text": "mouseinterval(n::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.move_panel-Union{Tuple{T}, Tuple{Ptr{Nothing},T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.move_panel",
    "category": "method",
    "text": "move_panel(panel::Ptr{Cvoid}, starty::T, startx::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.mvhline-Union{Tuple{Ti}, Tuple{Tc}, Tuple{Ti,Ti,Tc,Ti}} where Ti<:Integer where Tc<:Union{Char, Integer}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.mvhline",
    "category": "method",
    "text": "mvhline(y::Ti, x::Ti, ch::Tc, n::Ti) where {Tc<:jlchtype,Ti<:Integer}\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.mvprintw-Union{Tuple{Ts}, Tuple{Ti}, Tuple{Ti,Ti,Ts}} where Ts<:AbstractString where Ti<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.mvprintw",
    "category": "method",
    "text": "mvprintw(y::Ti, x::Ti, str::Ts) where {Ti<:Integer,Ts<:AbstractString}\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.mvvline-Union{Tuple{Ti}, Tuple{Tc}, Tuple{Ti,Ti,Tc,Ti}} where Ti<:Integer where Tc<:Union{Char, Integer}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.mvvline",
    "category": "method",
    "text": "mvvline(y::Ti, x::Ti, ch::Tc, n::Ti) where {Tc<:jlchtype,Ti<:Integer}\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.mvwhline-Union{Tuple{Ti}, Tuple{Tc}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},Ti,Ti,Tc,Ti}} where Ti<:Integer where Tc<:Union{Char, Integer}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.mvwhline",
    "category": "method",
    "text": "mvwhline(win::Ptr{WINDOW}, y::Ti, x::Ti, ch::Tc, n::Ti) where {Tc<:jlchtype,Ti<:Integer}\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.mvwin-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.mvwin",
    "category": "method",
    "text": "mvwin(win::Ptr{WINDOW}, y::T, x::T) where T<:Integer\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.mvwprintw-Union{Tuple{Ts}, Tuple{Ti}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},Ti,Ti,Ts}} where Ts<:AbstractString where Ti<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.mvwprintw",
    "category": "method",
    "text": "mvwprintw(win::Ptr{WINDOW}, y::Ti, x::Ti, str::Ts) where {Ti<:Integer,Ts<:AbstractString}\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.mvwvline-Union{Tuple{Ti}, Tuple{Tc}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},Ti,Ti,Tc,Ti}} where Ti<:Integer where Tc<:Union{Char, Integer}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.mvwvline",
    "category": "method",
    "text": "mvwvline(win::Ptr{WINDOW}, y::Ti, x::Ti, ch::Tc, n::Ti) where {Tc<:jlchtype,Ti<:Integer}\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.new_form-Union{Tuple{Array{Ptr{Nothing},1}}, Tuple{T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.new_form",
    "category": "method",
    "text": "new_form(fields::Vector{Ptr{Cvoid}})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.new_item-Union{Tuple{T}, Tuple{T,T}} where T<:AbstractString",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.new_item",
    "category": "method",
    "text": "function new_item(name::T, description::T) where T<:AbstractString\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.new_menu-Tuple{Array{Ptr{Nothing},1}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.new_menu",
    "category": "method",
    "text": "function new_menu(items::Vector{Ptr{Cvoid}})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.new_panel-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.new_panel",
    "category": "method",
    "text": "new_panel(win::Ptr{WINDOW})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.newpad-Union{Tuple{T}, Tuple{T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.newpad",
    "category": "method",
    "text": "newpad(lines::T, cols::T) where T<:Integer\n\nReturn type: Ptr{TextUserInterfaces.NCurses.WINDOW}\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.newwin-Union{Tuple{T}, NTuple{4,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.newwin",
    "category": "method",
    "text": "newwin(lines::T, cols::T, y::T, x::T) where T<:Integer\n\nReturn type: Ptr{TextUserInterfaces.NCurses.WINDOW}\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.nodelay-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},Bool}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.nodelay",
    "category": "method",
    "text": "nodelay(win::Ptr{WINDOW}, bf::Bool)\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.noecho-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.noecho",
    "category": "method",
    "text": "noecho()\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.notimeout-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},Bool}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.notimeout",
    "category": "method",
    "text": "notimeout(win::Ptr{WINDOW}, bf::Bool)\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.panel_userptr-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.panel_userptr",
    "category": "method",
    "text": "panel_userptr(pan::Ptr{Cvoid})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.pnoutrefresh-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T,T,T,T,T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.pnoutrefresh",
    "category": "method",
    "text": "pnoutrefresh(win::Ptr{WINDOW}, pminrow::T, pmincol::T, sminrow::T, smincol::T, smaxrow::T, smaxcol::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.pos_form_cursor-Union{Tuple{Ptr{Nothing}}, Tuple{T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.pos_form_cursor",
    "category": "method",
    "text": "pos_form_cursor(form::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.pos_menu_cursor-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.pos_menu_cursor",
    "category": "method",
    "text": "function pos_menu_cursor(menu::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.post_form-Union{Tuple{Ptr{Nothing}}, Tuple{T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.post_form",
    "category": "method",
    "text": "post_form(form::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.post_menu-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.post_menu",
    "category": "method",
    "text": "function post_menu(menu::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.prefresh-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T,T,T,T,T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.prefresh",
    "category": "method",
    "text": "prefresh(win::Ptr{WINDOW}, pminrow::T, pmincol::T, sminrow::T, smincol::T, smaxrow::T, smaxcol::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.printw-Union{Tuple{T}, Tuple{T}} where T<:AbstractString",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.printw",
    "category": "method",
    "text": "printw(str::T) where T<:AbstractString\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.refresh-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.refresh",
    "category": "method",
    "text": "refresh()\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.resizeterm-Union{Tuple{T}, Tuple{T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.resizeterm",
    "category": "method",
    "text": "resizeterm(lines::T, columns::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_field_back-Union{Tuple{T}, Tuple{Ptr{Nothing},T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_field_back",
    "category": "method",
    "text": "set_field_back(field::Ptr{Cvoid}, value::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_field_buffer-Union{Tuple{Ts}, Tuple{Ti}, Tuple{Ptr{Nothing},Ti,Ts}} where Ts<:AbstractString where Ti<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_field_buffer",
    "category": "method",
    "text": "set_field_buffer(field::Ptr{Cvoid}, buf::Ti, c::Ts) where {Ti<:Integer,Ts<:AbstractString}\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_field_just-Union{Tuple{T}, Tuple{Ptr{Nothing},T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_field_just",
    "category": "method",
    "text": "set_field_just(field::Ptr{Cvoid}, justification::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_field_opts-Union{Tuple{T}, Tuple{Ptr{Nothing},T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_field_opts",
    "category": "method",
    "text": "set_field_opts(field::Ptr{Cvoid}, field_options::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_field_type-Union{Tuple{T}, Tuple{Ptr{Nothing},Ptr{Nothing},Array{T,1} where T,T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_field_type",
    "category": "method",
    "text": "set_field_type(field::Ptr{Cvoid}, type::Ptr{Cvoid}, valuelist::Vector, checkcase::T, checkunique::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_field_type-Union{Tuple{T}, Tuple{Ptr{Nothing},Ptr{Nothing},String}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_field_type",
    "category": "method",
    "text": "set_field_type(field::Ptr{Cvoid}, type::Ptr{Cvoid}, regex::String)\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_field_type-Union{Tuple{T}, Tuple{Ptr{Nothing},Ptr{Nothing},T,Float64,Float64}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_field_type",
    "category": "method",
    "text": "set_field_type(field::Ptr{Cvoid}, type::Ptr{Cvoid}, padding::T, vmin::Float64, vmax::Float64) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_field_type-Union{Tuple{T}, Tuple{Ptr{Nothing},Ptr{Nothing},T,T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_field_type",
    "category": "method",
    "text": "set_field_type(field::Ptr{Cvoid}, type::Ptr{Cvoid}, padding::T, vmin::T, vmax::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_field_type-Union{Tuple{T}, Tuple{Ptr{Nothing},Ptr{Nothing},T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_field_type",
    "category": "method",
    "text": "set_field_type(field::Ptr{Cvoid}, type::Ptr{Cvoid}, arg::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_form_opts-Union{Tuple{T}, Tuple{Ptr{Nothing},T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_form_opts",
    "category": "method",
    "text": "set_form_opts(form::Ptr{Cvoid}, form_options::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_form_sub-Union{Tuple{Ptr{Nothing},Ptr{TextUserInterfaces.NCurses.WINDOW}}, Tuple{T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_form_sub",
    "category": "method",
    "text": "set_form_sub(form::Ptr{Cvoid}, win_form::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_form_win-Union{Tuple{Ptr{Nothing},Ptr{TextUserInterfaces.NCurses.WINDOW}}, Tuple{T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_form_win",
    "category": "method",
    "text": "set_form_win(form::Ptr{Cvoid}, win_form::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_menu_format-Union{Tuple{T}, Tuple{Ptr{Nothing},T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_menu_format",
    "category": "method",
    "text": "function set_menu_format(menu::Ptr{Cvoid}, rows::T, cols::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_menu_mark-Union{Tuple{T}, Tuple{Ptr{Nothing},T}} where T<:AbstractString",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_menu_mark",
    "category": "method",
    "text": "function set_menu_mark(menu::Ptr{Cvoid}, mark::T) where T<:AbstractString\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_menu_opts-Union{Tuple{T}, Tuple{Ptr{Nothing},T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_menu_opts",
    "category": "method",
    "text": "function set_menu_opts(menu::Ptr{Cvoid}, opts::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_menu_sub-Tuple{Ptr{Nothing},Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_menu_sub",
    "category": "method",
    "text": "function set_menu_sub(menu::Ptr{Cvoid}, win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_menu_win-Tuple{Ptr{Nothing},Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_menu_win",
    "category": "method",
    "text": "function set_menu_win(menu::Ptr{Cvoid}, win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.set_panel_userptr-Tuple{Ptr{Nothing},Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.set_panel_userptr",
    "category": "method",
    "text": "set_panel_userptr(pan::Ptr{Cvoid}, ptr::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.show_panel-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.show_panel",
    "category": "method",
    "text": "show_panel(panel::Ptr{Cvoid})\n\nReturn type: Ptr{Nothing}\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.start_color-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.start_color",
    "category": "method",
    "text": "start_color()\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.subpad-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T,T,T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.subpad",
    "category": "method",
    "text": "subpad(win::Ptr{WINDOW}, nlines::T, ncols::T, begin_y::T, begin_x::T) where T<:Integer\n\nReturn type: Ptr{TextUserInterfaces.NCurses.WINDOW}\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.top_panel-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.top_panel",
    "category": "method",
    "text": "top_panel(pan::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.touchwin-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.touchwin",
    "category": "method",
    "text": "touchwin(win::Ptr{WINDOW})\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.unpost_form-Union{Tuple{Ptr{Nothing}}, Tuple{T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.unpost_form",
    "category": "method",
    "text": "unpost_form(form::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libform documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.unpost_menu-Tuple{Ptr{Nothing}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.unpost_menu",
    "category": "method",
    "text": "function unpost_menu(menu::Ptr{Cvoid})\n\nReturn type: Int32\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.update_panels-Tuple{}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.update_panels",
    "category": "method",
    "text": "update_panels()\n\nReturn type: Nothing\n\nFor more information, consult libmenu documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.vline-Union{Tuple{Ti}, Tuple{Tc}, Tuple{Tc,Ti}} where Ti<:Integer where Tc<:Union{Char, Integer}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.vline",
    "category": "method",
    "text": "vline(ch::Tc, n::Ti) where {Tc<:jlchtype,Ti<:Integer}\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.waddch-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T}} where T<:Union{Char, Integer}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.waddch",
    "category": "method",
    "text": "waddch(win::Ptr{WINDOW}, ch::T) where T<:jlchtype\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wattroff-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wattroff",
    "category": "method",
    "text": "wattroff(win::Ptr{WINDOW}, attrs::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wattron-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wattron",
    "category": "method",
    "text": "wattron(win::Ptr{WINDOW}, attrs::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wbkgd-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wbkgd",
    "category": "method",
    "text": "wbkgd(win::Ptr{WINDOW}, ch::T) where T<:Integer\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wborder-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wborder",
    "category": "method",
    "text": "wborder(win::Ptr{WINDOW})\n\nCall the function wborder(win, 0, 0, 0, 0, 0, 0, 0, 0).\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wborder-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T,T,T,T,T,T,T,T}} where T<:Union{Char, Integer}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wborder",
    "category": "method",
    "text": "wborder(win::Ptr{WINDOW}, ls::T, rs::T, ts::T, bs::T, tl::T, tr::T, bl::T, br::T) where T<:jlchtype\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wclear-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wclear",
    "category": "method",
    "text": "wclear(win::Ptr{WINDOW})\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wclrtobot-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wclrtobot",
    "category": "method",
    "text": "wclrtobot(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wclrtoeol-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wclrtoeol",
    "category": "method",
    "text": "wclrtoeol(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.werase-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.werase",
    "category": "method",
    "text": "werase(win::Ptr{WINDOW})\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wgetch-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wgetch",
    "category": "method",
    "text": "wgetch(win::Ptr{WINDOW})\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.whline-Union{Tuple{Ti}, Tuple{Tc}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},Tc,Ti}} where Ti<:Integer where Tc<:Union{Char, Integer}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.whline",
    "category": "method",
    "text": "whline(win::Ptr{WINDOW}, ch::Tc, n::Ti) where {Tc<:jlchtype,Ti<:Integer}\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wmove-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wmove",
    "category": "method",
    "text": "wmove(win::Ptr{WINDOW}, y::T, x::T) where T<:Integer\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wnoutrefresh-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wnoutrefresh",
    "category": "method",
    "text": "wnoutrefresh(win::Ptr{WINDOW})\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wprintw-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T}} where T<:AbstractString",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wprintw",
    "category": "method",
    "text": "wprintw(win::Ptr{WINDOW}, str::T) where T<:AbstractString\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wrefresh-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wrefresh",
    "category": "method",
    "text": "wrefresh(win::Ptr{WINDOW})\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wresize-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T,T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wresize",
    "category": "method",
    "text": "wresize(win::Ptr{WINDOW}, lines::T, cols::T) where T<:Integer\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wtimeout-Union{Tuple{T}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},T}} where T<:Integer",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wtimeout",
    "category": "method",
    "text": "wtimeout(win::Ptr{WINDOW}, delay::T) where T<:Integer\n\nReturn type: Nothing\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.wvline-Union{Tuple{Ti}, Tuple{Tc}, Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW},Tc,Ti}} where Ti<:Integer where Tc<:Union{Char, Integer}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.wvline",
    "category": "method",
    "text": "wvline(win::Ptr{WINDOW}, ch::Tc, n::Ti) where {Tc<:jlchtype,Ti<:Integer}\n\nReturn type: Int32\n\nFor more information, consult libncurses documentation.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.NCURSES",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.NCURSES",
    "category": "type",
    "text": "struct NCURSES\n\nThis private structure handles some global variables that are used in the ncurses wrapper.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.@_ccallf-Tuple{Any}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.@_ccallf",
    "category": "macro",
    "text": "@_ccallf expr\n\nMake a ccall to a libform function. The usage should be:\n\n@_ccallf function(arg1::Type1, arg2::Type2, ...)::TypeReturn\n\nIt uses the global constant structure ncurses to call the function. Hence, it must be initialized.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.@_ccallm-Tuple{Any}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.@_ccallm",
    "category": "macro",
    "text": "@_ccallm expr\n\nMake a ccall to a libmenu function. The usage should be:\n\n@_ccallm function(arg1::Type1, arg2::Type2, ...)::TypeReturn\n\nIt uses the global constant structure ncurses to call the function. Hence, it must be initialized.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.@_ccalln-Tuple{Any}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.@_ccalln",
    "category": "macro",
    "text": "@_ccalln expr\n\nMake a ccall to a libncurses function. The usage should be:\n\n@_ccalln function(arg1::Type1, arg2::Type2, ...)::TypeReturn\n\nIt uses the global constant structure ncurses to call the function. Hence, it must be initialized.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#TextUserInterfaces.NCurses.@_ccallp-Tuple{Any}",
    "page": "NCurses",
    "title": "TextUserInterfaces.NCurses.@_ccallp",
    "category": "macro",
    "text": "@_ccallm expr\n\nMake a ccall to a libpanel function. The usage should be:\n\n@_ccallm function(arg1::Type1, arg2::Type2, ...)::TypeReturn\n\nIt uses the global constant structure ncurses to call the function. Hence, it must be initialized.\n\n\n\n\n\n"
},

{
    "location": "lib/library_ncurses/#NCurses-library-1",
    "page": "NCurses",
    "title": "NCurses library",
    "category": "section",
    "text": "Documentation for TextUserInterfaces.NCurses.Modules = [TextUserInterfaces.NCurses]"
},

]}
