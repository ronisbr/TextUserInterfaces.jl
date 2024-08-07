## Description #############################################################################
#
# Macro to make it easier to build TUIs.
#
############################################################################################

export @tui_builder

const _REGEX_WIDGET_MACRO = r"^@tui_*"
const _REGEX_ID_MARKER    = r"__ID([0-9]+)__"
const _REGEX_LAST_MARKER  = r"__LAST([0-9]*)__"

"""
    @tui_builder(expr)

Helper to build text user interfaces. It expects a `block` in `expr` that construct a TUI by
creating widgets, signals, and others.

The macro manages a list of created objects that is updated everytime a call to a macro
`@tui_*` is performed. Hence, we can use the following markers to provide an easier way to
design the TUI:

- `__IDn__`: Reference to the *n*th created object.
- `__LAST__`: Reference to the last created object up to marker point.
- `__LASTn__`: Reference to the *n*th object created last.

!!! note

    This macro assings variables to store all objects created using `@tui_` functions that
    are not storred in a variable. Those variables are named `__OBJ_IDn__`, where `n` is the
    object ID.

# Extended Help

## Examples

```julia
@tui_builder begin
    @tui_label(
        c;
        text        = "Label 1",
        top_anchor  = (:parent, :top),
        left_anchor = (:parent, :left)
    )

    @tui_label(
        c;
        text        = "Label 2",
        left_anchor = (:parent, :left),
        top_anchor  = (__LAST__, :bottom), # <----------------------- Reference to "Label 1"
    )

    @tui_label(
        c;
        text        = "Label 3",
        left_anchor = (:parent, :right),
        top_anchor  = (__ID_1__, :top), # <-------------------------- Reference to "Label 1"
    )

    @tui_label(
        c;
        text        = "Label 4",
        left_anchor = (:parent, :right),
        top_anchor  = (__LAST_1__, :top), # <------------------------ Reference to "Label 2"
    )
end
```
"""
macro tui_builder(expr)
    exprs = Any[]
    obj_names = Any[]

    expr.head != :block && error("The expression must be a block.")

    id = 0
    for e in expr.args
        if (e isa Symbol) && _isa_marker(e)
            e = _parse_marker(e, obj_names)
        end

        if !(e isa Expr)
            push!(exprs, e)
            continue
        end

        _replace_markers!(e, obj_names)

        if (e.head == :macrocall) &&
            occursin(_REGEX_WIDGET_MACRO, string(e.args[1]))
            id += 1
            var_name = Symbol("__OBJ_ID$(id)__")

            push!(obj_names, var_name)
            push!(exprs, Expr(:(=), var_name, e))

        elseif (e.head == :(=)) && (e.args[2] isa Expr)
            # If the expression is an assignment, we need to check if we are creating a
            # widget using a `@tui_` function.
            if (e.args[2].head == :macrocall) &&
                occursin(_REGEX_WIDGET_MACRO, string(e.args[2].args[1]))
                id += 1
                push!(obj_names, e.args[1])
            end

            push!(exprs, e)
        else
            push!(exprs, e)
        end
    end

    output_expr = quote
        $(exprs...)
    end

    return esc(output_expr)
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _isa_marker(sym::Symbol) -> Bool

Return `true` if `sym` is a valid marker of `false` otherwise.
"""
function _isa_marker(sym::Symbol)
    return (
        occursin(_REGEX_ID_MARKER, string(sym)) ||
        occursin(_REGEX_LAST_MARKER, string(sym))
    )
end

"""
    _parse_marker(sym::Symbol, obj_names::Vector{Any}) -> Symbol

Replace the marker `sym` by the correct object in `obj_names`.
"""
function _parse_marker(sym::Symbol, obj_names::Vector{Any})
    num_objs = length(obj_names)
    sym_str  = string(sym)

    # == Last Marker =======================================================================

    m = match(_REGEX_LAST_MARKER, sym_str)

    if !isnothing(m)
        c = first(m.captures)

        if isempty(c)
            num_objs == 0 && error("No object was created before the first use of `__LAST__`.")
            id = num_objs
        else
            Δlast = parse(Int, c)
            id = num_objs - Δlast
            id < 1 && error("There is not object with ID $id, referenced using `$sym`.")
        end

        return obj_names[id]
    end

    # == ID Marker =========================================================================

    m = match(_REGEX_ID_MARKER, sym_str)

    if !isnothing(m)
        id_str = first(m.captures)
        id = parse(Int, id_str)
        id > num_objs && error("There is not object with ID $id.")
        return obj_names[id]
    end

    # If we reach this point, we have an internal error because this function must be called
    # after we ensure that `sym` is a valid marker.

    error("Internal error!")

    return nothing
end

"""
    _replace_markers!(expr::Expr, obj_names::Vector{Any}) -> Nothing

Replace all occurrences of markers in `expr` considering the object vector `obj_names`.
"""
function _replace_markers!(expr::Expr, obj_names::Vector{Any})
    for i in eachindex(expr.args)
        if (expr.args[i] isa Symbol) && _isa_marker(expr.args[i])
            expr.args[i] = _parse_marker(expr.args[i], obj_names)
        elseif expr.args[i] isa Expr
            _replace_markers!(expr.args[i], obj_names)
        end
    end

    return nothing
end
