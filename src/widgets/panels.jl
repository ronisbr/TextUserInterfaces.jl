## Description #############################################################################
#
# Create a set of panels.
#
############################################################################################

export create_panels!
export get_panel_container

############################################################################################
#                                        Structure                                         #
############################################################################################

"""
    struct Panels <: ComposedWidget

Store a grid of panel containers with optional borders and titles, allowing the organization
of widgets in a matrix layout.

# Functions

    get_panel_container(panels::Panels, line::Int, column::Int) -> WidgetContainer

Return the container of the panel located at the given `line` and `column` in the set of
`panels`.

    get_container(cw::Panels) -> WidgetContainer

Return the main container of the panels widget `cw`.

# Signals

This widget does not have signals.
"""
@kwdef struct Panels <: ComposedWidget
    container::WidgetContainer
    theme::Theme

    # == Variables Related To the Panels ===================================================

    panel_containers::Matrix{WidgetContainer}

    borders::Bool = true
    column_widths::Vector{Int} = Int[]
    line_heights::Vector{Int} = Int[]
    title_alignment::Symbol = :c
    titles::Union{Nothing, Matrix{String}} = nothing
end

############################################################################################
#                                        Widget API                                        #
############################################################################################

# - `borders::Bool`: If `true`, borders will be drawn around the panels.
#  (**Default**: true)
# - `columns::Int`: Number of columns in the set of panels.
#  (**Default**: 1)
# - `heights::Union{Nothing, Vector{Int}}`: Vector with the heights of each line in the set of
#     panels. It must have `lines` number of elements. Each element describe the line height
#     in terms in terms of the percentage of the `parent` height. If it is `nothing`, the
#     algorithm will use the same height for each line.
#     (**Default**: `nothing`)
# - `lines::Int`: Number of lines in the set of panels.
#     (**Default**: 1)
# - `theme::Theme`: Default theme for the panels.
#     (**Default**: tui.default_theme)
# - `titles::Union{Nothing, Matrix{String}}`: Titles of each panel cell passed as a matrix of
#     `String`s with dimensions `lines` × `columns`. If it is `nothing`, the cells will have
#     no title. Notice that we draw the tiltes only if `borders` is `true`.
#     (**Default**: nothing)
# - `title_alignment::Symbol`: Title alignment, it can be `:l` for left, `:c` for center, or
#     `:r` for right.
#     (**Default**: :c)
# - `widths::Vector{Int}`: Vector with the widths of each line in the set of panels. It must
#     have `columns` number of elements. Each element describe the column width in terms in
#     terms of the percentage of the `parent` width. If it is `nothing`, the algorithm will
#     use the same height for each line.
#    (**Default**: `nothing`)
function create_widget(
    ::Val{:panels},
    layout::ObjectLayout;
    borders::Bool = true,
    columns::Int = 1,
    heights::Union{Nothing, Vector{Int}} = nothing,
    lines::Int = 1,
    theme::Theme = Theme(),
    title_alignment::Symbol = :c,
    titles::Union{Nothing, Matrix{String}} = nothing,
    widths::Union{Nothing, Vector{Int}} = nothing
)
    # Check the inputs.
    columns <= 0 &&
        throw(ArgumentError("`columns` must be greater than 0."))
    lines <= 0 &&
        throw(ArgumentError("`lines` must be greater than 0."))
    !isnothing(heights) && (length(heights) != lines) &&
        throw(ArgumentError("The number of elements in `heights` must be equal to `lines`."))
    !isnothing(widths) && (length(widths) != columns) &&
        throw(ArgumentError("The number of elements in `widths` must be equal to `columns`."))
    !isnothing(titles) && (size(titles) != (lines, columns)) &&
        throw(ArgumentError("The dimension of the matrix `titles` must be `lines` × `columns`."))

    # If the user did not provide the line heights, use the same height for all lines.
    line_heights = if isnothing(heights)
        h = fill(div(100, lines), lines)

        @views if lines > 1
            h[end] = 100 - sum(h[1:end - 1])
        end

        h
    else
        heights
    end

    # If the user did not provide the column widths, use the same width for all columns.
    column_widths = if isnothing(widths)
        w = fill(div(100, columns), columns)

        @views if columns > 1
            w[end] = 100 - sum(w[1:end - 1])
        end

        w
    else
        widths
    end

    container = create_widget(Val(:container), layout)
    panel_containers = Matrix{WidgetContainer}(undef, lines, columns)

    panels = Panels(
        container,
        theme,
        panel_containers,
        borders,
        column_widths,
        line_heights,
        title_alignment,
        titles
    )

    return panels
