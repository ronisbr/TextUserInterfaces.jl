## Description #############################################################################
#
# Definition of types for ParseAnsiColor.jl.
#
############################################################################################

"""
    struct Decoration

Store the decoration of a text.

# Fields

- `foreground::Int`: Foreground color index.
    (**Default** = 7)
- `background::Int`: Background color index.
    (**Default** = 0)
- `bold::Bool`: If `true`, the text is bold.
    (**Default** = `false`)
- `underline::Bool`: If `true`, the text is underlined.
    (**Default** = `false`)
- `reversed::Bool`: If `true`, the foreground and background colors are reversed.
    (**Default** = `false`)
"""
@kwdef struct Decoration
    foreground::Int = 7
    background::Int = 0
    bold::Bool      = false
    underline::Bool = false
    reversed::Bool  = false
end
