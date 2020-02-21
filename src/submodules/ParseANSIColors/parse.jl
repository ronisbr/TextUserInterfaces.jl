# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Functions to parse a string with ANSI color escape sequences.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export parse_ansi_string

"""
    parse_ansi_string(str::AbstractString)

Parse the string `str` that can contain ANSI color escape sequences. This
function returns two vectors:

* A vector with the strings;
* A vector with objects of type `Decoration` describing the decoration of each
  string.

"""
function parse_ansi_string(str::AbstractString)
    # Current state.
    decoration = Decoration()

    # Vector containing the decorations.
    d = Vector{Decoration}(undef,0)

    # Vetor containing the strings.
    s = Vector{String}(undef,0)

    # Parse each character.
    state = :string

    # Current string.
    str_i = ""

    # Current escape sequence code.
    code = ""

    for c in str
        # Check if we have a escape charater. In this case, change the state to
        # `:escape_seq`. We also need to add the string assembled so far to the
        # output vector.
        if c == '\e'
            state = :escape_seq_beg

            if !isempty(str_i)
                push!(s, str_i)
                push!(d, decoration)
                str_i = ""
            end

            continue
        end

        # If we are not in the state `:escape_seq`, then just add the character
        # to the string.
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

    if !isempty(str_i)
        push!(s, str_i)
        push!(d, decoration)
    end

    return s,d
end

################################################################################
#                              Private functions
################################################################################

function _parse_ansi_code(decoration::Decoration, code::String)
    tokens = split(code, ';')

    i = 1
    while i ≤ length(tokens)
        code_i = tryparse(Int, tokens[i], base = 10)

        if code_i == 0
            decoration = Decoration()
        elseif code_i == 1
            decoration = Decoration(decoration; bold = true)
        elseif code_i == 4
            decoration = Decoration(decoration; underline = true)
        elseif code_i == 7
            decoration = Decoration(decoration; reversed = true)
        elseif 30 <= code_i <= 37
            decoration = Decoration(decoration; foreground = code_i - 30)
        # 256-color support for foreground.
        elseif code_i == 38
            # In this case, we can have an extended color code. To check this,
            # we must have at least two more codes.
            if i+2 ≤ length(tokens)
                code_i_1 = tryparse(Int, tokens[i+1], base = 10)
                code_i_2 = tryparse(Int, tokens[i+2], base = 10)

                if code_i_1 == 5
                    decoration = Decoration(decoration; foreground = code_i_2)
                end

                i += 2
            end
        elseif code_i == 39
            decoration = Decoration(decoration; foreground = 7)
        elseif 40 <= code_i <= 47
            decoration = Decoration(decoration; background = code_i - 40)
        # 256-color support for background.
        elseif code_i == 48
            # In this case, we can have an extended color code. To check this,
            # we must have at least two more codes.
            if i+2 ≤ length(tokens)
                code_i_1 = tryparse(Int, tokens[i+1], base = 10)
                code_i_2 = tryparse(Int, tokens[i+2], base = 10)

                if code_i_1 == 5
                    decoration = Decoration(decoration; background = code_i_2)
                end

                i += 2
            end
        elseif code_i == 49
            decoration = Decoration(decoration; background = 0)
        # Bright foreground colors defined by Aixterm.
        elseif 90 <= code_i <= 97
            decoration = Decoration(decoration; foreground = code_i - 82)
        # Bright background colors defined by Aixterm.
        elseif 100 <= code_i <= 107
            decoration = Decoration(decoration; background = code_i - 92)
        end

        i += 1
    end

    return decoration
end