end

############################################################################################
#                                      Container API                                       #
############################################################################################

# We need a custom function when adding panels to a container because we first need the main
# container added to a parent before creating the other components.
function add_widget!(parent::WidgetContainer, panels::Panels)
    @unpack container, panel_containers = panels
    @unpack borders, column_widths, line_heights, theme, titles, title_alignment = panels

    add_widget!(parent, container)

    # Auxiliary variables.
    pc = panel_containers
    ptop_anchor  = Anchor(:parent, :top)
    pleft_anchor = Anchor(:parent, :left)

    # Local variables to store the raw buffers used for borders.
    local last_rw, first_rw_on_last_line, first_rw_on_current_line

    lines, columns = size(pc)

    for i in 1:lines
        top    = i == 1
        bottom = i == lines

        for j in 1:columns
            local panel_container_layout

            left  = j == 1
            right = j == columns

            if borders
                top_anchor  = top  ? ptop_anchor  : Anchor(first_rw_on_last_line, :bottom)
                left_anchor = left ? pleft_anchor : Anchor(last_rw, :right)

                # Create the `WidgetRawBuffer` that will contain the border. Its draw
                # function depends on where the cell is located.
                function rb_draw!(rb::WidgetRawBuffer, buffer::Ptr{WINDOW})
                    _panels__draw_cell_border!(rb, buffer, bottom, left, right, top)
                    !isnothing(titles) && _panels__draw_cell_title!(
                        rb,
                        buffer,
                        titles[i, j];
                        alignment  = title_alignment,
                        right_cell = right
                    )
                    return nothing
                end

                rb = create_widget(
                    Val(:raw_buffer),
                    ObjectLayout(;
                        top_anchor  = top_anchor,
                        left_anchor = left_anchor,
                        width       = "$(column_widths[j])%",
                        height      = "$(line_heights[i])%"
                    );
                    draw! = rb_draw!,
                    theme = theme
                )
                add_widget!(container, rb)

                last_rw = rb

                if left
                    first_rw_on_current_line = rb
                end

                if right
                    first_rw_on_last_line = first_rw_on_current_line
                end

                panel_container_layout = ObjectLayout(;
                    bottom_anchor = Anchor(rb, :bottom, bottom ? -1 : 0),
                    left_anchor   = Anchor(rb, :left,   1),
                    right_anchor  = Anchor(rb, :right,  right ? -1 : 0),
                    top_anchor    = Anchor(rb, :top,   1)
                )
            else
                top_anchor  = top  ? ptop_anchor  : Anchor(panel_containers[i - 1, j], :bottom)
                left_anchor = left ? pleft_anchor : Anchor(panel_containers[i, j - 1], :right)

                panel_container_layout = ObjectLayout(;
                    top_anchor  = top_anchor,
                    left_anchor = left_anchor,
                    width       = "$(column_widths[j])%",
                    height      = "$(line_heights[i])%"
                )
            end

            pc[i, j] = create_widget(
                Val(:container),
                panel_container_layout,
                theme = theme
            )

            add_widget!(container, pc[i, j])
        end
    end

    return nothing
end

