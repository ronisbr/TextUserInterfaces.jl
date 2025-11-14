## Description #############################################################################
#
# Types related to inputs.
#
############################################################################################

export Keystroke

"""
    struct Keystroke

Structure that defines a keystroke.

# Fields

- `raw::Int32`: Raw value of the keystroke.
    (**Default** = `0`)
- `value::String`: String representing the keystroke.
- `ktype::Symbol`: Type of the key (`:char`, `:F1`, `:up`, etc.).
- `alt::Bool`: `true` if ALT key was pressed (only valid if `ktype != :char`).
    (**Default** = `false`)
- `ctrl::Bool`: `true` if CTRL key was pressed (only valid if `ktype != :char`).
    (**Default** = `false`)
- `shift::Bool`: `true` if SHIFT key was pressed (only valid if `ktype != :char`).
    (**Default** = `false`)
"""
@kwdef struct Keystroke
    raw::Int32 = 0
    value::String
    ktype::Symbol
    alt::Bool   = false
    ctrl::Bool  = false
    shift::Bool = false
end
