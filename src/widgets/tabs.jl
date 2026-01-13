## Description #############################################################################
#
# Create a set of tabs with containers.
#
############################################################################################

export change_tab!, get_tab_container, next_tab!, previous_tab!

############################################################################################
#                                        Structure                                         #
############################################################################################

"""
    struct Tabs <: ComposedWidget

Store a tabbed container widget that allows organizing content into multiple switchable
tabs.

# Functions

    create_widget(Val(:tabs), layout::ObjectLayout; kwargs...)

Create a tabs widget.

## Keywords

- `border::Bool`: Whether to draw a border around the tabs.
    (**Default**: `false`)
- `border_style::Symbol`: Border style.
    (**Default**: `:default`)
- `num_tabs::Int`: Number of tabs.
    (**Default**: `1`)
- `tab_names::Union{Nothing, Vector{String}}`: Names of each tab. If `nothing`, the names
    will be `"Tab #1"`, `"Tab #2"`, etc.
    (**Default**: `nothing`)
- `theme::Theme`: Theme for the widget.
    (**Default**: `Theme()`)

---

    change_tab!(tabs::Tabs, tab_number::Int) -> Nothing

Change the active tab in `tabs` to `tab_number`. If `tab_number` is invalid, this function
does nothing.

    get_tab_container(tabs::Tabs, tab_number::Int) -> WidgetContainer

Get the container associated with tab ID `tab_number` in `tabs`.

    next_tab!(tabs::Tabs) -> Nothing

Activate the next tab in `tabs`.

    previous_tab!(tabs::Tabs) -> Nothing

Activate the previous tab in `tabs`.

    get_container(cw::Tabs) -> WidgetContainer

Return the main container of the tabs widget `cw`.

# Signals

This widget does not have signals.
"""
@kwdef mutable struct Tabs <: ComposedWidget
    container::WidgetContainer
    theme::Theme

    # == Variables Related To the Tabs =====================================================

    tab_containers::Vector{WidgetContainer} = WidgetContainer[]
    active_tab::Int = 1
    border::Bool = false
    border_style::Symbol = :default
    num_tabs::Int = 1
    tab_names::Vector{String} = String[]
end

############################################################################################
#                                        Widget API                                        #
############################################################################################

function create_widget(
    ::Val{:tabs},
    layout::ObjectLayout;
    border::Bool = false,
    border_style::Symbol = :default,
    num_tabs::Int = 1,
    tab_names::Union{Nothing, Vector{String}} = nothing,
    theme::Theme = Theme()
)
    # == Check the Inputs ==================================================================

    num_tabs < 1 && error("The number of tabs must be higher than 0.")

    (!isnothing(tab_names) && length(tab_names) != num_tabs) &&
        error("The number of tab names must be equal to the number of tabs.")

    container = create_widget(Val(:container), layout)
    tab_names = isnothing(tab_names) ? ["Tab #$i" for i in 1:num_tabs] : tab_names

    tabs = Tabs(;
        container    = container,
        theme        = theme,
        border       = border,
        border_style = border_style,
        num_tabs     = num_tabs,
        tab_names    = tab_names
    )

    sizehint!(tabs.tab_containers, num_tabs)

    return tabs
end

############################################################################################
#                                      Container API                                       #
############################################################################################

# We need a custom function when adding tabs to a container because we first need the main
# container added to a parent before creating the other components.
function add_widget!(parent::WidgetContainer, tabs::Tabs)
    @unpack container, border, num_tabs, theme, tab_containers = tabs

    # == Create the Base Container =========================================================

    # First, we need to add the base container so that we have access to its size.
    add_widget!(parent, container)

    # Create the raw buffer widget that will contain the tab bar and the border if the user
    # wants.
    function rb_draw!(rb::WidgetRawBuffer, buffer::Ptr{WINDOW})
        return _tabs__draw_border_and_tabline!(rb, buffer, tabs)
    end

    rb = create_widget(
        Val(:raw_buffer),
        ObjectLayout(;
            bottom_anchor = Anchor(:parent, :bottom),
            left_anchor   = Anchor(:parent, :left),
            right_anchor  = Anchor(:parent, :right),
            top_anchor    = Anchor(:parent, :top)
        ),
        draw! = rb_draw!
    )
    add_widget!(container, rb)

    # == Create the Tabs ===================================================================

    tab_layout = ObjectLayout(;
        bottom_anchor = Anchor(:parent, :bottom, border ? -1 : 0),
        left_anchor   = Anchor(:parent, :left, border ? 1 : 0),
        right_anchor  = Anchor(:parent, :right, border ? -1 : 0),
        top_anchor    = Anchor(:parent, :top, border ? 3 : 1),
    )

    for _ in 1:num_tabs
        tab_i_container = create_widget(Val(:container), tab_layout)

        add_widget!(container, tab_i_container)
        hide!(tab_i_container)

        push!(tab_containers, tab_i_container)
    end

    unhide!(tab_containers[begin])

    return nothing
