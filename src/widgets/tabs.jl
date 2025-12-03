## Description #############################################################################
#
# Create a set of tabs with containers.
#
############################################################################################

export change_tab!, create_tabs!, next_tab!, previous_tab!

############################################################################################
#                                        Structure                                         #
############################################################################################

mutable struct Tabs <: ComposedWidget
    container::WidgetContainer
    tabs::Vector{WidgetContainer}
    active_tab::Int
    border::Bool
    num_tabs::Int
    tab_names::Vector{String}
end

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    create_tabs!(parent::WidgetContainer; kwargs...)

Create a set of tabs in `parent`.

# Keywords

- `border::Bool`: If `true`, the tabs will be drawn with borders.
    (**Default**: `false`)
- `num_tabs::Int`: Number of tabs.
    (**Default**: `1`)
- `tab_names::Union{Nothing, Vector{String}}`: Names of the tabs. If it is `nothing`, we
    will use "Tabs #i" for the *i*th tab.
    (**Default**: `nothing`)
- `theme::Theme`: Theme for the tabs.
    (**Default**: `tui.default_theme`)
"""
function create_tabs!(
    parent::WidgetContainer;
    border::Bool = false,
    num_tabs::Int = 1,
    tab_names::Union{Nothing, Vector{String}} = nothing,
    theme::Theme = Theme()
)
    # == Check the Inputs ==================================================================

    num_tabs < 1 && error("The number of tabs must be higher than 0.")

    (!isnothing(tab_names) && length(tab_names) != num_tabs) &&
        error("The number of tab names must be equal to the number of tabs.")

    # == Pre-Allocate the Variables ========================================================

    # Allocate the vectors.
    tabs = Vector{WidgetContainer}(undef, num_tabs)

    # == Create the Base Container =========================================================

    # Create the main container.
    container = create_widget(Val(:container), ObjectLayout())
    add_widget!(parent, container)

    # Create the raw buffer widget that will contain the tab bar and the border if the user
    # wants.
    #
    # NOTE: We only create the widget here with a dummy drawing function because we need to
    # create the `tabs` structure first to assign the real drawing function.
    rb = create_widget(
        Val(:raw_buffer),
        ObjectLayout(;
            bottom_anchor = Anchor(:parent, :bottom),
            left_anchor   = Anchor(:parent, :left),
            right_anchor  = Anchor(:parent, :right),
            top_anchor    = Anchor(:parent, :top)
        );
        theme = theme
    )
    add_widget!(container, rb)

    # == Create the Tabs ===================================================================

    for i in eachindex(tabs)
        tabs[i] = create_widget(
            Val(:container),
            ObjectLayout(
                bottom_anchor = Anchor(:parent, :bottom, border ? -1 : 0),
                left_anchor   = Anchor(:parent, :left,   border ?  1 : 0),
                right_anchor  = Anchor(:parent, :right,  border ? -1 : 0),
                top_anchor    = Anchor(:parent, :top,    border ?  3 : 1),
            );
        )
        add_widget!(container, tabs[i])
        hide!(tabs[i])
    end

    unhide!(tabs[1])

    tabs = Tabs(
        container,
        tabs,
        1,
        border,
        num_tabs,
        isnothing(tab_names) ? ["Tab #$i" for i in 1:num_tabs] : tab_names
    )

    # Now we can create the real drawing function for the raw buffer.
    rb.draw! = (rb::WidgetRawBuffer, buffer::Ptr{WINDOW}) -> begin
        _tabs__draw_border_and_tabline!(rb, buffer, tabs)
    end

    return tabs
end

"""
    change_tab!(tabs::Tabs, tab_number::Int) -> Nothing

Change the active tab in `tabs` to `tab_number`. If `tab_number` is invalid, this function
does nothing.
"""
function change_tab!(tabs::Tabs, tab_number::Int)
    ((tab_number <= 0) || (tab_number > tabs.num_tabs)) && return nothing

    hide!(tabs.tabs[tabs.active_tab])
    unhide!(tabs.tabs[tab_number])

    move_focus_to_widget!(tabs.container, tabs.tabs[tab_number])

    tabs.active_tab = tab_number

    return nothing
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

    w          = rb.width
    active_tab = tabs.active_tab
    border     = tabs.border
    num_tabs   = tabs.num_tabs
    tab_names  = tabs.tab_names

    # == Draw the Border ===================================================================

    if border
        @nstyle get_style(rb.theme, :border) buffer begin
            # Create a full border.
            draw_border!(buffer)

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

        if border
            NCurses.waddch(buffer, ' ')
        else
            NCurses.waddch(buffer, '|')
            NCurses.waddch(buffer, ' ')
        end

        @nstyle c buffer begin
            NCurses.wprintw(buffer, (isnothing(tab_names) ? "Tab #$i" : tab_names[i]))
        end

        if border
            @nstyle get_style(rb.theme, :border) buffer begin
                NCurses.waddch(buffer, ' ')
                NCurses.waddch(buffer, NCurses.ACS_(:VLINE))
                curx = Int64(NCurses.getcurx(buffer)) - 1
                NCurses.mvwaddch(buffer, 0, curx, NCurses.ACS_(:TTEE))
                NCurses.mvwaddch(buffer, 2, curx, NCurses.ACS_(:BTEE))
                NCurses.wmove(buffer, 1, curx + 1)
            end
        else
            NCurses.waddch(buffer, ' ')
        end
    end

    border || NCurses.waddch(buffer, '|')

    return nothing
end
