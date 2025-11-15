## Description #############################################################################
#
# Main application loop.
#
############################################################################################

export app_main_loop, app_main_loop_iteration

"""
    app_main_loop() -> Nothing

Start the application main loop.

# Keywords

- `exit_keys::AbstractVector{Union{Symbol, String}}`: A vector of symbols or strings
    that define the keys that lead to the application termination. If it is a `Symbol`, we
    compare against the field `ktype` of the [`Keystroke`](@ref). If it is a `String`, we
    compare against the field `value` of the [`Keystroke`](@ref).
    (**Default**: `[:F1]`)
"""
function app_main_loop(; exit_keys::AbstractVector = [:F1])
    # If there is no window in focus, try to acquire it.
    isnothing(get_focused_window()) && move_focus_to_next_window()

    # Update everything before starting the loop.
    tui_update()

    # Main application loop.
    while true
        app_main_loop_iteration(; block = true, exit_keys) || break
    end

    destroy_tui()

    return nothing
end

"""
    app_main_loop_iteration(; kwargs...) -> Bool

Execute one iteration of the application main loop. If this funciton returns `true`, it
means that the should continue the iterations. Otherwise, we must quit the application.

# Keywords

- `block::Bool`: If `true`, the function will block waiting for a keystroke.
    (**Default**: `true`)
- `exit_keys::AbstractVector{Union{Symbol, String}}`: A vector of symbols or strings
    that define the keys that lead to the application termination. If it is a `Symbol`, we
    compare against the field `ktype` of the [`Keystroke`](@ref). If it is a `String`, we
    compare against the field `value` of the [`Keystroke`](@ref).
"""
function app_main_loop_iteration(;
    block::Bool = true,
    exit_keys::AbstractVector = [:F1]
)
    k = getkey(; block)
    @emit tui keypressed (; keystroke = k)

    # If the signal destroyed the TUI, we should just exit.
    !tui.initialized && return false

    # Check if the keystroke must be passed or if the signal hijacked it.
    if !@get_signal_property(tui, keypressed, block, false)
        for e in exit_keys
            _check_keystroke(k, e) && return false
        end

        process_keystroke(k)
    end

    @delete_signal_property tui keypressed block

    tui_update()

    return true
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _check_keystroke(k::Keystroke, s::Union{Symbol, String}) -> Bool

If `s` is a `Symbol`, check if the keystroke field of `k.ktype` matches `s`. If `s` is a
`String`, check if the keystroke field of `k.value` matches `s`.
"""
_check_keystroke(k::Keystroke, s::Symbol) = k.ktype == s
_check_keystroke(k::Keystroke, s::String) = k.value == s