end

function remove_widget!(parent::WidgetContainer, tabs::Tabs)
    @unpack container, tab_containers = tabs

    for tc in tab_containers
        remove_widget!(container, tc)
    end

    remove_widget!(parent, container)

    return nothing
end

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    change_tab!(tabs::Tabs, tab_number::Int) -> Nothing

Change the active tab in `tabs` to `tab_number`. If `tab_number` is invalid, this function
does nothing.
"""
function change_tab!(tabs::Tabs, tab_number::Int)
    ((tab_number <= 0) || (tab_number > tabs.num_tabs)) && return nothing

    active_tab_container      = get_tab_container(tabs, tabs.active_tab)
    next_active_tab_container = get_tab_container(tabs, tab_number)

    hide!(active_tab_container)
    unhide!(next_active_tab_container)

    move_focus_to_widget!(tabs.container, next_active_tab_container)

    tabs.active_tab = tab_number

    return nothing
end

"""
    get_tab_container(tabs::Tabs, tab_number::Int) -> WidgetContainer

Get the container associated with tab ID `tab_number` in `tabs`.
"""
function get_tab_container(tabs::Tabs, tab_number::Int)
    ((tab_number <= 0) || (tab_number > tabs.num_tabs)) &&
        error("The active tab number is invalid.")

    return tabs.tab_containers[tab_number + begin - 1]
end

"""
    next_tab!(tabs::Tabs) -> Nothing

Activate the next tab in `tabs`.
"""
function next_tab!(tabs::Tabs)
    nt = mod(tabs.active_tab, tabs.num_tabs) + 1
    return change_tab!(tabs, nt)
end

"""
    previous_tab!(tabs::Tabs) -> Nothing

Activate the previous tab in `tabs`.
"""
function previous_tab!(tabs::Tabs)
    nt = tabs.active_tab == 1 ? tabs.num_tabs : tabs.active_tab - 1
    return change_tab!(tabs, nt)
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _tabs__draw_border_and_tabline!(rb::WidgetRawBuffer, buffer::Ptr{WINDOW}, tabs::Tabs)

Function to draw the border and tab line in the raw buffer `rb` considering the `tabs`.
"""
function _tabs__draw_border_and_tabline!(
    rb::WidgetRawBuffer,
    buffer::Ptr{WINDOW},
    tabs::Tabs
)
    # == Unpack ============================================================================

    @unpack active_tab, border, border_style, num_tabs, tab_names = tabs
    w = rb.width

    # == Draw the Border ===================================================================

    if border
        @nstyle get_style(rb.theme, :border) buffer begin
            # Create a full border.
            draw_border!(buffer, style = border_style)

            # Draw the line between the tab bar and the tabs.
            line = repeat("─", w - 2)
            NCurses.mvwprintw(buffer, 2, 0, "├")
            NCurses.mvwprintw(buffer, 2, 1, line)
            NCurses.mvwprintw(buffer, 2, w - 1, "┤")
        end
    end

    # == Draw the Tab Bar ==================================================================

    NCurses.wmove(buffer, border ? 1 : 0, border ? 1 : 0)

    for i in 1:num_tabs
        c = get_style(rb.theme, i == active_tab ? :selected : :default)

        !border && NCurses.wprintw(buffer, "|")
        NCurses.wprintw(buffer, " ")

        @nstyle c buffer begin
            NCurses.wprintw(buffer, tab_names[i])
        end

        NCurses.wprintw(buffer, " ")

        border && @nstyle get_style(rb.theme, :border) buffer begin
            NCurses.wprintw(buffer, "│")

            curx = Int64(NCurses.getcurx(buffer)) - 1

            NCurses.mvwprintw(buffer, 0, curx, "┬")
            NCurses.mvwprintw(buffer, 2, curx, "┴")

            NCurses.wmove(buffer, 1, curx + 1)
        end
    end

    !border && NCurses.wprintw(buffer, "|")

    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper tabs