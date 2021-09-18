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
    win = create_window(border = true, title = " Unicode Plots ")
    con = @tui_container(parent = win)

    func = @tui_form(
        parent = con,
        anchor_left = (:parent, :left, 1),
        anchor_top = (:parent, :top),
        borders = true,
        labels = ["Function y ="]
    )

    label = @tui_label(
        parent = con,
        anchor_left = (func, :left),
        anchor_right = (func, :right),
        anchor_top = (func, :bottom),
        alignment = :c,
        text = "Use `t` as the time variable for the plots."
    )

    label = @tui_label(
        parent = con,
        anchor_left = (func, :left),
        anchor_right = (func,  :right),
        anchor_top = (label, :bottom, 2),
        alignment = :c,
        color = c1,
        fill_color = true,
        text = "Setup limits"
    )

    tlim = @tui_form(
        parent = con,
        anchor_left = (func, :left),
        anchor_top = (label, :bottom),
        anchor_right = (func,  :center, -1),
        color_valid = c0,
        color_invalid = c3,
        labels = ["t min.", "t max."],
        validators = Float64
    )

    ylim = @tui_form(
        parent = con,
        anchor_left = (func, :center, +1),
        anchor_top = (label, :bottom),
        anchor_right = (func,  :right),
        color_valid = c0,
        color_invalid = c3,
        labels = ["y min.", "y max."],
        validators = Float64
    )

    label = @tui_label(
        parent = con,
        anchor_left = (func, :left),
        anchor_right = (func, :right),
        anchor_top = (ylim, :bottom, 2),
        alignment = :c,
        color = c1,
        fill_color = true,
        text = "Select plot color"
    )

    color_dict = Dict(
        "Red"     => :red,
        "Blue"    => :blue,
        "Green"   => :green,
        "Yellow"  => :yellow,
        "Magenta" => :magenta,
        "Cyan"    => :cyan
    )

    color_keys  = collect(keys(color_dict))

    lanchor_w = func
    lanchor_a = :left
    ranchor_w = func
    ranchor_a = :center

    tanchor_w = label

    rb = nothing

    for i in 1:length(color_keys)
        rb = @tui_radio_button(
            parent = con,
            anchor_left = (lanchor_w, lanchor_a),
            anchor_top = (tanchor_w, :bottom),
            anchor_right = (ranchor_w, ranchor_a),
            color_highlight = c2,
            group_name = "Color",
            label = color_keys[i]
        )

        if i % 2 == 1
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

    tplot = @tui_label(
        parent = con,
        anchor_left = (:parent, :center),
        anchor_right = (:parent, :right),
        anchor_top = (:parent, :top, 1),
        alignment = :c,
        color = c1,
        fill_color = true,
        text = "PLOT"
    )

    str = create_plot([0], [0], :red, get_limits(tlim,ylim)...)

    canvas = @tui_ansi_label(
        parent = con,
        anchor_left = (tplot, :left),
        anchor_right = (tplot, :right),
        anchor_top = (tplot, :bottom, 1),
        anchor_bottom = (con,   :bottom),
        text = str
    )

    # Button actions.
    function plot(w, k)
        k.ktype != :enter && return nothing

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

        return true
    end

    function clear_form(w, k)
        if k.ktype == :enter
            clear_data!(func)
            clear_data!(tlim)
            clear_data!(ylim)
        end
        return true
    end

    function clear_plot(w, k)
        if k.ktype == :enter
            str = create_plot([0], [0], :red, get_limits(tlim,ylim)...)
            change_text(canvas, str)
        end
        return true
    end

    bplot = @tui_button(
        parent = con,
        anchor_left = (func, :left),
        anchor_top  = (rb, :bottom, 3),
        width = 14,
        color_highlight = c2,
        label = "Plot",
        style = :boxed,
        signal = (key_pressed, plot)
    )

    bcplt = @tui_button(
        parent = con,
        anchor_center = (func, :center),
        anchor_top = (rb  , :bottom, 3),
        width = 14,
        color_highlight = c2,
        label = "Clear plot",
        style = :boxed,
        signal = (key_pressed, clear_plot)
    )

    bcfor = @tui_button(
        parent = con,
        anchor_right = (func, :right, 0),
        anchor_top = (rb  , :bottom, 3),
        width = 14,
        color_highlight = c2,
        label = "Clear form",
        style = :boxed,
        signal = (key_pressed, clear_form)
    )

    @forward_signal tlim bplot key_pressed
    @forward_signal ylim bplot key_pressed

    app_main_loop()
end

function create_plot(t,y,color,tmin,tmax,ymin,ymax)
    io = IOBuffer()
    show(IOContext(io, :color=>true), lineplot(
        t,
        y,
        color = color,
        xlim = (tmin, tmax),
        ylim = (ymin, ymax),
        xlabel = "t",
        ylabel = "f(t)"
    ))
    return String(take!(io))
end

function get_limits(tlim,ylim)
    # Without this, we will have an bad type instability leading to a huge
    # performance hit when ploting data.
    vt = get_data(tlim)
    vy = get_data(ylim)

    if vt[1] == nothing
        t_min = (vt[2] == nothing) ? 0. : parse(Float64, vt[2]) - 1
    else
        t_min = parse(Float64, vt[1])
    end

    if vt[2] == nothing
        t_max = t_min + 1
    else
        t_max = parse(Float64, vt[2])
    end

    if vy[1] == nothing
        y_min = (vy[2] == nothing) ? 0. : parse(Float64, vy[2]) - 1
    else
        y_min = parse(Float64, vy[1])
    end

    if vy[2] == nothing
        y_max = y_min + 1
    else
        y_max = parse(Float64, vy[2])
    end

    return t_min, t_max, y_min, y_max
end

plots()

