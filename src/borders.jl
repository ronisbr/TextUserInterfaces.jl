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
function draw_border!(buffer::Ptr{WINDOW}; style::Symbol = :default)
    style == :rounded && return _borders__draw_rounded_border!(buffer)
    style == :double  && return _borders__draw_generic_border!(buffer, "╔", "╗", "╚", "╝", "═", "║")
    style == :heavy   && return _borders__draw_generic_border!(buffer, "┏", "┓", "┗", "┛", "━", "┃")

    NCurses.wborder(buffer)
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
    _borders__draw_rounded_border!(buffer::Ptr{WINDOW}) -> Nothing

Draw a rounded border to the given `buffer`.
"""
function _borders__draw_rounded_border!(buffer::Ptr{WINDOW})
    # When drawing a rounded borders, only the corners are UTF-8. Hence, we can draw a
    # default border and replace the corners, which is considerably faster.
    NCurses.wborder(buffer)

    # Get the dimensions of the window.
    h, w = _get_window_dimensions(buffer)

    NCurses.mvwprintw(buffer, 0    , 0    , "╭")
    NCurses.mvwprintw(buffer, 0    , w - 1, "╮")
    NCurses.mvwprintw(buffer, h - 1, 0    , "╰")
    NCurses.mvwprintw(buffer, h - 1, w - 1, "╯")

    return nothing
end