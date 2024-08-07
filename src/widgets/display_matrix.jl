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
    else
        return false
    end
end

############################################################################################
#                                        Widget API                                        #
############################################################################################

can_accept_focus(::WidgetDisplayMatrix) = false

function create_widget(
    ::Val{:display_matrix},
    layout::ObjectLayout;
    matrix::AbstractVecOrMat,
    theme::Theme = tui.default_theme
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

    # Create the widget.
    display_matrix = WidgetDisplayMatrix(
        ;
        id               = reserve_object_id(),
        matrix           = matrix,
        layout           = layout,
        theme            = theme,
        horizontal_hints = Dict(:width  => width),
        vertical_hints   = Dict(:height => height)
    )

    @log DEBUG "create_widget" """
    WidgetDisplayMatrix created:
      ID = $(display_matrix.id)
      Matrix = $(display_matrix.matrix)"""

    # Return the created container.
    return display_matrix
end

function redraw!(dm::WidgetDisplayMatrix)
    @unpack buffer, theme, largest_line, rendered_matrix = dm
    NCurses.wclear(buffer)

    r = length(rendered_matrix)

    @ncolor theme.border buffer begin
        # Draw the corners.
        NCurses.mvwaddch(buffer, 0,     0,                NCurses.ACS_(:ULCORNER))
        NCurses.mvwaddch(buffer, r + 1, 0,                NCurses.ACS_(:LLCORNER))
        NCurses.mvwaddch(buffer, 0,     largest_line + 3, NCurses.ACS_(:URCORNER))
        NCurses.mvwaddch(buffer, r + 1, largest_line + 3, NCurses.ACS_(:LRCORNER))

        # Draw the line.
        NCurses.mvwvline(buffer, 1, 0, NCurses.ACS_(:VLINE), r)
        NCurses.mvwvline(buffer, 1, largest_line + 3, NCurses.ACS_(:VLINE), r)
    end

    @ncolor theme.default buffer begin
        @inbounds for l in 1:length(rendered_matrix)
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
    largest_line = maximum(textwidth.(rendered_matrix))

    @pack! dm = largest_line, rendered_matrix

    return nothing
end
