## Description #############################################################################
#
# Miscellaneous functions.
#
############################################################################################

export obj_desc

"""
    ansi_foreground_to_ncurses_color(ansi::String) -> Int

Convert an ANSI foreground color code in `ansi` to a ncurses color index.
"""
function ansi_foreground_to_ncurses_color(ansi::String)
    isempty(ansi) && return -1

    tokens = split(ansi, ';')

    num_tokens = length(tokens)

    if num_tokens == 1
        code = tryparse(Int, first(tokens), base = 10)

        isnothing(code) && return -1

              code == 39 && return -1
        30 <= code <= 37 && return code - 30
        90 <= code <= 97 && return code - 82

    elseif num_tokens == 3
        code₀ = tryparse(Int, tokens[begin],     base = 10)
        code₁ = tryparse(Int, tokens[begin + 1], base = 10)
        code₂ = tryparse(Int, tokens[begin + 2], base = 10)

        (isnothing(code₀) || isnothing(code₁) || isnothing(code₂)) && return 7

        (code₀ == 38 && code₁ == 5) && return code₂
    end

    return 7
end

"""
    ansi_background_to_ncurses_color(ansi::String) -> Int

Convert an ANSI background color code in `ansi` to a ncurses color index.
"""
function ansi_background_to_ncurses_color(ansi::String)
    isempty(ansi) && return -1

    tokens = split(ansi, ';')

    num_tokens = length(tokens)

    if num_tokens == 1
        code = tryparse(Int, first(tokens), base = 10)

        isnothing(code) && return -1

               code ==  49 && return -1
         40 <= code <=  47 && return code - 40
        100 <= code <= 107 && return code - 82

    elseif num_tokens == 3
        code₀ = tryparse(Int, tokens[begin],     base = 10)
        code₁ = tryparse(Int, tokens[begin + 1], base = 10)
        code₂ = tryparse(Int, tokens[begin + 2], base = 10)

        (isnothing(code₀) || isnothing(code₁) || isnothing(code₂)) && return 0

        (code₀ == 48 && code₁ == 5) && return code₂
    end

    return 0
end

"""
    obj_desc(obj) -> String

Return a string with the description of the object `obj` formed by:

    <Object type> (<Object ID>)
"""
function obj_desc(obj)
    obj_type = string(typeof(obj))

    # JET.jl reporter a problem that was solved by fixing the type here.
    obj_id::String = string(get_id(obj))

    return obj_type * " (" * obj_id * ")"
end