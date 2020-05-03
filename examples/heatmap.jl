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
    con = create_widget(Val(:container), win)

    func = create_widget(Val(:form), con, ["Function f(x,y) ="], borders = true,
                         anchor_left = (win, :left, 1),
                         anchor_top  = (win, :top,  0))

    label = create_widget(Val(:label), con,
                          anchor_left  = (func, :left,   0),
                          anchor_right = (func, :right,  0),
                          anchor_top   = (func, :bottom, 2),
                          alignment    = :c,
                          color        = c1,
                          fill_color   = true,
                          text = "Setup limits")

    xlim = create_widget(Val(:form), con, ["x min.", "x max."],
                         anchor_left   = (func,  :left,    0),
                         anchor_top    = (label, :bottom,  0),
                         anchor_right  = (func,  :center, -1),
                         color_valid   = c0,
                         color_invalid = c3,
                         validator     = Float64)

    ylim = create_widget(Val(:form), con, ["y min.", "y max."],
                         anchor_left   = (func,  :center, +1),
                         anchor_top    = (label, :bottom,  0),
                         anchor_right  = (func,  :right,   0),
                         color_valid   = c0,
                         color_invalid = c3,
                         validator     = Float64)

    label = create_widget(Val(:label), con,
                          anchor_left  = (func, :left,   0),
                          anchor_right = (func, :right,  0),
                          anchor_top   = (ylim, :bottom, 2),
                          alignment    = :c,
                          color        = c1,
                          fill_color   = true,
                          text = "Select plot color")

    colormap_dict = Dict("Viridis" => :viridis,
                         "Magma"   => :magma,
                         "Inferno" => :inferno,
                         "Plasma"  => :plasma)

    colormap_keys  = collect(keys(colormap_dict))

    lanchor_w = func
    lanchor_a = :left
    ranchor_w = func
    ranchor_a = :center

    tanchor_w = label

    rb = nothing

    for i = 1:length(colormap_keys)
        rb = create_widget(Val(:radio_button), con,
                           group_name      = "Colormap",
                           label           = colormap_keys[i],
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

    bplot = create_widget(Val(:button), con,
                          label           = "Plot",
                          anchor_left     = (func, :left,   0),
                          anchor_top      = (rb  , :bottom, 3),
                          style           = :boxed,
                          width           = 14,
                          color_highlight = c2)

    bcplt = create_widget(Val(:button), con,
                          label             = "Clear plot",
                          anchor_center     = (func, :center, 0),
                          anchor_top        = (rb  , :bottom, 3),
                          style             = :boxed,
                          width             = 14,
                          color_highlight   = c2)

    bcfor = create_widget(Val(:button), con,
                          label           = "Clear form",
                          anchor_right    = (func, :right,  0),
                          anchor_top      = (rb  , :bottom, 3),
                          style           = :boxed,
                          width           = 14,
                          color_highlight = c2)

    tplot  = create_widget(Val(:label), con,
                           anchor_left    = (con, :center, 0),
                           anchor_right   = (con, :right,  0),
                           anchor_top     = (con, :top,    1),
                           text           = "PLOT",
                           fill_color     = true,
                           color          = c1,
                           alignment      = :c)

    str    = create_plot(zeros(40,40), get_limits(xlim,ylim)...)
    canvas = create_widget(Val(:ansi_label), con, text = str,
                           anchor_left    = (tplot, :left,   0),
                           anchor_right   = (tplot, :right,  0),
                           anchor_top     = (tplot, :bottom, 1),
                           anchor_bottom  = (con,   :bottom, 0))

    # Button actions.
    function plot()
        f_str = get_data(func)[1]

        if f_str != nothing
            xmin, xmax, ymin, ymax = get_limits(xlim, ylim)

            cb = get_selected("Colormap")
            color_name = cb.label

            if haskey(colormap_dict, color_name)
                colormap = colormap_dict[color_name]
            else
                colormap = :red
            end

            f = eval(Meta.parse("(x,y) -> @. " * f_str))
            x = range(xmin, ymax, length = 100)
            y = range(ymin, ymax, length = 100)

            try
                z = [Base.invokelatest(f, i, j) for i in x, j in y]
                str = create_plot(z, xmin, xmax, ymin, ymax, colormap)
                change_text(canvas, str)
            catch
            end
        end
    end

    function clear_form()
        clear_data!(func)
        clear_data!(xlim)
        clear_data!(ylim)
    end

    function clear_plot()
        str = create_plot(zeros(40,40), get_limits(xlim,ylim)...)
        change_text(canvas, str)
    end

    @connect_signal bplot return_pressed plot()
    @connect_signal bcfor return_pressed clear_form()
    @connect_signal bcplt return_pressed clear_plot()

    @forward_signal xlim bplot return_pressed
    @forward_signal ylim bplot return_pressed

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

function create_plot(z, xmin, xmax, ymin, ymax, colormap = :viridis)
    numx, numy = size(z)
    io = IOBuffer()
    show(IOContext(io, :color=>true),
         heatmap(z, xlabel = "x", ylabel = "y", zlabel = "f(x,y)",
                 xoffset = xmin, xscale = (xmax-xmin)/(numx-1),
                 yoffset = ymin, yscale = (ymax-ymin)/(numy-1),
                 colormap = colormap))
    return String(take!(io))
end

function get_limits(tlim,ylim)
    # Without this, we will have an bad type instability leading to a huge
    # performance hit when ploting data.
    vt = get_data(tlim)
    vy = get_data(ylim)

    if vt[1] == nothing
        x_min = (vt[2] == nothing) ? 0. : Float64(vt[2] - 1)
    else
        x_min = Float64(vt[1])
    end

    if vt[2] == nothing
        x_max = x_min + 1
    else
        x_max = Float64(vt[2])
    end

    if vy[1] == nothing
        y_min = (vy[2] == nothing) ? 0. : Float64(vy[2] - 1)
    else
        y_min = Float64(vy[1])
    end

    if vy[2] == nothing
        y_max = y_min + 1
    else
        y_max = Float64(vy[2])
    end

    return x_min, x_max, y_min, y_max
end

plots()
