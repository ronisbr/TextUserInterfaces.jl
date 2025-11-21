## Description #############################################################################
#
# Types related to windows.
#
############################################################################################

export Window

"""
    struct Window <: Object

Structure that defines a window in the text user interface.

# Fields

- `id::Int`: ID of the window.
    (**Default** = `0`)
- `title::String`: Title of the window.
    (**Default** = `""`)
- `title_alignment::Symbol`: Alignment of the title (`:l`, `:c`, or `:r`).
    (**Default** = `:c`)
- `position::Tuple{Int, Int}`: Position of the window (row, column).
    (**Default** = `(0, 0)`)
- `has_border::Bool`: If `true`, the window has a border.
    (**Default** = `false`)
- `border_style::Symbol`: Style of the border (`:default`, `:rounded`, `:heavy`, or
    :double`).
    (**Default** = `:default`)
- `focusable::Bool`: If `true`, the window can receive focus.
    (**Default** = `true`)
- `buffer_view_locked::Bool`: If `true`, the buffer and view sizes are locked.
    (**Default** = `true`)
- `layout::ObjectLayout`: Layout configuration of the window.
- `theme::Theme`: Theme of the window.
- `buffer::Ptr{WINDOW}`: Pointer to the window buffer.
    (**Default** = `Ptr{WINDOW}(0)`)
- `buffer_changed::Bool`: If `true`, the buffer has changed and requires a view update.
    (**Default** = `true`)
- `view::Ptr{WINDOW}`: Pointer to the window view.
    (**Default** = `Ptr{WINDOW}(0)`)
- `origin::Tuple{Int, Int}`: Origin of the view window with respect to the physical screen.
    (**Default** = `(0, 0)`)
- `view_needs_update::Bool`: If `true`, the view has changed and must be updated.
    (**Default** = `true`)
- `panel::Ptr{Cvoid}`: Pointer to the panel of the window.
    (**Default** = `Ptr{Cvoid}(0)`)
- `widget_container::WidgetContainer`: Container for the widgets in the window.
    (**Default** = `WidgetContainer()`)

# Signals

- `focus_acquired`: Emitted when the window acquires focus.
- `focus_lost`: Emitted when the window loses focus.
"""
@kwdef mutable struct Window <: Object
    id::Int = 0
    title::String = ""
    title_alignment::Symbol = :c
    position::Tuple{Int, Int} = (0, 0)
    has_border::Bool = false
    border_style::Symbol = :default
    focusable::Bool = true

    # This variable stores if the user wants the buffer and view size to be locked. This is
    # useful when resizing the window.
    buffer_view_locked::Bool = true

    # Object layout configuration.
    layout::ObjectLayout

    # Window theme.
    theme::Theme

    # == Buffer ============================================================================

    # Pointer to the window (pad) that handles the buffer.
    buffer::Ptr{WINDOW} = Ptr{WINDOW}(0)

    # If `true`, then the buffer has changed, which requires a view update.
    buffer_changed::Bool = true

    # == View ==============================================================================

    # Pointer to the window view, which is the window that is actually draw on screen.
    view::Ptr{WINDOW} = Ptr{WINDOW}(0)

    # Origin of the view window with respect to the physical screen. This is useful for
    # setting the cursor position when required.
    origin::Tuple{Int, Int} = (0, 0)

    # If `true`, then the view has changed and must be updated.
    view_needs_update::Bool = true

    # == Panel =============================================================================

    # Panel of the window.
    panel::Ptr{Cvoid} = Ptr{Cvoid}(0)

    # == Widget Container ==================================================================

    widget_container::WidgetContainer

    # == Signals ===========================================================================

    @signal focus_acquired
    @signal focus_lost
end

"""
    struct RootWindow <: Object end

Structure to reference the root window.
"""
struct RootWindow <: Object end
