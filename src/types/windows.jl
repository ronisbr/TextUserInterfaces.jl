# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
#
#   Types related to windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export Window

@with_kw mutable struct Window <: Object
    id::String = ""
    title::String = ""
    coord::Tuple{Int,Int} = (0,0)
    has_border::Bool = false
    focusable::Bool = true

    # Positioning configuration.
    opc::ObjectPositioningConfiguration

    # Widget of the window.
    widget::Union{Widget,Nothing} = nothing

    # Buffer
    # ==========================================================================

    # Pointer to the window (pad) that handles the buffer.
    buffer::Ptr{WINDOW} = Ptr{WINDOW}(0)

    # If `true`, then the buffer has changed, which requires a view update.
    buffer_changed::Bool = true

    # View
    # ==========================================================================

    # Pointer to the window view, which is the window that is actually draw on
    # screen.
    view::Ptr{WINDOW} = Ptr{WINDOW}(0)

    # Origin of the view window with respect to the physical screen. This is
    # useful for setting the cursor position when required.
    orig::Tuple{Int,Int} = (0,0)

    # If `true`, then the view has changed and must be updated.
    view_needs_update::Bool = true

    # Panel
    # ==========================================================================

    # Panel of the window.
    panel::Ptr{Cvoid} = Ptr{Cvoid}(0)

    # Signals
    # ==========================================================================
    on_focus_acquired::Function = (win)->return nothing
    on_focus_released::Function = (win)->return nothing
end
