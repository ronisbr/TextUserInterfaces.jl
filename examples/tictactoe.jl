using Parameters
using TextUserInterfaces
import TextUserInterfaces: accept_focus, create_widget, process_focus, redraw,
                           release_focus

logger.level = 3
logger.enabled = true

const current_tick = [""]

@with_kw mutable struct WidgetField <: Widget
    # API
    # ==========================================================================
    parent::Window = nothing
    cwin::Ptr{WINDOW}  = Ptr{WINDOW}(0)
    update_needed::Bool = true

    # Parameters related to the widget
    # ==========================================================================
    color::Int
    color_highlight::Int
    used::Bool = false
    t::AbstractString = " "
end

function accept_focus(widget::WidgetField)
    request_update(widget)
    return true
end

function create_widget(::Type{Val{:field}}, parent::Window,
                       begin_y::Integer, begin_x::Integer, color::Int,
                       color_highlight::Int)

    nlines = 3
    ncols  = 6

    # Create the window that will hold the contents.
    cwin = subpad(parent.buffer, nlines, ncols, begin_y, begin_x)

    # Create the widget.
    widget = WidgetField(parent = parent, cwin = cwin, color = color,
                         color_highlight = color_highlight)

    # Add to the parent window widget list.
    push!(parent.widgets, widget)

    @log info "create_widget" """
    A field was created in window $(parent.id).
        Size       = ($nlines, $ncols)
        Coordinate = ($begin_y, $begin_x)
        Reference  = $(obj_to_ptr(widget))"""

    # Return the created widget.
    return widget
end

function process_focus(widget::WidgetField, k::Keystroke)
    if k.ktype == :enter
        @log verbose "change_value" "Window $(widget.parent.id): Enter pressed on focused field."

        if !widget.used
            widget.t = current_tick[1]
            widget.used = true
            request_update(widget)
        end
    end

    # This widget will never pass the focus, it must be changed manually.
    return true
end

function redraw(widget::WidgetField)
    @unpack cwin, t, color, color_highlight = widget
    wclear(cwin)

    # Get the background color depending on the focus.
    c = has_focus(widget.parent, widget) ? color_highlight : color

    wattron(cwin, c)
    mvwprintw(cwin, 0, 0, "      ")
    mvwprintw(cwin, 1, 0, "   $t   ")
    mvwprintw(cwin, 2, 0, "      ")
    wattroff(cwin, c)

    return nothing
end

function release_focus(widget::WidgetField)
    request_update(widget)
    return true
end

function tictactoe()
    init_tui()
    noecho()

    init_color(:light_blue, 700, 700, 1000)
    p0 = ncurses_color(bold = false)
    p1 = ncurses_color(bold = true, underline = true)
    p2 = ncurses_color(:yellow, :black)
    p3 = ncurses_color(:black, :white)
    p4 = ncurses_color(:black, :yellow)

    ticks = ["X","O"]

    board = """
          │      │
          │      │
          │      │
    ──────┼──────┼──────
          │      │
          │      │
          │      │
    ──────┼──────┼──────
          │      │
          │      │
          │      │"""

    win   = create_window(20,80,2,2; border = true, title = "Tic Tac Toe")
    board = create_widget(Val{:label}, win, 2, 2,  11, 21, board)
    ~     = create_widget(Val{:label}, win, 3, 25,  1, 18, "Player 1: $(ticks[1])")
    ~     = create_widget(Val{:label}, win, 4, 25,  1, 18, "Player 2: $(ticks[2])")
    fields = [create_widget(Val{:field}, win, 2 + 4(i-1), 2 + 7(j-1), p0, p3) for i = 1:3,j = 1:3]
    focus_on_widget(fields[1,1])



    tui.focus_chain = [win]
    init_focus_manager()

    # Initial painting.
    refresh_all_windows()
    update_panels()
    doupdate()

    i = 1
    j = 1

    k = jlgetch()

    player = 1
    current_tick[1] = ticks[player]

    while k.ktype != :F1
        process_focus(k)

        # If the key is an arrow, then move the focused widget.
        focus_changed = false
        if k.ktype == :down
            i = clamp(i+1,1,3)
            focus_changed = true
        elseif k.ktype == :up
            i = clamp(i-1,1,3)
            focus_changed = true
        elseif k.ktype == :right
            j = clamp(j+1,1,3)
            focus_changed = true
        elseif k.ktype == :left
            j = clamp(j-1,1,3)
            focus_changed = true
        elseif k.ktype == :enter
            player = player == 1 ? 2 : 1
            current_tick[1] = ticks[player]
        end

        if focus_changed
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
