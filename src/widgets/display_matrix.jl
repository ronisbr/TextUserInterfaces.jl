## Description #############################################################################
#
# Widget: Display matrix.
#
############################################################################################

export WidgetDisplayMatrix
export change_matrix!

############################################################################################
#                                        Structure                                         #
############################################################################################

"""
    struct WidgetDisplayMatrix

Store a widget to display a matrix or vector with automatic formatting and border rendering.

# Functions

    change_matrix!(dm::WidgetDisplayMatrix, new_matrix::AbstractVecOrMat) -> Nothing

Change the matrix of the widget `dm` to `new_matrix`.

# Signals

This widget does not have signals.
"""
@widget mutable struct WidgetDisplayMatrix
    # Input label data from the user.
    matrix::VecOrMat

    # Variable to store the aligned text to save computational burden.
    largest_line::Int = -1
    rendered_matrix::Vector{String} = String[]
end

############################################################################################
#                                        Object API                                        #
############################################################################################

function update_layout!(dm::WidgetDisplayMatrix; force::Bool = false)
    if update_widget_layout!(dm; force = force)
        _widget_matrix__render_matrix!(dm)
        return true
    end

    return false
end

############################################################################################
#                                        Widget API                                        #
############################################################################################

can_accept_focus(::WidgetDisplayMatrix) = false

function create_widget(
    ::Val{:display_matrix},
    layout::ObjectLayout;
    matrix::AbstractVecOrMat,
    theme::Theme = Theme()
)
    if matrix isa Vector
        r = length(matrix)
        c = 1
    else
        r, c = size(matrix)
    end

    # Layout hints.
    height = r + 2
    width  = 8c + 4

    layout_hints = Dict(
        :height         => height,
        :minimum_height => 5,
        :minimum_width  => 23,
        :width          => width,
    )

    # Create the widget.
    display_matrix = WidgetDisplayMatrix(;
        id           = reserve_object_id(),
        matrix       = matrix,
        layout       = layout,
        layout_hints = layout_hints,
        theme        = theme,
    )

    @log DEBUG "create_widget" """
    WidgetDisplayMatrix created:
      ID     = $(display_matrix.id)
      Matrix = $(display_matrix.matrix)"""

    # Return the created container.
    return display_matrix
end

function redraw!(dm::WidgetDisplayMatrix)
    @unpack buffer, theme, largest_line, rendered_matrix = dm
    NCurses.wclear(buffer)

    r = length(rendered_matrix)

    @nstyle get_style(theme, :border) buffer begin
        ll = largest_line + 3

        # Draw the corners using Unicode box-drawing characters.
        # This works correctly with extended color pairs (more than 256 pairs).
        NCurses.mvwprintw(buffer, 0,     0,  "┌")
        NCurses.mvwprintw(buffer, r + 1, 0,  "└")
        NCurses.mvwprintw(buffer, 0,     ll, "┐")
        NCurses.mvwprintw(buffer, r + 1, ll, "┘")

        # Draw the vertical lines.
        for i in 1:r
            NCurses.mvwprintw(buffer, i, 0,  "│")
            NCurses.mvwprintw(buffer, i, ll, "│")
        end
    end

    @nstyle get_style(theme, :default) buffer begin
        @inbounds for l in eachindex(rendered_matrix)
            NCurses.mvwprintw(buffer, l, 2, rendered_matrix[l])
        end
    end

    return nothing
end

############################################################################################
#                                         Helpers                                          #
############################################################################################

@create_widget_helper display_matrix

############################################################################################
#                                     Public Functions                                     #
############################################################################################

"""
    change_matrix!(dm::WidgetDisplayMatrix, new_matrix::AbstractVecOrMat) -> Nothing

Change to matrix of the widget `dm` to `new_matrix`.
"""
function change_matrix!(dm::WidgetDisplayMatrix, new_matrix::AbstractVecOrMat)
    dm.matrix = new_matrix
    _widget_matrix__render_matrix!(dm)
    return nothing
end

############################################################################################
#                                    Private Functions                                     #
############################################################################################

"""
    _widget_matrix__render_matrix!(dm::WidgetDisplayMatrix) -> Nothing

Render the matrix in `dm` creating the lines in the vector `dm.rendered_matrix`.
"""
function _widget_matrix__render_matrix!(dm::WidgetDisplayMatrix)
    # We will use Julia's default rendering to obtain the matrix that fits the space we
    # have.
    @unpack height, width, matrix = dm

    # We need to sum 2 in the height to account for the additional lines the `show` function
    # use to display the type and the newlines at the end.
    buf = IOBuffer()
    show(
        IOContext(
            buf,
            :compact     => true,
            :limit       => true,
            :displaysize => (height + 2, width - 4)
        ),
        MIME("text/plain"),
        matrix,
    )

    str = String(take!(buf))

    rendered_matrix = map(s -> rstrip(s)[2:end], split(str, '\n')[2:end])
    largest_line    = maximum(textwidth.(rendered_matrix))

    @pack! dm = largest_line, rendered_matrix

    return nothing
end
