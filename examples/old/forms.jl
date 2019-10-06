using Dates
using SatelliteToolbox
using TextUserInterfaces
using UnicodePlots

const propagators = Dict("J2"       => Val{:J2},
                         "J4"       => Val{:J4},
                         "Two Body" => Val{:twobody})

function satellite_ground_trace()

    # NCurses initialization
    # ==========================================================================

    # Initialize the Text User Interface.
    tui = init_tui()

    # Do not echo the typed characters and do show the cursor.
    noecho()
    curs_set(1)

    # Initialize the colors that will be used.
    init_color(:light_blue, 700, 700, 1000)
    p0 = ncurses_color(bold = false)
    p1 = ncurses_color(bold = true, underline = true)
    p2 = ncurses_color(:yellow, :black)
    p3 = ncurses_color(:red, :black)

    # Create windows
    # ==========================================================================

    # Create the bottom window with the instructions.
    win_inst = create_window(1, COLS(), LINES()-1, 0; border = false)

    set_color(win_inst, p0)
    window_println(win_inst, "Press F1 to exit.")
    unset_color(win_inst, p0)

    # Create the main window.
    win = create_window(LINES()-2, COLS(), 0, 0;
                        border = true, border_color = p2,
                        title = " Satellite Ground Trace ", title_color  = p0)

    # Create the window with the inputs.
    win_inputs = create_window(18, 82, 1, 1; border = false)

    # Create the window to show the errors.
    win_error = create_window(20, 10, 1, 83; border = false)

    # Create the window to show the ground trace.
    win_plot = create_window(30, COLS()-2, 21, 1; border = false)

    str = scatterplot([0], [0];
                      border = :bold,
                      xlim = (-180,+180),
                      ylim = (-90,+90),
                      xlabel = "Longitude [°]",
                      ylabel = "Latitude [°]",
                      width = COLS()-52,
                      height = 20) |> string

    window_print(win_plot, 1, str; pad = 10)

    # Create the input form
    # ==========================================================================

    # Create the form that will receive the inputs.
    ls = 20
    is = 30
    str_now = sprint(print,now())
    fields = [create_field(1, ls, 1,  1,       "Date",            color_background = p0, active = false);
              create_field(1, is, 1,  ls+1,    str_now,"date",    color_background = p1, passok = true);
              create_field(1, ls, 3,  1,       "Semi-major axis", color_background = p0, active = false);
              create_field(1, is, 3,  ls+1,    "","a",            color_background = p1, passok = true);
              create_field(1, is, 3,  is+ls+2, "km",              color_background = p0, active = false);
              create_field(1, ls, 5,  1,       "Eccentricity",    color_background = p0, active = false);
              create_field(1, is, 5,  ls+1,    "","e",            color_background = p1, passok = true);
              create_field(1, ls, 7,  1,       "Inclination",     color_background = p0, active = false);
              create_field(1, is, 7,  ls+1,    "","i",            color_background = p1, passok = true);
              create_field(1, is, 7,  is+ls+2, "°",               color_background = p0, active = false);
              create_field(1, ls, 9,  1,       "RAAN",            color_background = p0, active = false);
              create_field(1, is, 9,  ls+1,    "","Ω",            color_background = p1, passok = true);
              create_field(1, is, 9,  is+ls+2, "°",               color_background = p0, active = false);
              create_field(1, ls, 11, 1,       "Arg. of perigee", color_background = p0, active = false);
              create_field(1, is, 11, ls+1,    "","ω",            color_background = p1, passok = true);
              create_field(1, is, 11, is+ls+2, "°",               color_background = p0, active = false);
              create_field(1, ls, 13, 1,       "True anomaly",    color_background = p0, active = false);
              create_field(1, is, 13, ls+1,    "","f",            color_background = p1, passok = true);
              create_field(1, is, 13, is+ls+2, "°",               color_background = p0, active = false);
              create_field(1, ls, 15, 1,       "Propagator",      color_background = p0, active = false);
              create_field(1, is, 15, ls+1,    "J2","prop",       color_background = p1, passok = true);
              create_field(1, is, 15, is+ls+2, "Two Body, J2, J4",color_background = p0, active = false);
              create_field(1, ls, 17, 1,       "Num. of orbits",  color_background = p0, active = false);
              create_field(1, is, 17, ls+1,    "","span",         color_background = p1, passok = true);]

    form = create_form(fields)

    # Set field types.
    set_field_type(form, "a",    Val{:numeric}, 2, 6400, typemax(Int))
    set_field_type(form, "e",    Val{:numeric}, 6,    0, 1-eps())
    set_field_type(form, "i",    Val{:numeric}, 3, -180, +180)
    set_field_type(form, "Ω",    Val{:numeric}, 3, -180, +180)
    set_field_type(form, "ω",    Val{:numeric}, 3, -180, +180)
    set_field_type(form, "f",    Val{:numeric}, 3, -180, +180)
    set_field_type(form, "prop", Val{:enum},    ["J2", "J4", "Two Body"])

    set_form_win(form, win_inputs)

    form.on_return_pressed = (form)->begin
        # Make sure we updated the current input.
        form_next_field(form)
        form_prev_field(form)

        clear_window(win_error)

        # Get data.
        str_date = get_field_data(form, "date")
        str_a    = get_field_data(form, "a")
        str_e    = get_field_data(form, "e")
        str_i    = get_field_data(form, "i")
        str_Ω    = get_field_data(form, "Ω")
        str_ω    = get_field_data(form, "ω")
        str_f    = get_field_data(form, "f")
        str_prop = rstrip(get_field_data(form, "prop"))
        str_span = get_field_data(form, "span")

        date = a = e = i = Ω = ω = f = orb_prop = span = nothing
        data_ok = zeros(Bool, 9)

        # Try to parse the data and mark the errors.
        try
            date = datetime2julian(DateTime(strip(str_date)))
            data_ok[1] = true
        catch
        end

        try
            a = parse(Float64, str_a)
            data_ok[2] = true
        catch
        end

        try
            e = parse(Float64, str_e)
            (0 <= e < 1) && (data_ok[3] = true)
        catch
        end

        try
            i = parse(Float64, str_i)
            data_ok[4] = true
        catch
        end

        try
            Ω = parse(Float64, str_Ω)
            data_ok[5] = true
        catch
        end

        try
            ω  = parse(Float64, str_ω)
            data_ok[6] = true
        catch
        end

        try
            f = parse(Float64, str_f)
            data_ok[7] = true
        catch
        end

        if haskey(propagators, str_prop)
            orb_prop = propagators[str_prop]
            data_ok[8] = true
        end

        try
            span = parse(Int, str_span)
            (span > 0) && (data_ok[9] = true)
        catch
        end

        # Mark the fields with errors.
        for i = 1:length(data_ok)
            if !data_ok[i]
                set_color(win_error, p3)
                window_print(win_error, 2*(i-1)+1, "ERROR!")
                unset_color(win_error, p3)
            end
        end

        # Only computes the new ground trace if everything is OK.
        if prod(data_ok)
            d2r = π/180
            orbp = init_orbit_propagator(orb_prop, date, a*1000, e,
                                         i*d2r, Ω*d2r, ω*d2r, f*d2r)
            gt = ground_trace(orbp; span = span)

            lat = map(x->x[1]/d2r, gt)
            lon = map(x->x[2]/d2r, gt)

            str = scatterplot(lon, lat;
                              border = :bold,
                              xlim = (-180,+180),
                              ylim = (-90,+90),
                              xlabel = "Longitude [°]",
                              ylabel = "Latitude [°]",
                              width = COLS()-52,
                              height = 20) |> string

            window_print(win_plot, 1, str; pad = 10)
        end
    end

    # Focus manager
    # ==========================================================================

    set_focus_chain(win_inputs)
    init_focus_manager()

    # Main loop
    # ==========================================================================

    # Initial window update.
    refresh()
    refresh_all_windows()
    update_panels()

    # Ready an input and process.
    ch, k = jlgetch()

    while k.ktype != :F1
        process_focus(k)
        ch, k = jlgetch()
    end

    destroy_form(form)
    destroy_tui()
end

satellite_ground_trace()
