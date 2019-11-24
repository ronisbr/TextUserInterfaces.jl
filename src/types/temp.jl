# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Types that will be removed. Those are kept only to void compilation errors.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

@with_kw mutable struct TUI_FIELD
    id::String
    ptr::Ptr{Cvoid}       = Ptr{Cvoid}(0)

    # Field properties.
    height::Int           = 0
    width::Int            = 0
    y::Int                = 0
    x::Int                = 0
    buffer::String        = ""
    offscreen::Int        = 0
    nbuffers::Int         = 0
    color_foreground::Int = -1
    color_background::Int = -1
    justification::Symbol = :l
    visible::Bool         = true
    active::Bool          = true
    public::Bool          = true
    edit::Bool            = true
    wrap::Bool            = true
    blank::Bool           = false
    autoskip::Bool        = false
    nullok::Bool          = true
    passok::Bool          = false
    static::Bool          = true

    # Store the pointer if the field type is `TYPE_ENUM` to avoid deallocation
    # by the GC.
    penum::Vector{Cstring} = Cstring[]
end

@with_kw mutable struct TUI_FORM
    fields::Vector{TUI_FIELD}      = Vector{TUI_FIELD}(undef,0)
    ptr_fields::Vector{Ptr{Cvoid}} = Vector{Ptr{Cvoid}}(undef,0)
    ptr::Ptr{Cvoid}                = Ptr{Cvoid}(0)
    win::Union{Nothing,Window} = nothing

    # Focus manager
    # ==========================================================================
    has_focus::Bool = false

    # Signals
    # ==========================================================================
    on_return_pressed::Function = (form)->return nothing
end

@with_kw mutable struct TUI_MENU
    names::Vector{String}          = String[]
    descriptions::Vector{String}   = String[]
    items::Vector{Ptr{Cvoid}}      = Vector{Ptr{Cvoid}}(undef,0)
    ptr::Ptr{Cvoid}                = Ptr{Cvoid}(0)
    win::Union{Nothing,Window} = nothing

    # Focus manager
    # ==========================================================================
    has_focus::Bool = false

    # Signals
    # ==========================================================================
    on_return_pressed::Function = (form)->return nothing
end

