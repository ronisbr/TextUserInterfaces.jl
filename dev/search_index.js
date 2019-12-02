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
    "location": "lib/library/#TextUserInterfaces.NCurses.init_color-Tuple{Symbol,Int64,Int64,Int64}",
    "page": "Library",
    "title": "TextUserInterfaces.NCurses.init_color",
    "category": "method",
    "text": "function init_color(name::Symbol, r::Int, g::Int, b::Int)\n\nInitialize the color with name name and RGB color r, g, and b.  Notice that the range for the last three variables is [0,1000].\n\nIf the color is already initialized, then nothing will be changed.\n\nIf the color was initialized, then it returns the color ID. Otherwise, it returns -1.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.add_widget-Tuple{WidgetContainer,Widget}",
    "page": "Library",
    "title": "TextUserInterfaces.add_widget",
    "category": "method",
    "text": "function add_widget(container::WidgetContainer, widget::Widget)\n\nAdd the widget widget to the container `container.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.add_widget-Tuple{Window,Widget}",
    "page": "Library",
    "title": "TextUserInterfaces.add_widget",
    "category": "method",
    "text": "function add_widget(win::Window, widget::Widget)\n\nAdd widget widget to the window win. If the win already have a widget, then it will be replaced.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.change_label-Tuple{WidgetButton,AbstractString}",
    "page": "Library",
    "title": "TextUserInterfaces.change_label",
    "category": "method",
    "text": "function change_label(button::WidgetButton, label::AbstractString)\n\nChange the label of button button to label.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.create_widget_common-Tuple{Union{Widget, Window},TextUserInterfaces.WidgetPositioningConfiguration}",
    "page": "Library",
    "title": "TextUserInterfaces.create_widget_common",
    "category": "method",
    "text": "function create_widget_common(parent::WidgetParent, posconf::WidgetPositioningConfiguration)\n\nCreate all the variables in the common structure of the widget API.\n\nArgs\n\nparent: Parent widget.\nposconf: Widget positioning configuration            (see WidgetPositioningConfiguration).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_window",
    "page": "Library",
    "title": "TextUserInterfaces.create_window",
    "category": "function",
    "text": "function create_window(nlines::Integer, ncols::Integer, begin_y::Integer, begin_x::Integer, id::String = \"\"; bcols::Integer = 0, blines::Integer = 0, border::Bool = true, border_color::Int = -1, title::String = \"\", title_color::Int = -1)\n\nCreate a window. The new window size will be nlines × ncols and the origin will be placed at (begin_y, begin_x) coordinate of the root window. The window ID id is used to identify the new window in the global window list.\n\nKeyword\n\nbcols: Number of columns in the window buffer. This will be automatically          increased to, at least, fit the viewable part of the window          (ncols). (Default = 0)\nblines: Number of lines in the window buffer. This will be automatically           increased to, at least, fit the viewable part of the window           (nlines). (Default = 0)\nborder: If true, then the window will have a border. (Default =           true)\nborder_color: Color mask that will be used to print the border. See function                 ncurses_color. If negative, then the color will not be                 changed. (Default = -1)\nfocusable: If true, then the window can have focus. Otherwise, all focus              request will be rejected. (Default = true)\ntitle: The title of the window, which will only be printed if border is          true. (Default = \"\")\ntitle_color: Color mask that will be used to print the title. See                function ncurses_color. If negative, then the color will not                be changed. (Default = -1)\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.create_window_with_container-Tuple",
    "page": "Library",
    "title": "TextUserInterfaces.create_window_with_container",
    "category": "method",
    "text": "function create_window_with_container(vargs...; kwargs...)\n\nCreate a window with a container as its widget. The arguments and keywords are the same ones of the function create_window. The container will have the same size of the window buffer.\n\nReturn\n\nThe created window.\nThe created container.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.get_buffer-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.get_buffer",
    "category": "method",
    "text": "function get_buffer(widget)\n\nReturn the buffer of the widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_buffer-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.get_buffer",
    "category": "method",
    "text": "function get_buffer(win::Window)\n\nReturn the buffer of the window win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_color_pair-Tuple{Symbol,Symbol}",
    "page": "Library",
    "title": "TextUserInterfaces.get_color_pair",
    "category": "method",
    "text": "function get_color_pair(foreground::Symbol, background::Symbol)\n\nReturn the ID of the color pair (foreground, background), or nothing if the color pair is not initialized.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_data-Union{Tuple{WidgetInputField{T,P}}, Tuple{P}, Tuple{T}} where P<:String where T",
    "page": "Library",
    "title": "TextUserInterfaces.get_data",
    "category": "method",
    "text": "function get_data(widget::WidgetInputField)\n\nGet the data of widget. If a validator of type DataType is provided, then it will return the parsed data. Otherwise, it will return a string.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_field_data",
    "page": "Library",
    "title": "TextUserInterfaces.get_field_data",
    "category": "function",
    "text": "function get_field_data(field::TUI_FIELD, buffer::Int = 0)\n\nGet the data of the field field at buffer buffer.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_field_data",
    "page": "Library",
    "title": "TextUserInterfaces.get_field_data",
    "category": "function",
    "text": "function get_field_data(form::TUI_FORM, field_id::String, buffer::Int = 0)\n\nGet the data of the field with ID field_id at buffer buffer in the form form\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_focused_window-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.get_focused_window",
    "category": "method",
    "text": "function get_focused_window()\n\nReturn the focused window.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_height-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.get_height",
    "category": "method",
    "text": "function get_height(widget)\n\nReturn the height of widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_height-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.get_height",
    "category": "method",
    "text": "function get_height(win::Window)\n\nReturn the height of the buffer of the window win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_selected-Tuple{AbstractString}",
    "page": "Library",
    "title": "TextUserInterfaces.get_selected",
    "category": "method",
    "text": "function get_selected(group_name::AbstractString)\n\nReturn the WidgetRadioButton that is selected in group with name group_name. If the group_name does not exists or if no button is selected, then nothing is returned.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_width-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.get_width",
    "category": "method",
    "text": "function get_width(widget)\n\nReturn the width of widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.get_width-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.get_width",
    "category": "method",
    "text": "function get_width(win::Window)\n\nReturn the width of the buffer of the window win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.has_focus-Tuple{WidgetContainer,Any}",
    "page": "Library",
    "title": "TextUserInterfaces.has_focus",
    "category": "method",
    "text": "function has_focus(container::WidgetContainer, widget)\n\nReturn true if the widget widget is in focus on container container, or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.has_focus-Tuple{Window,Any}",
    "page": "Library",
    "title": "TextUserInterfaces.has_focus",
    "category": "method",
    "text": "function has_focus(window::Window, widget)\n\nReturn true if the widget widget is in focus on window window, or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.hide_window-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.hide_window",
    "category": "method",
    "text": "function hide_window(win::Window)\n\nHide the window win.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.init_tui",
    "page": "Library",
    "title": "TextUserInterfaces.init_tui",
    "category": "function",
    "text": "function init_tui(dir::String = \"\")\n\nInitialize the Text User Interface (TUI). The full-path of the ncurses directory can be specified by dir. If it is empty or omitted, then it will look on the default library directories.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.jlgetch",
    "page": "Library",
    "title": "TextUserInterfaces.jlgetch",
    "category": "function",
    "text": "function jlgetch(win::Union{Ptr{WINDOW},Nothing} = nothing)\n\nWait for an keystroke in the window win and return it (see Keystroke).  If win is nothing, then getch() will be used instead of wgetch(win) to listen for the keystroke.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.log_message",
    "page": "Library",
    "title": "TextUserInterfaces.log_message",
    "category": "function",
    "text": "function log_message(level::Int, msg::AbstractString, id::AbstractString = \"\")\n\nLog the message msg with level level. The ID of the called can be specified by id.\n\nIf a line is @log_pad X, then the following lines will have a padding of X.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.ncurses_color",
    "page": "Library",
    "title": "TextUserInterfaces.ncurses_color",
    "category": "function",
    "text": "function ncurses_color([foreground::Symbol, background::Symbol,] attrs::Int = 0; kwargs...)\n\nReturn a mask to apply a color format with the foreground color foreground, background color background, and the attributes attrs.\n\nIf the pair (foreground, background) is omitted, then the foreground and background color will not be changed.\n\nKeywords\n\nbold: If true, then apply bold format mask to attrs.         (Default = false)\nunderline: If true, then apply underline format mask to attrs.              (Default = false)\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.post_form-Tuple{TextUserInterfaces.TUI_FORM}",
    "page": "Library",
    "title": "TextUserInterfaces.post_form",
    "category": "method",
    "text": "function post_form(form::TUI_FORM)\n\nPost the for form.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.post_menu-Tuple{TextUserInterfaces.TUI_MENU}",
    "page": "Library",
    "title": "TextUserInterfaces.post_menu",
    "category": "method",
    "text": "function post_menu(menu::TUI_MENU)\n\nPost the menu menu.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.refresh_window-Tuple{WidgetContainer}",
    "page": "Library",
    "title": "TextUserInterfaces.refresh_window",
    "category": "method",
    "text": "function refresh_window(container::WidgetContainer; force_redraw::Bool = false)\n\nAsk the parent widget to refresh the window. If force_redraw is true, then all widgets in the window will be updated.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.refresh_window-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.refresh_window",
    "category": "method",
    "text": "function refresh_window(win::Window; force_redraw = false)\n\nRefresh the window win and its widget. If the view needs to be updated (see view_needs_update) or if force_redraw is true, then the content of the buffer will be copied to the view before updating.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.remove_widget-Tuple{WidgetContainer,Widget}",
    "page": "Library",
    "title": "TextUserInterfaces.remove_widget",
    "category": "method",
    "text": "function remove_widget(container::WidgetContainer, widget::Widget)\n\nRemove the widget widget from the container container.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.remove_widget-Tuple{Window,Widget}",
    "page": "Library",
    "title": "TextUserInterfaces.remove_widget",
    "category": "method",
    "text": "function remove_widget(win::Window, widget::Widget)\n\nRemove the widget widget from the window win. If widget does not belong to win, then nothing is done.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_focus-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.request_focus",
    "category": "method",
    "text": "function request_focus(widget)\n\nRequest to focus to the widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_focus-Tuple{WidgetContainer,Any}",
    "page": "Library",
    "title": "TextUserInterfaces.request_focus",
    "category": "method",
    "text": "function request_focus(container::WidgetContainer, widget)\n\nRequest the focus to the widget widget of the container container. It returns true if the focus could be changed or false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_focus-Tuple{Window,Any}",
    "page": "Library",
    "title": "TextUserInterfaces.request_focus",
    "category": "method",
    "text": "function request_focus(win::Window, widget)\n\nRequest the focus to the widget widget of the window win. This function is only necessary to make Window comply to the containers API. Since a window can contain only one widget, then a function to change the focus is not meaningful.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_update-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces.request_update",
    "category": "method",
    "text": "function request_update(widget)\n\nRequest update of the widget widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.request_update-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.request_update",
    "category": "method",
    "text": "function request_update(win::Window)\n\nRequest update of the window win because its widget was updated.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.set_focus_chain-Tuple{Vararg{Window,N} where N}",
    "page": "Library",
    "title": "TextUserInterfaces.set_focus_chain",
    "category": "method",
    "text": "function set_focus_chain(wins::Window...; new_focus_id::Integer = 1)\n\nSet the focus chain, i.e. the ordered list of windows that can receive the focus. The keyword new_focus_id can be set to specify which element is currently focused in the new chain.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.set_form_win-Tuple{TextUserInterfaces.TUI_FORM,Window}",
    "page": "Library",
    "title": "TextUserInterfaces.set_form_win",
    "category": "method",
    "text": "function set_form_win(form::TUI_FORM, win::Window)\n\nSet the form form window to win.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.show_window-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.show_window",
    "category": "method",
    "text": "function show_window(win::Window)\n\nShow the window win.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.sync_cursor-Tuple{WidgetContainer}",
    "page": "Library",
    "title": "TextUserInterfaces.sync_cursor",
    "category": "method",
    "text": "function sync_cursor(widget::WidgetContainer)\n\nSynchronize the cursor to the position of the focused widget in container container. This is necessary because all the operations are done in the buffer and then copied to the view.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.sync_cursor-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.sync_cursor",
    "category": "method",
    "text": "function sync_cursor(window::Window)\n\nSynchronize the cursor to the position of the focused widget in window window. This is necessary because all the operations are done in the buffer and then copied to the view.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.unpost_form-Tuple{TextUserInterfaces.TUI_FORM}",
    "page": "Library",
    "title": "TextUserInterfaces.unpost_form",
    "category": "method",
    "text": "function unpost_form(form::TUI_FORM)\n\nUnpost the form form.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces.update_view-Tuple{Window}",
    "page": "Library",
    "title": "TextUserInterfaces.update_view",
    "category": "method",
    "text": "function update_view(win::Window; force::Bool = false)\n\nUpdate the view of window win by copying the contents from the buffer. If the view does not need to be updated (see view_needs_update), then nothing is done. If the keyword force is true, then the copy will always happen.\n\nReturn\n\nIt returns true if the view has been updated and false otherwise.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.validate_str-Union{Tuple{T}, Tuple{AbstractString,T}} where T",
    "page": "Library",
    "title": "TextUserInterfaces.validate_str",
    "category": "method",
    "text": "function validate_str(str::AbstractString, v)\n\nValidate the string str using the validator v. v is an element of the type that will be used to validate or a regex.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces.wpc-Tuple{}",
    "page": "Library",
    "title": "TextUserInterfaces.wpc",
    "category": "method",
    "text": "function wpc(...)\n\nHelper function to create anchors. In this case, the anchor can be passed by keywords and a tuple containing the object and its anchor.\n\n\n\n\n\n"
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
    "location": "lib/library/#TextUserInterfaces._check_horizontal_anchor-Tuple{Nothing}",
    "page": "Library",
    "title": "TextUserInterfaces._check_horizontal_anchor",
    "category": "method",
    "text": "function _check_horizontal_anchor(anchor::Anchor)\n\nCheck if the side parameter of anchor is valid for horizontal positioning. If anchor is nothing, then true is always returned.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._check_vertical_anchor-Tuple{Nothing}",
    "page": "Library",
    "title": "TextUserInterfaces._check_vertical_anchor",
    "category": "method",
    "text": "_check_vertical_anchor(anchor::Nothing)\nfunction _check_vertical_anchor(anchor::Anchor)\n\nCheck if the side parameter of anchor is valid for vertical positioning. If anchor is nothing, then true is always returned.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._deselect_radio_button-Tuple{WidgetRadioButton}",
    "page": "Library",
    "title": "TextUserInterfaces._deselect_radio_button",
    "category": "method",
    "text": "function _select_radio_button(rb::WidgetRadioButton)\n\nDeselect the radio button rb in its group name.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._destroy_widget-Tuple{Any}",
    "page": "Library",
    "title": "TextUserInterfaces._destroy_widget",
    "category": "method",
    "text": "function _destroy_widget(widget; refresh::Bool = true)\n\nPrivate function that destroys a widget. This can be used if a new widget needs to reimplement the destroy function.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_anchor-Tuple{TextUserInterfaces.Anchor,Union{Widget, Window}}",
    "page": "Library",
    "title": "TextUserInterfaces._get_anchor",
    "category": "method",
    "text": "function _get_anchor(anchor::Anchor)\n\nReturn the line or column related to the anchor anchor.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_window_cur_pos-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "Library",
    "title": "TextUserInterfaces._get_window_cur_pos",
    "category": "method",
    "text": "function _get_window_cur_pos(win::Ptr{WINDOW})\n\nGet the cursor position of the window win and return it on a tuple (cur_y,cur_x).  If the window is not initialized, then this function returns (-1,-1).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._get_window_dims-Tuple{Ptr{TextUserInterfaces.NCurses.WINDOW}}",
    "page": "Library",
    "title": "TextUserInterfaces._get_window_dims",
    "category": "method",
    "text": "function _get_window_dims(win::Ptr{WINDOW})\n\nGet the dimensions of the window win and return it on a tuple (dim_y,dim_x). If the window is not initialized, then this function returns (-1,-1).\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._next_widget-Tuple{WidgetContainer}",
    "page": "Library",
    "title": "TextUserInterfaces._next_widget",
    "category": "method",
    "text": "function _next_widget(container::WidgetContainer)\n\nMove the focus of container container to the next widget.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._process_horizontal_info!-Tuple{TextUserInterfaces.WidgetPositioningConfiguration}",
    "page": "Library",
    "title": "TextUserInterfaces._process_horizontal_info!",
    "category": "method",
    "text": "function _process_horizontal_info!(posconf::WidgetPositioningConfiguration)\n\nProcess the horizontal positioning information in posconf and write the variable horizontal of the same structure. The possible horizontal positioning information are:\n\n:aleft_aright: Left and right anchors were specified.\n:aleft_height: Left anchor and height were specified.\n:aright_height: Right anchor and height were specified.\n:acenter_height: Center anchor and height were specified.\n:right_height: Right and height were specified.\n:unknown: Insufficient information to compute the horizontal positioning.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._process_vertical_info!-Tuple{TextUserInterfaces.WidgetPositioningConfiguration}",
    "page": "Library",
    "title": "TextUserInterfaces._process_vertical_info!",
    "category": "method",
    "text": "function _process_vertical_info!(posconf::WidgetPositioningConfiguration)\n\nProcess the vertical positioning information in posconf and write the variable vertical of the same structure. The possible vertical positioning information are:\n\n:abottom_atop: Bottom and top anchors were specified.\n:abottom_height: Bottom anchor and height were specified.\n:atop_height: Top anchor and height were specified.\n:amiddle_height: Middle anchor and height were specified.\n:top_height: Top and height were specified.\n:unknown: Insufficient information to compute the vertical positioning.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._select_radio_button-Tuple{WidgetRadioButton}",
    "page": "Library",
    "title": "TextUserInterfaces._select_radio_button",
    "category": "method",
    "text": "function _select_radio_button(rb::WidgetRadioButton)\n\nSelect the radio button rb in its group name.\n\n\n\n\n\n"
},

{
    "location": "lib/library/#TextUserInterfaces._str-Tuple{TextUserInterfaces.WidgetPositioningConfiguration}",
    "page": "Library",
    "title": "TextUserInterfaces._str",
    "category": "method",
    "text": "function _str(wpc::WidgetPositioningConfiguration)\n\nConvert the information in wpc to a string for debugging purposes.\n\n\n\n\n\n"
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
    "location": "lib/library/#Library-1",
    "page": "Library",
    "title": "Library",
    "category": "section",
    "text": "Documentation for TextUserInterfaces.jl.Modules = [TextUserInterfaces]"
},

]}
