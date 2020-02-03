using UnicodePlots
using TextUserInterfaces

import Base: tryparse

logger.level = 3
logger.enabled = true

# Create the TUI.
function plots()

    # Initialize the TUI.
    init_tui()
    NCurses.noecho()

    # Initialize the colors.
    c0 = ncurses_color(7, 0, underline = true)
    c1 = ncurses_color(7, 0, bold = true, underline = true)
    c2 = ncurses_color(:yellow, 0, bold = true)
    c3 = ncurses_color(:red, 0, bold = true, underline = true)

    # Initialize the window.
    win = create_window(border = true, title = " Unicode Plots ",
                        anchor_left = (rootwin, :left, 0),
                        anchor_top = (rootwin, :top, 0),
                        anchor_right = (rootwin, :right, 0),
                        anchor_bottom = (rootwin, :bottom, 0))
    con = create_widget(Val{:container}, win)

    func = create_widget(Val{:form}, con, ["Function y ="], borders = true,
                         anchor_left = (win, :left, 1),
                         anchor_top  = (win, :top,  0))

    label = create_widget(Val{:label}, con,
                          anchor_left  = (func, :left,   0),
                          anchor_right = (func, :right,  0),
                          anchor_top   = (func, :bottom, 0),
                          alignment    = :c,
                          text = "Use `t` as the time variable for the plots.")

    label = create_widget(Val{:label}, con,
                          anchor_left  = (func,  :left,   0),
                          anchor_right = (func,  :right,  0),
                          anchor_top   = (label, :bottom, 2),
                          alignment    = :c,
                          color        = c1,
                          fill_color   = true,
                          text = "Setup limits")

    tlim = create_widget(Val{:form}, con, ["t min.", "t max."],
                         anchor_left   = (func,  :left,    0),
                         anchor_top    = (label, :bottom,  0),
                         anchor_right  = (func,  :center, -1),
                         color_valid   = c0,
                         color_invalid = c3,
                         validator     = Float64)

    ylim = create_widget(Val{:form}, con, ["y min.", "y max."],
                         anchor_left   = (func,  :center, +1),
                         anchor_top    = (label, :bottom,  0),
                         anchor_right  = (func,  :right,   0),
                         color_valid   = c0,
                         color_invalid = c3,
                         validator     = Float64)

    label = create_widget(Val{:label}, con,
                          anchor_left  = (func, :left,   0),
                          anchor_right = (func, :right,  0),
                          anchor_top   = (ylim, :bottom, 2),
                          alignment    = :c,
                          color        = c1,
                          fill_color   = true,
                          text = "Select plot color")

    color_dict = Dict("Red"     => :red,
                      "Blue"    => :blue,
                      "Green"   => :green,
                      "Yellow"  => :yellow,
                      "Magenta" => :magenta,
                      "Cyan"    => :cyan)

    color_keys  = collect(keys(color_dict))

    lanchor_w = func
    lanchor_a = :left
    ranchor_w = func
    ranchor_a = :center

    tanchor_w = label

    rb = nothing

    for i = 1:length(color_keys)
        rb = create_widget(Val{:radio_button}, con,
                           group_name      = "Color",
                           label           = color_keys[i],
                           anchor_left     = (lanchor_w, lanchor_a, 0),
                           anchor_top      = (tanchor_w, :bottom,   0),
                           anchor_right    = (ranchor_w, ranchor_a, 0),
                           color_highlight = c2)

        if i%2 == 1
            lanchor_w = rb
            lanchor_a = :right
            ranchor_w = func
            ranchor_a = :right
        else
            lanchor_w = func
            lanchor_a = :left
            ranchor_w = func
            ranchor_a = :center
            tanchor_w = rb
        end
    end

    bplot = create_widget(Val{:button}, con,
                          label           = "Plot",
                          anchor_left     = (func, :left,   0),
                          anchor_top      = (rb  , :bottom, 3),
                          style           = :boxed,
                          width           = 14,
                          color_highlight = c2)

    bcplt = create_widget(Val{:button}, con,
                          label             = "Clear plot",
                          anchor_center     = (func, :center, 0),
                          anchor_top        = (rb  , :bottom, 3),
                          style             = :boxed,
                          width             = 14,
                          color_highlight   = c2)

    bcfor = create_widget(Val{:button}, con,
                          label           = "Clear form",
                          anchor_right    = (func, :right,  0),
                          anchor_top      = (rb  , :bottom, 3),
                          style           = :boxed,
                          width           = 14,
                          color_highlight = c2)

    tplot  = create_widget(Val{:label}, con,
                           anchor_left    = (con, :center, 0),
                           anchor_right   = (con, :right,  0),
                           anchor_top     = (con, :top,    1),
                           text           = "PLOT",
                           fill_color     = true,
                           color          = c1,
                           alignment      = :c)

    str    = create_plot([0], [0], :red, get_limits(tlim,ylim)...)
    canvas = create_widget(Val{:ansi_label}, con, text = str,
                           anchor_left    = (tplot, :left,   0),
                           anchor_right   = (tplot, :right,  0),
                           anchor_top     = (tplot, :bottom, 1),
                           anchor_bottom  = (con,   :bottom, 0))

    # Button actions.
    bplot.on_return_pressed = ()->begin
        f_str = get_data(func)[1]

        if f_str != nothing
            tmin, tmax, ymin, ymax = get_limits(tlim, ylim)

            cb = get_selected("Color")
            color_name = cb.label

            if haskey(color_dict, color_name)
                color = color_dict[color_name]
            else
                color = :red
            end

            f = eval(Meta.parse("t -> @. " * f_str))
            t = range(tmin, tmax, length = 40)

            try
                y = Base.invokelatest(f, t)
                str = create_plot(t, y, color, tmin, tmax, ymin, ymax)
                change_text(canvas, str)
            catch
            end
        end
    end

    bcfor.on_return_pressed = ()->begin
        clear_data!(func)
        clear_data!(tlim)
        clear_data!(ylim)
    end

    bcplt.on_return_pressed = ()->begin
        str = create_plot([0], [0], :red, get_limits(tlim,ylim)...)
        change_text(canvas, str)
    end

    # Initialize the focus manager.
    tui.focus_chain = [win]
    init_focus_manager()

    # Initial painting.
    refresh_all_windows()
    NCurses.update_panels()
    NCurses.doupdate()

    k = jlgetch()

    while (k.ktype != :F1)
        process_focus(k)
        k = jlgetch()
    end

    destroy_tui()
end

function create_plot(t,y,color,tmin,tmax,ymin,ymax)
    io = IOBuffer()
    show(IOContext(io, :color=>true),
         lineplot(t, y, color = color, xlim = (tmin, tmax),
                  ylim = (ymin, ymax), xlabel = "t", ylabel = "f(t)"))
    return String(take!(io))
end

function get_limits(tlim,ylim)
    # Without this, we will have an bad type instability leading to a huge
    # performance hit when ploting data.
    vt::Vector{Union{Nothing,Float64}} = get_data(tlim)
    vy::Vector{Union{Nothing,Float64}} = get_data(ylim)

    eltype(vt) == Nothing && (vt = [0.,1.])
    eltype(vy) == Nothing && (vy = [0.,1.])

    vt[1] == nothing && (vt[1] = vt[2] == nothing ? 0 : vt[2] - 1)
    vt[2] == nothing && (vt[2] = vt[1] + 1)

    vy[1] == nothing && (vy[1] = vy[2] == nothing ? 0 : vy[2] - 1)
    vy[2] == nothing && (vy[2] = vy[1] + 1)

    return vt[1], vt[2], vy[1], vy[2]
end

plots()

