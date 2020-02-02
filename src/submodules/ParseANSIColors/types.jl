# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Types.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# This struct describe the decoration of a string.
@with_kw struct Decoration
    color::Int      = 7
    background::Int = 0
    bold::Bool      = false
    underline::Bool = false
    reversed::Bool  = false
end

