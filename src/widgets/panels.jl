## Description #############################################################################
#
# Create a set of panels.
#
############################################################################################

export create_panels!

############################################################################################
#                                        Structure                                         #
############################################################################################

struct Panels
    panels::Matrix{WidgetContainer}
    containers::Matrix{WidgetContainer}
end

############################################################################################
#                                        Functions                                         #
############################################################################################

"""
    create_panels!(parent::WidgetContainer; kwargs...) -> Panels

Create a set of panels in the `parent` container. This functions returns an instance of the
structure `Panels`. The user can add widgets using the object `panels` inside the returned
object.

# Keywords

- `borders::Bool`: If `true`, borders will be drawn around the panels.
 (**Default**: true)
- `columns::Int`: Number of columns in the set of panels.
 (**Default**: 1)
- `heights::Union{Nothing, Vector{Int}}`: Vector with the heights of each line in the set of
    panels. It must have `lines` number of elements. Each element describe the line height
    in terms in terms of the percentage of the `parent` height. If it is `nothing`, the
    algorithm will use the same height for each line.
    (**Default**: `nothing`)
- `lines::Int`: Number of lines in the set of panels.
    (**Default**: 1)
- `theme::Theme`: Default theme for the panels.
    (**Default**: tui.default_theme)
- `titles::Union{Nothing, Matrix{String}}`: Titles of each panel cell passed as a matrix of
    `String`s with dimensions `lines` × `columns`. If it is `nothing`, the cells will have
    no title. Notice that we draw the tiltes only if `borders` is `true`.
    (**Default**: nothing)
- `title_alignment::Symbol`: Title alignment, it can be `:l` for left, `:c` for center, or
    `:r` for right.
    (**Default**: :c)
- `widths::Vector{Int}`: Vector with the widths of each line in the set of panels. It must
    have `columns` number of elements. Each element describe the column width in terms in
    terms of the percentage of the `parent` width. If it is `nothing`, the algorithm will
    use the same height for each line.
   (**Default**: `nothing`)
"""
function create_panels!(
    parent::WidgetContainer;
    borders::Bool = true,
    columns::Int = 1,
    heights::Union{Nothing, Vector{Int}} = nothing,
    lines::Int = 1,
    theme::Theme = tui.default_theme,
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
    !isnothing(widths) && (length(widths) != lines) &&
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

    # Allocate the matrices with the containers.
    #
    # `containers` are the top objects of the panels that will span through `parent` using
    # the information in `widths`  and `columns`. `panels` are the containers where the
    # user must add the desired widgets. It is used to make room for drawing the borders
    # using the `WidgetRawBuffer` if required.
    containers = Matrix{Union{Nothing, WidgetContainer}}(undef, lines, columns)
    panels     = Matrix{Union{Nothing, WidgetContainer}}(undef, lines, columns)

    @inbounds for i in 1:lines
        for j in 1:columns
            top_anchor  = i == 1 ? Anchor(:parent, :top)  : Anchor(containers[i - 1, j], :bottom)
            left_anchor = j == 1 ? Anchor(:parent, :left) : Anchor(containers[i, j - 1], :right)

            containers[i, j] = create_widget(
                Val(:container),
                ObjectLayout(
                    ;
                    top_anchor  = top_anchor,
                    left_anchor = left_anchor,
                    width       = "$(column_widths[j])%",
                    height      = "$(line_heights[i])%"
                );
                theme = theme
            )
            add_widget!(parent, containers[i, j])

            if borders
                # We the user want borders, we need to create the containers for the
                # `panels` with a margin so that we can fill it with the border using a
                # `WidgetRawBuffer`.
                panels[i, j] = create_widget(
                    Val(:container),
                    ObjectLayout(
                        ;
                        bottom_anchor = Anchor(:parent, :bottom, i != lines ? 0 : -1),
                        left_anchor   = Anchor(:parent, :left, 1),
                        right_anchor  = Anchor(:parent, :right, j  != columns ? 0 : -1),
                        top_anchor    = Anchor(:parent, :top, 1)
                    );
                    theme = theme
                )

                # Create the `WidgetRawBuffer` that will contain the border. Its draw
                # function depends on where the cell is located.
                bottom = i == lines
                left   = j == 1
                right  = j == columns
                top    = i == 1

                rb = create_widget(
                    Val(:raw_buffer),
                    ObjectLayout(
                        ;
                        bottom_anchor = Anchor(:parent, :bottom),
                        left_anchor = Anchor(:parent, :left),
                        right_anchor = Anchor(:parent, :right),
                        top_anchor = Anchor(:parent, :top)
                    );
                    draw! = (rb::WidgetRawBuffer, buffer::Ptr{WINDOW}) -> begin
                        _panel_cell_draw_border!(rb, buffer, bottom, left, right, top)
                        !isnothing(titles) && _panel_cell_draw_title!(
                            rb,
                            buffer,
                            titles[i, j];
                            alignment = title_alignment,
                            right_cell = right
                        )
                    end,
                    theme = theme
                )
                add_widget!(containers[i, j], rb)

            else
                # If the user do not want a border, create a panel that fills its entire
                # parent container.
                panels[i, j] = create_widget(
                    Val(:container),
                    ObjectLayout(
                        ;
                        bottom_anchor = Anchor(:parent, :bottom),
                        left_anchor   = Anchor(:parent, :left),
                        right_anchor  = Anchor(:parent, :right),
                        top_anchor    = Anchor(:parent, :top)
                    );
                    theme = theme
                )
            end

            add_widget!(containers[i, j], panels[i, j])
        end
    end

    return Panels(panels, containers)
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _panel_cell_draw_border!(rb::WidgetRawBuffer, buffer::Ptr{WINDOW}, bottom::Bool, left::Bool, right::Bool, top::Bool) -> Nothing

Draw function for the panel cell raw buffer. It renders to the `buffer` of the widget `rb`
the cell. The cell position is specified by the arguments `bottom`, `left`, `right`, and
`top`.
"""
function _panel_cell_draw_border!(
    rb::WidgetRawBuffer,
    buffer::Ptr{WINDOW},
    bottom::Bool,
    left::Bool,
    right::Bool,
    top::Bool
)
    @unpack theme, height, width = rb

    theme.border >= 0 && wattron(buffer, theme.border)

    # == Top Line ==========================================================================

    if top
        if left
            waddch(buffer, ACS_(:ULCORNER))
        else
            waddch(buffer, ACS_(:TTEE))
        end

    elseif left
        waddch(buffer, ACS_(:LTEE))

    else
        waddch(buffer, ACS_(:PLUS))
    end

    for _ in 2:(width - 1)
        waddch(buffer, ACS_(:HLINE))
    end

    if top && right
        waddch(buffer, ACS_(:URCORNER))

    elseif right
        waddch(buffer, ACS_(:RTEE))

    else
        waddch(buffer, ACS_(:HLINE))
    end

    # == Intermediate Borders ==============================================================

    for i in 2:(height - 1)
        mvwaddch(buffer, i - 1, 0, ACS_(:VLINE))
        right && mvwaddch(buffer, i - 1, width - 1, ACS_(:VLINE))
    end

    # == Bottom Line =======================================================================

    if !bottom
        mvwaddch(buffer, height - 1, 0, ACS_(:VLINE))
        right && mvwaddch(buffer, height - 1, width - 1, ACS_(:VLINE))

    else
        # Bottom line.
        if left
            mvwaddch(buffer, height - 1, 0, ACS_(:LLCORNER))
        else
            mvwaddch(buffer, height - 1, 0, ACS_(:BTEE))
        end

        for _ in 2:width
            waddch(buffer, ACS_(:HLINE))
        end

        right && waddch(buffer, ACS_(:LRCORNER))
    end

    theme.border >= 0 && wattroff(buffer, theme.border)

    return nothing
end

"""
    _panel_cell_draw_title!(rb::WidgetRawBuffer, buffer::Ptr{WINDOW}, title::String; kwargs...) -> Nothing

Draw the `title` in the panel cell `buffer` of the widget `rb`.

# Keywords

- `alignment::Symbol`: Title alignment, it can be `:l` for left, `:c` for center, or `:r`
    for right.
    (**Default**: `:c`)
- `right_cell::Bool`: Indicate that this is a cell positioned to the right so that we can
    take into account the right border.
    (**Default** = `false`)
"""
function _panel_cell_draw_title!(
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
        @ncolor theme.title buffer begin
            mvwprintw(buffer, 0, 1, title)
        end

    elseif alignment == :c
        lpad = max(div(width - tw - right_cell, 2), 0)

        @ncolor theme.title buffer begin
            mvwprintw(buffer, 0, lpad, title)
        end

    elseif alignment == :r
        lpad = max(width - tw, 0)

        @ncolor theme.title buffer begin
            mvwprintw(buffer, 0, lpad - 1 - right_cell, title)
        end
    end

    return nothing
end
