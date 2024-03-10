## Description #############################################################################
#
# Definition of types for ParseAnsiColor.jl.
#
############################################################################################

# This struct describe the decoration of a string.
@with_kw struct Decoration
    foreground::Int = 7
    background::Int = 0
    bold::Bool      = false
    underline::Bool = false
    reversed::Bool  = false
end
