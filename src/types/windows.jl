# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#   Types related to windows.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

export Window

@with_kw mutable struct Window <: Object
    id::Int = 0
    title::String = ""
    title_color::Int = 0
    position::Tuple{Int, Int} = (0, 0)
    has_border::Bool = false
    border_color::Int = 0
    focusable::Bool = true

    # This variable stores if the user wants the buffer and view size to be
    # locked. This is useful when resizing the window.
    buffer_view_locked::Bool = true

    # Object layout configuration.
    layout::ObjectLayout

    # Window theme.
    theme::Theme

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
    origin::Tuple{Int, Int} = (0, 0)

    # If `true`, then the view has changed and must be updated.
    view_needs_update::Bool = true

    # Panel
    # ==========================================================================

    # Panel of the window.
    panel::Ptr{Cvoid} = Ptr{Cvoid}(0)

    # Widget container
    # ==========================================================================

    widget_container::WidgetContainer

    # Signals
    # ==========================================================================

    @signal focus_acquired
    @signal focus_lost
end

# Object to reference the root window.
struct RootWindow <: Object end
