# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Precompile statements.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Focus manager
# ==============================================================================

precompile(process_focus, (Keystroke,))
precompile(next_window, ())
precompile(previous_window, ())
precompile(request_focus, (Window,))

# Inputs
# ==============================================================================

precompile(jlgetch, (Nothing,))
precompile(jlgetch, (Ptr{WINDOW},))

# Logger
# ==============================================================================

precompile(log_message, (LogLevels, String, String))

# Objects
# ==============================================================================

precompile(compute_object_positioning, (ObjectPositioningConfiguration, Window))
precompile(compute_object_positioning, (ObjectPositioningConfiguration, WidgetContainer))
precompile(Core.kwfunc(object_positioning_conf),
           (NamedTuple{(:anchor_bottom, :anchor_left, :anchor_right,
                        :anchor_top, :anchor_center, :anchor_middle, :top,
                        :left, :height, :width),
                       Tuple{Anchor, Anchor, Anchor, Anchor, Anchor, Anchor,
                             Int, Int, Int, Int}},
            typeof(object_positioning_conf)))
precompile(_get_anchor, (Anchor, Window))
precompile(_get_anchor, (Anchor, WidgetContainer))
precompile(_process_vertical_info!, (ObjectPositioningConfiguration,))
precompile(_process_horizontal_info!, (ObjectPositioningConfiguration,))
precompile(_str, (ObjectPositioningConfiguration,))

# Widgets
# ==============================================================================

# Ansi labels
# ------------------------------------------------------------------------------

precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:alignment, :color, :text, :anchor_bottom, :anchor_left,
                        :anchor_right, :anchor_top, :anchor_center,
                        :anchor_middle, :top, :left, :height, :width),
                       Tuple{Symbol, Int, String, Anchor, Anchor, Anchor,
                             Anchor, Anchor, Anchor, Int, Int, Int, Int}},
            typeof(create_widget), Val{:ansi_label}, WidgetContainer))
precompile(Core.kwfunc(change_text),
           (NamedTuple{(:alignment, :color),
                       Tuple{Symbol, Int}},
            typeof(change_text), WidgetANSILabel, String))
precompile(redraw, (WidgetANSILabel,))

# Button
# ------------------------------------------------------------------------------

precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:label, :color, :color_highlight, :style, :_derive,
                        :anchor_bottom, :anchor_left, :anchor_right,
                        :anchor_top, :anchor_center, :anchor_middle, :top,
                        :left, :height, :width),
                       Tuple{String, Int, Int, Symbol, Bool, Anchor, Anchor,
                             Anchor, Anchor, Anchor, Anchor, Int, Int, Int,
                             Int}},
            typeof(create_widget), Val{:button}, WidgetContainer))
precompile(change_label, (WidgetButton, String))
precompile(redraw, (WidgetButton,))
precompile(_draw_button, (WidgetButton, Bool))

# Container
# ------------------------------------------------------------------------------

precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:opc, :border, :border_color, :composed, :title,
                        :title_alignment, :title_color, :anchor_bottom,
                        :anchor_left, :anchor_right, :anchor_top,
                        :anchor_center, :anchor_middle, :top, :left, :height,
                        :width),
                       Tuple{Nothing, Bool, Int, Bool, String, Symbol, Int,
                             Anchor, Anchor, Anchor, Anchor, Anchor, Anchor,
                             Int, Int, Int, Int}},
            typeof(create_widget), Val{:container}, Window))
precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:opc, :border, :border_color, :composed, :title,
                        :title_alignment, :title_color, :anchor_bottom,
                        :anchor_left, :anchor_right, :anchor_top,
                        :anchor_center, :anchor_middle, :top, :left, :height,
                        :width),
                       Tuple{Nothing, Bool, Int, Bool, String, Symbol, Int,
                             Anchor, Anchor, Anchor, Anchor, Anchor, Anchor,
                             Int, Int, Int, Int}},
            typeof(create_widget), Val{:container}, WidgetContainer))
precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:opc, :border, :border_color, :composed, :title,
                        :title_alignment, :title_color, :anchor_bottom,
                        :anchor_left, :anchor_right, :anchor_top,
                        :anchor_center, :anchor_middle, :top, :left, :height,
                        :width),
                       Tuple{ObjectPositioningConfiguration, Bool, Int, Bool,
                             String, Symbol, Int, Anchor, Anchor, Anchor,
                             Anchor, Anchor, Anchor, Int, Int, Int, Int}},
            typeof(create_widget), Val{:container}, Window))
precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:opc, :border, :border_color, :composed, :title,
                        :title_alignment, :title_color, :anchor_bottom,
                        :anchor_left, :anchor_right, :anchor_top,
                        :anchor_center, :anchor_middle, :top, :left, :height,
                        :width),
                       Tuple{ObjectPositioningConfiguration, Bool, Int, Bool,
                             String, Symbol, Int, Anchor, Anchor, Anchor,
                             Anchor, Anchor, Anchor, Int, Int, Int, Int}},
            typeof(create_widget), Val{:container}, WidgetContainer))
precompile(redraw, (WidgetContainer,))

# Combo box
# ------------------------------------------------------------------------------

precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:data, :color, :color_highlight, :list_box_border,
                        :list_box_color, :list_box_color_highlight, :style,
                        :anchor_bottom, :anchor_left, :anchor_right,
                        :anchor_top, :anchor_center, :anchor_middle, :top,
                        :left, :height, :width),
                       Tuple{Vector{String}, Int, Int, Bool, Int, Int, Symbol,
                             Anchor, Anchor, Anchor, Anchor, Anchor, Anchor,
                             Int, Int, Int, Int}},
           typeof(create_widget), Val{:combo_box}, WidgetContainer))
precompile(redraw, (WidgetComboBox,))
precompile(_draw_combo_box, (WidgetComboBox,))
precompile(_handle_input, (WidgetComboBox, Keystroke))

# Form
# ------------------------------------------------------------------------------

precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:labels, :borders, :color_valid, :color_invalid,
                        :field_size, :validator, :anchor_bottom, :anchor_left,
                        :anchor_right, :anchor_top, :anchor_center,
                        :anchor_middle, :top, :left, :height, :width),
                       Tuple{Vector{String}, Bool, Int, Int, Int, Nothing,
                             Anchor, Anchor, Anchor, Anchor, Anchor, Anchor,
                             Int, Int, Int, Int}},
            typeof(create_widget), Val{:form}, WidgetContainer))
precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:labels, :borders, :color_valid, :color_invalid,
                        :field_size, :validator, :anchor_bottom, :anchor_left,
                        :anchor_right, :anchor_top, :anchor_center,
                        :anchor_middle, :top, :left, :height, :width),
                       Tuple{Vector{String}, Bool, Int, Int, Int,
                             Vector{DataType}, Anchor, Anchor, Anchor, Anchor,
                             Anchor, Anchor, Int, Int, Int, Int}},
            typeof(create_widget), Val{:form}, WidgetContainer))
precompile(redraw, (WidgetForm,))

# Input field
# ------------------------------------------------------------------------------

precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:border, :color_valid, :color_invalid, :max_data_size,
                        :validator, :parsed_data_sample, :anchor_bottom,
                        :anchor_left, :anchor_right, :anchor_top,
                        :anchor_center, :anchor_middle, :top, :left, :height,
                        :width),
                       Tuple{Bool, Int, Int, Int, Nothing, Nothing, Anchor,
                             Anchor, Anchor, Anchor, Anchor, Anchor, Int, Int,
                             Int, Int}},
            typeof(create_widget), Val{:input_field}, WidgetContainer))
precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:border, :color_valid, :color_invalid, :max_data_size,
                        :validator, :parsed_data_sample, :anchor_bottom,
                        :anchor_left, :anchor_right, :anchor_top,
                        :anchor_center, :anchor_middle, :top, :left, :height,
                        :width),
                       Tuple{Bool, Int, Int, Int, DataType, Int, Anchor,
                             Anchor, Anchor, Anchor, Anchor, Anchor, Int, Int,
                             Int, Int}},
            typeof(create_widget), Val{:input_field}, WidgetContainer))
precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:border, :color_valid, :color_invalid, :max_data_size,
                        :validator, :parsed_data_sample, :anchor_bottom,
                        :anchor_left, :anchor_right, :anchor_top,
                        :anchor_center, :anchor_middle, :top, :left, :height,
                        :width),
                       Tuple{Bool, Int, Int, Int, DataType, Float32, Anchor,
                             Anchor, Anchor, Anchor, Anchor, Anchor, Int, Int,
                             Int, Int}},
            typeof(create_widget), Val{:input_field}, WidgetContainer))
precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:border, :color_valid, :color_invalid, :max_data_size,
                        :validator, :parsed_data_sample, :anchor_bottom,
                        :anchor_left, :anchor_right, :anchor_top,
                        :anchor_center, :anchor_middle, :top, :left, :height,
                        :width),
                       Tuple{Bool, Int, Int, Int, DataType, Float64, Anchor,
                             Anchor, Anchor, Anchor, Anchor, Anchor, Int, Int,
                             Int, Int}},
            typeof(create_widget), Val{:input_field}, WidgetContainer))
precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:border, :color_valid, :color_invalid, :max_data_size,
                        :validator, :parsed_data_sample, :anchor_bottom,
                        :anchor_left, :anchor_right, :anchor_top,
                        :anchor_center, :anchor_middle, :top, :left, :height,
                        :width),
                       Tuple{Bool, Int, Int, Int, DataType, String, Anchor,
                             Anchor, Anchor, Anchor, Anchor, Anchor, Int, Int,
                             Int, Int}},
            typeof(create_widget), Val{:input_field}, WidgetContainer))
precompile(redraw, (WidgetInputField,))
precompile(_handle_input, (WidgetInputField, Keystroke))
precompile(_validator, (WidgetInputField,))

# Label
# ------------------------------------------------------------------------------

precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:alignment, :color, :fill_color, :text, :anchor_bottom,
                        :anchor_left, :anchor_right, :anchor_top,
                        :anchor_center, :anchor_middle, :top, :left, :height,
                        :width),
                       Tuple{Symbol, Int, Bool, String, Anchor, Anchor, Anchor,
                             Anchor, Anchor, Anchor, Int, Int, Int, Int}},
            typeof(create_widget), Val{:label}, WidgetContainer))
precompile(Core.kwfunc(change_text),
           (NamedTuple{(:alignment, :color),
                       Tuple{Symbol, Int}},
            typeof(change_text), WidgetLabel, String))
precompile(redraw, (WidgetLabel,))

# List box
# ------------------------------------------------------------------------------

precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:data, :color, :color_highlight, :color_selected,
                        :multiple_selection, :numlines, :icon_not_selected,
                        :icon_selected, :retain_focus, :selectable, :show_icon,
                        :_derive, :anchor_bottom, :anchor_left, :anchor_right,
                        :anchor_top, :anchor_center, :anchor_middle, :top,
                        :left, :height, :width),
                       Tuple{Vector{String}, Int, Int, Int, Bool, Int, String,
                             String, Bool, Bool, Bool, Bool, Anchor, Anchor,
                             Anchor, Anchor, Anchor, Anchor, Int, Int, Int,
                             Int}},
            typeof(create_widget), Val{:list_box}, WidgetContainer))
precompile(redraw, (WidgetListBox,))
precompile(_handle_input, (WidgetListBox, Keystroke))

# Progress bar
# ------------------------------------------------------------------------------

precompile(Core.kwfunc(create_widget),
           (NamedTuple{(:border, :color, :color_highlight, :style, :value,
                        :anchor_bottom, :anchor_left, :anchor_right,
                        :anchor_top, :anchor_center, :anchor_middle, :top,
                        :left, :height, :width),
                       Tuple{Bool, Int, Int, Symbol, Int, Anchor, Anchor,
                             Anchor, Anchor, Anchor, Anchor, Int, Int, Int,
                             Int}},
            typeof(create_widget), Val{:label}, WidgetContainer))
precompile(Core.kwfunc(change_label), (NamedTuple{(:color,), Tuple{Int}},
                                       WidgetProgressBar))
precompile(redraw, (WidgetProgressBar,))
precompile(_draw_progress_bar_simple, (WidgetProgressBar,))
precompile(_draw_progress_bar_complete, (WidgetProgressBar,))

# Windows
# ==============================================================================

precompile(Core.kwfunc(create_window),
           (NamedTuple{(:bcols, :blines, :border, :border_color, :focusable,
                        :title, :title_color, :anchor_bottom, :anchor_left,
                        :anchor_right, :anchor_top, :anchor_center,
                        :anchor_middle, :top, :left, :height, :width),
                       Tuple{Int, Int, Bool, Int, Bool, String, Int, Anchor,
                             Anchor, Anchor, Anchor, Anchor, Anchor, Int, Int,
                             Int, Int}},
            typeof(create_window), String))

precompile(Core.kwfunc(reposition!),
           (NamedTuple{(:force,), Tuple{Bool}},
            Window, ObjectPositioningConfiguration))
