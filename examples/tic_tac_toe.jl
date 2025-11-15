using TextUserInterfaces

############################################################################################
#                                        Constants                                         #
############################################################################################

const _BOARD = """
           │       │
           │       │
           │       │
    ───────┼───────┼───────
           │       │
           │       │
           │       │
    ───────┼───────┼───────
           │       │
           │       │
           │       │"""


const _PLAYER_MARKS = ["X", "O"]
const _PLAYER_COLORS = [:green, :yellow]

############################################################################################
#                                        Functions                                         #
############################################################################################

"""
    check_victory(board_marks::Matrix{Int}) -> Int

Check if a player won the game considering the `board_marks`.

# Returns

- `-1`: No player won.
- `0`: The game has not ended yet.
- `1`: Player 1 won.
- `2`: Player 2 won.
"""
function check_victory(board_marks::Matrix{Int})
    # Lines.
    for i = 1:3
        if prod(board_marks[i,:]) == 1
            return 1
        elseif prod(board_marks[i,:]) == 8
            return 2
        end
    end

    # Columns.
    for j = 1:3
        if prod(board_marks[:,j]) == 1
            return 1
        elseif prod(board_marks[:,j]) == 8
            return 2
        end
    end

    # Diagonals.
    if board_marks[1,1] == board_marks[2,2] == board_marks[3,3] == 1
        return 1
    elseif board_marks[1,1] == board_marks[2,2] == board_marks[3,3] == 2
        return 2
    end

    if board_marks[1,3] == board_marks[2,2] == board_marks[3,1] == 1
        return 1
    elseif board_marks[1,3] == board_marks[2,2] == board_marks[3,1] == 2
        return 2
    end

    # Check for end of game.
    if findfirst(x->x == 0, board_marks) == nothing
        return -1
    end

    return 0
end

"""
    update_cursor!(fields::Matrix{WidgetLabel}, old_cursor_position::Vector{Int}, cursor_position::Vector{Int}, board_marks::Matrix{Int}) -> Nothing

Update the colors of the `fields` considering the current `cursor_position`, the
`old_cursor_position`, and the `board_marks`.
"""
function update_cursor!(
    fields::Matrix{WidgetLabel},
    old_cursor_position::Vector{Int},
    cursor_position::Vector{Int},
    board_marks::Matrix{Int}
)

    x, y = old_cursor_position

    # Update the decoration of the old cursor position.
    if (x != -1) && (y != -1)
        m = board_marks[x, y]
        fields[x, y].theme = m != 0 ?
            Theme(default = ncurses_color(:black, _PLAYER_COLORS[m])) :
            Theme()

        request_update!(fields[x, y])
    end

    # Update the decoration of the current cursor position.
    x, y = cursor_position

    if (x != -1) && (y != -1)
        fields[x, y].theme = Theme(default = ncurses_color(:black, :red))
        request_update!(fields[x, y])
    end

    return nothing
end


"""
    mark_field!(fields::Matrix{WidgetLabel}, cursor_position::Vector{Int}, current_player::Int) -> Nothing

Mark the field in `fields` at the `cursor_position` as played by the `current_player`.
"""
function mark_field!(
    fields::Matrix{WidgetLabel},
    cursor_position::Vector{Int},
    current_player::Int
)

    x, y = cursor_position
    text = _PLAYER_MARKS[current_player]
    change_text!(fields[x, y], "\n$text\n"; alignment = :c)

    return nothing
end

############################################################################################
#                                           Main                                           #
############################################################################################

function tic_tac_toe()
    initialize_tui()

    # == Window ============================================================================

    w = create_window(
        ;
        border = true,
        title  = " Tic Tac Toe "
    )

    c = w.widget_container

    # == Board =============================================================================

    board = @tui_label(
        parent      = c,
        text        = _BOARD,
        left_anchor = (:parent, :left, 5),
        top_anchor  = (:parent, :top, 2),
    )

    # == Fields ============================================================================

    fields = [
        @tui_label(
            parent      = c,
            alignment   = :c,
            fill        = true,
            text        = "\n\n\n",
            left_anchor = Anchor(board, :left, (y - 1) * 8),
            top_anchor  = Anchor(board, :top, (x - 1) * 4),
            height      = 3,
            width       = 7,
        )

        for x in 1:3, y in 1:3
    ]

    # == Current Player ====================================================================

    current_player_info_label = @tui_label(
        parent = c,
        text = "Current player:",
        top_anchor = (board, :top),
        left_anchor = (board, :right, 2)
    )

    current_player_label = @tui_label(
        parent = c,
        text = "Player 1 ($(_PLAYER_MARKS[1]))",
        top_anchor = (current_player_info_label, :top),
        left_anchor = (current_player_info_label, :right),
        width = 40,
        theme = Theme(default = ncurses_color(_PLAYER_COLORS[1], :black))
    )

    # == Game Result =======================================================================

    result = @tui_label(
        parent = c,
        left_anchor = (board, :left),
        top_anchor = (board, :bottom, 2),
        text = "",
        width = 40
    )

    # == Game State ========================================================================

    board_marks         = zeros(Int, 3, 3)
    current_player      = 1
    cursor_position     = [1, 1]
    old_cursor_position = [1, 1]
    game_ended          = false

    update_cursor!(fields, old_cursor_position, cursor_position, board_marks)

    # == Signals ===========================================================================

    # Function to handle every keystorke inside the game.
    function handle_keystroke(tui; keystroke)
        # If the game ended, destroy the TUI after the next keystroke.
        if game_ended
            destroy_tui()
        end

        # Move the cursor to the left.
        if keystroke.ktype == :left
            old_cursor_position .= cursor_position
            cursor_position[2] = max(cursor_position[2] - 1, 1)
            update_cursor!(fields, old_cursor_position, cursor_position, board_marks)

        # Move the cursor to the right.
        elseif keystroke.ktype == :right
            old_cursor_position .= cursor_position
            cursor_position[2] = min(cursor_position[2] + 1, 3)
            update_cursor!(fields, old_cursor_position, cursor_position, board_marks)

        # Move the cursor up.
        elseif keystroke.ktype == :up
            old_cursor_position .= cursor_position
            cursor_position[1] = max(cursor_position[1] - 1, 1)
            update_cursor!(fields, old_cursor_position, cursor_position, board_marks)

        # Move the cursor down.
        elseif keystroke.ktype == :down
            old_cursor_position .= cursor_position
            cursor_position[1] = min(cursor_position[1] + 1, 3)
            update_cursor!(fields, old_cursor_position, cursor_position, board_marks)

        # Check if the player can mark the current cursor position, and check if the game
        # ended.
        elseif keystroke.ktype == :enter
            x, y = cursor_position

            if board_marks[x, y] == 0
                board_marks[x, y] = current_player
                mark_field!(fields, cursor_position, current_player)
                current_player = mod(current_player, 2) + 1

                r = check_victory(board_marks)

                if r != 0
                    game_ended = true
                else
                    change_text!(
                        current_player_label,
                        "Player $current_player ($(_PLAYER_MARKS[current_player]))"
                    )

                    current_player_label.theme = Theme(
                        default = ncurses_color(_PLAYER_COLORS[current_player], :black)
                    )
                end

                if r == -1
                    change_text!(result, "No player won!")
                elseif r == 1
                    change_text!(result, "Player 1 won!")
                elseif r == 2
                    change_text!(result, "Player 2 won!")
                end
            end
        end
    end

    @connect tui keypressed handle_keystroke

    # == Main Loop =========================================================================

    app_main_loop(; exit_keys = [:F1, "\eq"])

    return nothing
end

tic_tac_toe()
