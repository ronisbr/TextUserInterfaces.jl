## Description #############################################################################
#
# This file contains macros related to dialogs.
#
############################################################################################

"""
    @dialog(ex)

Declare a structure of a dialog.
"""
macro dialog(ex)
    # Expression must be a structure definition.
    if !(typeof(ex) <: Expr) || (ex.head != :struct)
        error("@dialog must be used only with a structure definition.")
    end

    # Th structure supertype must be `Dialog`.
    ex.args[2] = :($(ex.args[2]) <: Dialog)

    # Then, we just need to add the required fields inside the arguments.
    push!(
        ex.args[3].args,
        [
            :(window::Window)
            :(opened::Bool = false)
            :(return_value::Union{Nothing, Symbol} = nothing)

            # Signal emitted when the user closes the dialog and `return_value` is
            # available.
            :(@signal dialog_closed)
        ]...,
    )

    ret = quote
        @kwdef $ex
    end

    return esc(ret)
end