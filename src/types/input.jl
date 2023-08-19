# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==========================================================================================
#
#   Types related to inputs.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export Keystroke

"""
    struct Keystorke

Structure that defines a keystroke.

# Fields

- `raw::Int32`: Raw value of the keystroke.
- `value::String`: String representing the keystroke.
- `ktype::Symbol`: Type of the key (`:char`, `:F1`, `:up`, etc.).
- `alt::Bool`: `true` if ALT key was pressed (only valid if `ktype != :char`).
- `ctrl::Bool`: `true` if CTRL key was pressed (only valid if `ktype != :char`).
- `shift::Bool`: `true` if SHIFT key was pressed (only valid if `ktype != :char`).
"""
@with_kw struct Keystroke
    raw::Int32 = 0
    value::String
    ktype::Symbol
    alt::Bool   = false
    ctrl::Bool  = false
    shift::Bool = false
end
