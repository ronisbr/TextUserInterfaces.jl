## Description #############################################################################
#
# Functions to parse a string with ANSI color escape sequences.
#
############################################################################################

export parse_ansi_string

"""
    parse_ansi_string(str::AbstractString, decoration::Decoration = Decoration()) -> Vector{String}, Vector{Decoration}

Parse the string `str` that can contain ANSI color escape sequences. The user can pass the
initial `decoration`, which will be considered as the initial state.

# Returns

- `Vector{String}`: Strings.
- `Vector{Decoration}`: Objects of type `Decoration` with the decoration of each string.
"""
function parse_ansi_string(str::AbstractString, decoration::Decoration = Decoration())
    # Vector containing the decorations.
    d = Vector{Decoration}(undef, 0)

    # Vetor containing the strings.
    s = Vector{String}(undef, 0)

    # Parse each character.
    state = :string

    # Current string.
    str_i = ""

    # Current escape sequence code.
    code = ""

    for c in str
        # Check if we have a escape character. In this case, change the state to
        # `:escape_seq`. We also need to add the string assembled so far to the output
        # vector.
        if c == '\e'
            state = :escape_seq_beg

            if !isempty(str_i)
                push!(s, str_i)
                push!(d, decoration)
                str_i = ""
            end

            continue
        end

        # If we are not in the state `:escape_seq`, just add the character to the string.
        if state == :string
            str_i *= string(c)
        elseif state == :escape_seq_beg
            state = c == '[' ? :escape_seq : :string
        elseif state == :escape_seq
            if isdigit(c) || c == ';'
                code *= string(c)
            elseif c == 'm'
                state = :string
                decoration = _parse_ansi_code(decoration, code)
                code = ""
            else
                state = :string
                code = ""
            end
        end
    end

    !isempty(str_i) && push!(s, str_i)

    # We always push the last decoration.
    push!(d, decoration)

    return s, d
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

function _parse_ansi_code(decoration::Decoration, code::String)
    tokens = split(code, ';')

    i = 1
    while i ≤ length(tokens)
        code_i = tryparse(Int, tokens[i], base = 10)

        if code_i == 0
            decoration = Decoration()
        elseif code_i == 1
            decoration = Decoration(
                foreground = decoration.foreground,
                background = decoration.background,
                bold       = true,
                underline  = decoration.underline,
                reversed   = decoration.reversed
            )
        elseif code_i == 4
            decoration = Decoration(
                foreground = decoration.foreground,
                background = decoration.background,
                bold       = decoration.bold,
                underline  = true,
                reversed   = decoration.reversed
            )
        elseif code_i == 7
            decoration = Decoration(
                foreground = decoration.foreground,
                background = decoration.background,
                bold       = decoration.bold,
                underline  = decoration.underline,
                reversed   = true
            )
        elseif 30 <= code_i <= 37
            decoration = Decoration(
                foreground = code_i - 30,
                background = decoration.background,
                bold       = decoration.bold,
                underline  = decoration.underline,
                reversed   = decoration.reversed
            )
        # 256-color support for foreground.
        elseif code_i == 38
            # In this case, we can have an extended color code. To check this, we must have
            # at least two more codes.
            if (i + 2) ≤ length(tokens)
                code_i_1 = tryparse(Int, tokens[i + 1], base = 10)
                code_i_2 = tryparse(Int, tokens[i + 2], base = 10)

                if code_i_1 == 5
                    decoration = Decoration(
                        foreground = code_i_2,
                        background = decoration.background,
                        bold       = decoration.bold,
                        underline  = decoration.underline,
                        reversed   = decoration.reversed
                    )
                end

                i += 2
            end
        elseif code_i == 39
            decoration = Decoration(
                foreground = 7,
                background = decoration.background,
                bold       = decoration.bold,
                underline  = decoration.underline,
                reversed   = decoration.reversed
            )
        elseif 40 <= code_i <= 47
            decoration = Decoration(
                foreground = decoration.foreground,
                background = code_i - 40,
                bold       = decoration.bold,
                underline  = decoration.underline,
                reversed   = decoration.reversed
            )
        # 256-color support for background.
        elseif code_i == 48
            # In this case, we can have an extended color code. To check this,
            # we must have at least two more codes.
            if i+2 ≤ length(tokens)
                code_i_1 = tryparse(Int, tokens[i + 1], base = 10)
                code_i_2 = tryparse(Int, tokens[i + 2], base = 10)

                if code_i_1 == 5
                    decoration = Decoration(
                        foreground = decoration.foreground,
                        background = code_i_2,
                        bold       = decoration.bold,
                        underline  = decoration.underline,
                        reversed   = decoration.reversed
                    )
                end

                i += 2
            end
        elseif code_i == 49
            decoration = Decoration(
                foreground = decoration.foreground,
                background = 0,
                bold       = decoration.bold,
                underline  = decoration.underline,
                reversed   = decoration.reversed
            )
        # Bright foreground colors defined by Aixterm.
        elseif 90 <= code_i <= 97
            decoration = Decoration(
                foreground = code_i - 82,
                background = decoration.background,
                bold       = decoration.bold,
                underline  = decoration.underline,
                reversed   = decoration.reversed
            )
        # Bright background colors defined by Aixterm.
        elseif 100 <= code_i <= 107
            decoration = Decoration(
                foreground = decoration.foreground,
                background = code_i - 92,
                bold       = decoration.bold,
                underline  = decoration.underline,
                reversed   = decoration.reversed
            )
        end

        i += 1
    end

    return decoration
end
