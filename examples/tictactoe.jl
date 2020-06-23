using Parameters
using TextUserInterfaces

# Global variables necessary to handle the game logic.
const board_marks = [0 0 0; 0 0 0; 0 0 0]
const current_player = [1]
const field_color = Int64[]
const field_highlight_colors = Int64[]
const ticks = ["X","O"]

# We want full logging.
logger.level = 3
logger.enabled = true

################################################################################
#                                     Game
################################################################################

# Tell that the current player added a mark in position (i,j).
mark_board(i,j) = board_marks[i,j] = current_player[1]

# Change the current player.
change_player() = current_player[1] = current_player[1] == 1 ? 2 : 1

# Check for victory.
#
#   Return -1: End of game and no player won.
#   Return 0: No player won yet.
#   Return 1: Player 1 won.
#   Return 2: Player 2 won.
#
function check_victory()
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

# Create the TUI.
function tictactoe()
    # Initialize the TUI.
    init_tui()
    NCurses.noecho()

    # Initialize the colors.
    p0   = ncurses_color(bold = false)
    pb   = ncurses_color(:white, :black, bold = true)
    p1   = ncurses_color(:green, :black)
    p2   = ncurses_color(:yellow, :black)
    bth1 = ncurses_color(:black, :green)
    bth2 = ncurses_color(:black, :yellow)

    push!(field_color, p1)
    push!(field_color, p2)
    push!(field_highlight_colors,bth1)
    push!(field_highlight_colors,bth2)

    # Initialize the widgets.
    board = """
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

    # Create the main window and its container.
    opc = newopc(height = 18, width = 60, top = 2, left = 2)
    win, con = create_window_with_container(opc,
                                            border = true,
                                            title  = " Tic Tac Toe ")


    # Create the label widget that will display the board.
    opc   = newopc(top = 2, left = 2, height = 11, width = 24)
    board = create_widget(Val(:label), con, opc; text = board, color = pb)

    # Create the label showing the information related to player 1.
    opc = newopc(top = 2, left = 30, height = 1, width = 18)
    ~   = create_widget(Val(:label), con, opc; text = "Player 1: $(ticks[1])", color = p1)

    # Create the label showing the information related to player 2.
    opc = newopc(top = 3, left = 30, height = 1, width = 18)
    ~   = create_widget(Val(:label), con, opc; text = "Player 2: $(ticks[2])", color = p2)

    # Create the label that will show the end game information.
    opc    = newopc(top = 5, left = 30, height = 2, width = 27)
    result = create_widget(Val(:label), con, opc; text = "", color = p0)

    # Create the label with the information about how exit the TUI.
    opc = newopc(top = 15, left = 2, height = 1, width = 20)
    info = create_widget(Val(:label), con, opc; text = "Press F1 to exit.", color = p0)

    # This is a signal handler that will called every time the user press enter
    # in a field.
    #
    # It checks if the field is empty and then show the tick of the player.
    field_return_pressed(widget, i, j) = begin
        # If the field has not been marked yet, then mark using the current
        # player and ask to change the player.
        if board_marks[i,j] == 0
            widget.chars[2,4] = ticks[current_player[1]]
            mark_board(i,j)

            change_player()
            request_update(widget)
        end
    end

    # This is a signal handler that will called every time the field gains
    # focus.
    #
    # It changes the background color to that of the current player.
    field_focus_acquired(widget) = begin
        widget.colors .= field_highlight_colors[current_player[1]]
        request_update(widget)
    end

    # This is a signal handler that will called every time the field loses
    # focus.
    #
    # It removes the background color.
    field_focus_lost(widget) = begin
        widget.colors .= p0
        request_update(widget)
    end

    # Create the fields of the board.
    fields = [create_widget(Val(:canvas), con,
                            newopc(top  = 2 + 4(i-1),
                                   left = 2 + 8(j-1));
                                   num_columns = 7,
                                   num_rows = 3) for i = 1:3,j = 1:3]

    # Connect the required signals to the fields created.
    for i = 1:3, j = 1:3
        @connect_signal fields[i,j] focus_acquired field_focus_acquired
        @connect_signal fields[i,j] focus_lost field_focus_lost
        @connect_signal fields[i,j] return_pressed field_return_pressed i j
    end

    # Initialize the focus manager.
    tui.focus_chain = [win]
    init_focus_manager()

    request_focus(fields[1,1])

    # Initial painting.
    refresh_all_windows()
    NCurses.update_panels()
    NCurses.doupdate()

    i = 1
    j = 1
    finish = false

    k = jlgetch()

    while (k.ktype != :F1) && !finish
        # If the key is an arrow, then move the focused widget.
        change_focus = true
        if k.ktype == :down
            i = clamp(i+1,1,3)
        elseif k.ktype == :up
            i = clamp(i-1,1,3)
        elseif k.ktype == :right
            j = clamp(j+1,1,3)
        elseif k.ktype == :left
            j = clamp(j-1,1,3)
        elseif k.ktype == :tab
            # Ignore tab's because we do not want that the focus manager change
            # the focused widget.
            k = jlgetch()
            continue
        else
            change_focus = false
        end

        change_focus && request_focus(fields[i,j])

        # This function handles the screen update.
        process_focus(k)

        # Check for victory.
        status = check_victory()
        if status == 1
            change_text(result, "Player 1 won!!\nPress any key to exit...")
            finish = true
        elseif status == 2
            change_text(result, "Player 2 won!!\nPress any key to exit...")
            finish = true
        elseif status == -1
            change_text(result, "No player has won...\nPress any key to exit...")
            finish = true
        end

        # If the game is finished, we must also update the screen to show the
        # information immediately.
        if finish
            refresh_all_windows()
            NCurses.update_panels()
            NCurses.doupdate()
        end

        k = jlgetch()
    end

    destroy_tui()
end

tictactoe()
