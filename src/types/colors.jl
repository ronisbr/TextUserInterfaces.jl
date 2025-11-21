## Description #############################################################################
#
# Types related to color management.
#
############################################################################################

"""
    struct NCURSES_COLOR

Store a color definition for NCurses.

# Fields

- `name::Symbol`: Name of the color.
- `id::Int`: ID of the color.
"""
struct NCURSES_COLOR
    name::Symbol
    id::Int
end

"""
    struct NCURSES_COLOR_PAIR

Store a color pair definition for NCurses.

# Fields

- `foreground::Symbol`: Name of the foreground color.
- `background::Symbol`: Name of the background color.
"""
struct NCURSES_COLOR_PAIR
    foreground::Symbol
    background::Symbol
end

# Dictionary that converts the color name to color ID.
const _NCURSES_COLORS = Dict(
    :black   => COLOR_BLACK,
    :red     => COLOR_RED,
    :green   => COLOR_GREEN,
    :yellow  => COLOR_YELLOW,
    :blue    => COLOR_BLUE,
    :magenta => COLOR_MAGENTA,
    :cyan    => COLOR_CYAN,
    :white   => COLOR_WHITE
)

const _DEFAULT_NCURSES_COLORS = Dict(
    :black   => COLOR_BLACK,
    :red     => COLOR_RED,
    :green   => COLOR_GREEN,
    :yellow  => COLOR_YELLOW,
    :blue    => COLOR_BLUE,
    :magenta => COLOR_MAGENTA,
    :cyan    => COLOR_CYAN,
    :white   => COLOR_WHITE
)
