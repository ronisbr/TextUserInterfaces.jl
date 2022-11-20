# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Types related to color management.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

struct NCURSES_COLOR
    name::Symbol
    id::Int
end

struct NCURSES_COLOR_PAIR
    foreground::Symbol
    background::Symbol
end

# Dictionary that converts the color name to color ID.
const _ncurses_colors = Dict(
    :black   => COLOR_BLACK,
    :red     => COLOR_RED,
    :green   => COLOR_GREEN,
    :yellow  => COLOR_YELLOW,
    :blue    => COLOR_BLUE,
    :magenta => COLOR_MAGENTA,
    :cyan    => COLOR_CYAN,
    :white   => COLOR_WHITE
)

const _default_ncurses_colors = Dict(
    :black   => COLOR_BLACK,
    :red     => COLOR_RED,
    :green   => COLOR_GREEN,
    :yellow  => COLOR_YELLOW,
    :blue    => COLOR_BLUE,
    :magenta => COLOR_MAGENTA,
    :cyan    => COLOR_CYAN,
    :white   => COLOR_WHITE
)