function remove_widget!(parent::WidgetContainer, panels::Panels)
    @unpack container, panel_containers = panels

    for pc in panel_containers
        remove_widget!(container, pc)
    end

    remove_widget!(parent, container)

    return nothing
end

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    get_panel_container(panels::Panels, line::Int, column::Int) -> WidgetContainer

Return the container of the panel located at the given `line` and `column` in the set of
`panels`.
"""
function get_panel_container(panels::Panels, line::Int, column::Int)
    return panels.panel_containers[line, column]
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _panels__draw_cell_border!(rb::WidgetRawBuffer, buffer::Ptr{WINDOW}, bottom::Bool, left::Bool, right::Bool, top::Bool) -> Nothing

Draw function for the panel cell raw buffer. It renders to the `buffer` of the widget `rb`
the cell. The cell position is specified by the arguments `bottom`, `left`, `right`, and
`top`.
"""
function _panels__draw_cell_border!(
    rb::WidgetRawBuffer,
    buffer::Ptr{WINDOW},
    bottom::Bool,
    left::Bool,
    right::Bool,
    top::Bool
)
    @unpack theme, height, width = rb

    border_style = get_style(theme, :border)

    @nstyle border_style buffer begin
        # == Top Line ======================================================================

        if top
            NCurses.wprintw(buffer, left ? "┌" : "┬")
        elseif left
            NCurses.wprintw(buffer, "├")
        else
            NCurses.wprintw(buffer, "┼")
        end

        hline = repeat("─", width - 2)
        NCurses.wprintw(buffer, hline)

        if right
            NCurses.wprintw(buffer, top ? "┐" : "┤")
        else
            NCurses.wprintw(buffer, "─")
        end

        # == Intermediate Borders ==========================================================

        for i in 2:(height - 1)
            NCurses.mvwprintw(buffer, i - 1, 0, "│")
            right && NCurses.mvwprintw(buffer, i - 1, width - 1, "│")
        end

        # == Bottom Line ===================================================================

        if !bottom
            NCurses.mvwprintw(buffer, height - 1, 0, "│")
            right && NCurses.mvwprintw(buffer, height - 1, width - 1, "│")
        else
            # Bottom line.
            NCurses.mvwprintw(buffer, height - 1, 0, left ? "└" : "┴")

            hline = repeat("─", width - 1)
            NCurses.wprintw(buffer, hline)

            right && NCurses.wprintw(buffer, "┘")
        end
    end

    return nothing
end

"""
    _panels__cell_draw_title!(rb::WidgetRawBuffer, buffer::Ptr{WINDOW}, title::String; kwargs...) -> Nothing
    
Draw the `title` in the panel cell `buffer` of the widget `rb`.

# Keywords

- `alignment::Symbol`: Title alignment, it can be `:l` for left, `:c` for center, or `:r`
    for right.
    (**Default**: `:c`)
- `right_cell::Bool`: Indicate that this is a cell positioned to the right so that we can
    take into account the right border.
    (**Default** = `false`)
"""
function _panels__draw_cell_title!(
    rb::WidgetRawBuffer,
    buffer::Ptr{WINDOW},
    title::String;
    alignment::Symbol = :c,
    right_cell::Bool = false
)
    @unpack theme, height, width = rb

    isempty(title) && return nothing

    tw = textwidth(title)

    if alignment == :l
        @nstyle get_style(theme, :title) buffer begin
            NCurses.mvwprintw(buffer, 0, 1, title)
        end

    elseif alignment == :c
        lpad = max(div(width - tw - right_cell, 2), 0)

        @nstyle get_style(theme, :title) buffer begin
            NCurses.mvwprintw(buffer, 0, lpad, title)
        end

    elseif alignment == :r
        lpad = max(width - tw, 0)

        @nstyle get_style(theme, :title) buffer begin
            NCurses.mvwprintw(buffer, 0, lpad - 1 - right_cell, title)
        end
    end

    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper panels