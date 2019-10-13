using Parameters
using TextUserInterfaces
import TextUserInterfaces: accept_focus, create_widget, process_focus, redraw,
                           release_focus

# Global variables necessary to handle the game logic.
#
# This should be improved.
const board_marks = [0 0 0; 0 0 0; 0 0 0]
const current_player = [1]
const field_color = Int64[]
const field_highlight_colors = Int64[]
const ticks = ["X","O"]

################################################################################
#                                Custom widget
################################################################################

# The following functions create the field widget. This will be used to create
# each field of the board.

# We want full logging.
logger.level = 3
logger.enabled = true

# Structure of the widget.
@with_kw mutable struct WidgetField <: Widget
    # API
    # ==========================================================================
    common::WidgetCommon

    # Parameters related to the widget
    # ==========================================================================
    pos::Tuple{Int,Int} = (0,0)
    player::Int = 0
    t::AbstractString = " "
end

# Report to the focus manager that the widget can accept focus.
function accept_focus(widget::WidgetField)
    request_update(widget)
    return true
end

# Function to create the widget.
function create_widget(::Type{Val{:field}}, parent::WidgetParent, top::Integer,
                       left::Integer, pos::Tuple{Int,Int} = (0,0))

    height = 3
    width  = 7

    # Create the common parameters of the widget.
    common = create_widget_common(parent, top, left, height, width, :absolute,
                                  :absolute)

    # Create the widget.
    widget = WidgetField(common = common, pos = pos)

    # Add to the parent window widget list.
    push!(parent.widgets, widget)

    @log info "create_widget" """
    A field was created in window $(parent.id).
        Size        = ($(common.height), $(common.width))
        Coordinate  = ($(common.top), $(common.left))
        Size policy = ($(common.vsize_policy), $(common.hsize_policy))
        Reference   = $(obj_to_ptr(widget))"""

    # Return the created widget.
    return widget
end

# Function to process a keystroke when the widget is in focus.
function process_focus(widget::WidgetField, k::Keystroke)
    @unpack player, pos = widget

    # If the user pressed `enter`, then mark the board with the current player
    # tick.
    if k.ktype == :enter
        @log verbose "change_value" "$(obj_to_ptr(widget)): Enter pressed on focused field."

        # If the field has not been marked yet, then mark using the current
        # player and ask to change the player.
        if player == 0
            widget.t = ticks[current_player[1]]
            widget.player = current_player[1]
            mark_board(pos...)

            change_player()
            request_update(widget)
        end
    end

    # This widget will never pass the focus, it must be changed manually.
    return true
end

# Redraw event.
function redraw(widget::WidgetField)
    @unpack common, t, player = widget
    @unpack parent, buffer = common

    wclear(buffer)

    # Get the colors.
    if player == 0
        c = field_color[current_player[1]]
    else
        c = field_color[player]
    end

    ch = field_highlight_colors[current_player[1]]

    # Get the background color depending on the focus.
    c = has_focus(parent, widget) ? ch : c

    wattron(buffer, c)
    mvwprintw(buffer, 0, 0, "       ")
    mvwprintw(buffer, 1, 0, "   $t    ")
    mvwprintw(buffer, 2, 0, "       ")
    wattroff(buffer, c)

    return nothing
end

# Function called when the focus is released.
function release_focus(widget::WidgetField)
    request_update(widget)
    return true
end

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
    elseif board_marks[1,3] == board_marks[2,2] == board_marks[3,1] == 6
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
    noecho()

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

    win    = create_window(18,60,2,2; border = true, title = " Tic Tac Toe ")
    board  = create_widget(Val{:label}, win;
                           top = 2, left = 2, height = 11, width = 24,
                           text = board, color = pb)
    ~      = create_widget(Val{:label}, win;
                           top = 2, left = 30, height = 1, width = 18,
                           text = "Player 1: $(ticks[1])", color = p1)
    ~      = create_widget(Val{:label}, win;
                           top = 3, left = 30, height = 1, width = 18,
                           text = "Player 2: $(ticks[2])", color = p2)
    result = create_widget(Val{:label}, win;
                           top = 5, left = 30, height = 2, width = 27,
                           text = "", color = p0)
    info   = create_widget(Val{:label}, win;
                           top = 15, left = 2, height = 1, width = 20,
                           text = "Press F1 to exit.", color = p0)
    fields = [create_widget(Val{:field}, win, 2 + 4(i-1), 2 + 8(j-1), (i,j)) for i = 1:3,j = 1:3]
    focus_on_widget(fields[1,1])

    # Initialize the focus manager.
    tui.focus_chain = [win]
    init_focus_manager()

    # Initial painting.
    refresh_all_windows()
    update_panels()
    doupdate()

    i = 1
    j = 1
    finish = false

    k = jlgetch()

    while (k.ktype != :F1) && !finish
        process_focus(k)

        # If the key is an arrow, then move the focused widget.
        update = true
        if k.ktype == :down
            i = clamp(i+1,1,3)
        elseif k.ktype == :up
            i = clamp(i-1,1,3)
        elseif k.ktype == :right
            j = clamp(j+1,1,3)
        elseif k.ktype == :left
            j = clamp(j-1,1,3)
        end

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

        # Update if necessary because of focus change.
        if update
            focus_on_widget(fields[i,j])
            refresh_all_windows()
            update_panels()
            doupdate()
        end

        k = jlgetch()
    end

    destroy_tui()
end

tictactoe()
