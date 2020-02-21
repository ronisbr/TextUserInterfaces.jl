# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Validators for inputs.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export validate_str

"""
    validate_str(str::AbstractString, v)

Validate the string `str` using the validator `v`. `v` is an element of the type
that will be used to validate or a regex.

"""
validate_str(str::AbstractString, v::T) where T = tryparse(T, str) != nothing
validate_str(str::AbstractString, v::Regex)     = occursin(v, str)

