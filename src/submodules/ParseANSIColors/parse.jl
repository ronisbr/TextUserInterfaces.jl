# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Functions to parse a string with ANSI color escape sequences.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export parse_ansi_string

"""
    function parse_ansi_string(str::AbstractString)

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

    for token in tokens
        code_i = tryparse(Int, token, base = 10)

        if code_i == 0
            decoration = Decoration()
        elseif code_i == 1
            decoration = Decoration(decoration; bold = true)
        elseif code_i == 4
            decoration = Decoration(decoration; underline = true)
        elseif code_i == 7
            decoration = Decoration(decoration; reversed = true)
        elseif 30 <= code_i <= 37
            decoration = Decoration(decoration; color = code_i - 30)
        elseif 40 <= code_i <= 47
            decoration = Decoration(decoration; background = code_i - 40)
        end
    end

    return decoration
end
