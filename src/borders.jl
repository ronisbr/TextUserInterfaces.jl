## Description #############################################################################
#
# Functions to draw borders to buffers.
#
############################################################################################

"""
    draw_border!(buffer::Ptr{WINDOW}; kwargs...) -> Nothing

Draw a border to `buffer`. The border style is selected by the keyword `style`.

# Keywords

- `style::Symbol`: Border style. Possible values are: `:default`, `:rounded`, `:double`, and
    `:heavy`.
    (**Default**: `:default`)
"""
function draw_border!(
    buffer::Ptr{WINDOW};
    style::Symbol = :default,
    theme::Theme = Theme(),
    title::String = "",
    title_alignment::Symbol = :l,
)
    # NOTE: We cannot use `wborder` because it will not work if we set a pair to a number
    # larger than 256.
    @nstyle get_style(theme, :border) buffer begin
        if style == :rounded
            _borders__draw_generic_border!(buffer, "╭", "╮", "╰", "╯", "─", "│")
        elseif style == :double
            _borders__draw_generic_border!(buffer, "╔", "╗", "╚", "╝", "═", "║")
        elseif style == :heavy
            _borders__draw_generic_border!(buffer, "┏", "┓", "┗", "┛", "━", "┃")
        else
            _borders__draw_generic_border!(buffer, "┌", "┐", "└", "┘", "─", "│")
        end
    end

    # Draw the title if needed.
    !isempty(title) && _borders__draw_title!(buffer, title, title_alignment, style, theme)

    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _borders__draw_generic_border!(buffer::Ptr{WINDOW}, tl::String, tr::String, bl::String, br::String, hline::String, vline::String) -> Nothing

Draw a generic border to the given `buffer` using the provided corner and line characters.

# Arguments

- `buffer::Ptr{WINDOW}`: Buffer where to draw the border.
- `tl::String`: Top-left corner character.
- `tr::String`: Top-right corner character.
- `bl::String`: Bottom-left corner character.
- `br::String`: Bottom-right corner character.
- `hline::String`: Horizontal line character.
- `vline::String`: Vertical line character.
"""
function _borders__draw_generic_border!(
    buffer::Ptr{WINDOW},
    tl::String,
    tr::String,
    bl::String,
    br::String,
    hline::String,
    vline::String
)
    # Get the dimensions of the window.
    h, w = _get_window_dimensions(buffer)

    # If the width or height is too small, do nothing.
    (w < 2 || h < 2) && return nothing

    # Prepare the strings.
    top_line    = tl * repeat(hline, w - 2) * tr
    vline_str   = vline
    bottom_line = bl * repeat(hline, w - 2) * br

    # Draw the border.
    for i in 1:h
        # Top line.
        if i == 1
            NCurses.mvwprintw(buffer, i - 1, 0, top_line)
        # Bottom line.
        elseif i == h
            NCurses.mvwprintw(buffer, i - 1, 0, bottom_line)
        # Middle borders.
        else
            NCurses.mvwprintw(buffer, i - 1, 0,     vline_str)
            NCurses.mvwprintw(buffer, i - 1, w - 1, vline_str)
        end
    end

    return nothing
end

"""
    _borders__draw_title!(buffer::Ptr{WINDOW}, title::String, title_alignment::Symbol, style::Symbol) -> Nothing

Draw the title `title` to the `buffer` using the given `title_alignment` and border `style`.
"""
function _borders__draw_title!(
    buffer::Ptr{WINDOW},
    title::String,
    title_alignment::Symbol,
    style::Symbol,
    theme::Theme
)
    # Get the dimensions of the window.
    _, w = _get_window_dimensions(buffer)

    # If the width is too small, do nothing.
    (w < 6) && return nothing

    # Escape the title string to avoid problems.
    esc_title    = escape_string(title)
    esc_title_tw = textwidth(esc_title)

    # Check if we need to clamp the title.
    if esc_title_tw + 6 > w
        esc_title, _  = right_crop(esc_title, esc_title_tw + 7 - w)
        esc_title    *= "…"
        esc_title_tw  = textwidth(esc_title)
    end

    # Compute the position to draw the title.
    pos = if title_alignment == :c
        div(w - (esc_title_tw + 4), 2)
    elseif title_alignment == :r
        w - (esc_title_tw + 4) - 1
    else
        1
    end

    # Draw the title.
    @nstyle get_style(theme, :border) buffer begin
        if style == :double
            NCurses.mvwprintw(buffer, 0, pos, "╡ ")
        elseif style == :heavy
            NCurses.mvwprintw(buffer, 0, pos, "┫ ")
        else
            NCurses.mvwprintw(buffer, 0, pos, "┤ ")
        end
    end

    @nstyle get_style(theme, :title) buffer begin
        NCurses.wprintw(buffer, esc_title)
    end

    @nstyle get_style(theme, :border) buffer begin
        if style == :double
            NCurses.wprintw(buffer, " ╞")
        elseif style == :heavy
            NCurses.wprintw(buffer, " ┣")
        else
            NCurses.wprintw(buffer, " ├")
        end
    end

    return nothing
end