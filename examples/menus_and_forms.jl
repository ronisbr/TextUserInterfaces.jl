using Dates
using Printf
using SatelliteToolbox
using UnicodePlots
using TextUserInterfaces

const propagators = Dict("J2"       => Val{:J2},
                         "J4"       => Val{:J4},
                         "Two Body" => Val{:twobody})

function plot_ground_trace(win_plot,win_error,form)
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
            error_color = ncurses_color(:red, :black; bold = true)
            set_color(win_error, error_color)
            window_print(win_error, 2*(i-1)+1, "ERROR!")
            unset_color(win_error, error_color)
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
                          width = COLS()-56,
                          height = 20) |> string

        window_print(win_plot, 1, str)
    end
end

function get_raan(form,win_output,win_error)
    # Make sure we updated the current input.
    form_next_field(form)
    form_prev_field(form)

    clear_window(win_output)
    clear_window(win_error)

    # Get data.
    str_date = get_field_data(form, "date")
    str_lt   = get_field_data(form, "lt")

    date = lt = nothing
    data_ok = zeros(Bool, 2)

    # Try to parse the data and mark the errors.
    try
        date = datetime2julian(DateTime(strip(str_date)))
        data_ok[1] = true
    catch
    end

    try
        lt = parse(Float64, str_lt)
        data_ok[2] = true
    catch
    end

    # Mark the fields with errors.
    for i = 1:length(data_ok)
        if !data_ok[i]
            error_color = ncurses_color(:red, :black; bold = true)
            set_color(win_error, error_color)
            window_print(win_error, 2*(i-1), "ERROR!")
            unset_color(win_error, error_color)
        end
    end

    # Only computes the RAAN if everything is OK.
    if prod(data_ok)
        bold = ncurses_color(bold = true)
        raan = compute_RAAN_lt(date, lt)*180/pi
        raan_str = @sprintf("%7.3f", raan)
        window_print(win_output, 1, 1, "The RAAN is ")
        set_color(win_output, bold)
        window_print(win_output, 1, 14, "$(raan_str)")
        unset_color(win_output, bold)
        window_print(win_output, 1,  21, "º.")
    end
end

function menus_and_forms()
    # Initialize the Text User Interface.
    tui = init_tui()

    # Do not echo the typed characters and do show the cursor.
    noecho()
    curs_set(1)

    # Colors
    # ==========================================================================
    init_color(:light_blue, 700, 700, 1000)
    p0 = ncurses_color(bold = true)
    p1 = ncurses_color(underline = true)
    p2 = ncurses_color(:yellow, :black; bold = true)

    # Windows
    # ==========================================================================

    # Menu
    # --------------------------------------------------------------------------
    win_menu = create_window(LINES()-2, 20, 0, 0; border = true,
                             title = " Menu ", title_color = p0)

    win_menu.on_focus_acquired = (win)->begin
        set_window_title!(win, " Menu "; title_color = p2)
    end

    win_menu.on_focus_released = (win)->begin
        set_window_title!(win, " Menu "; title_color = p0)
    end

    # Ground trace
    # --------------------------------------------------------------------------
    win_gt = create_window(LINES()-2, COLS()-21, 0, 21; border = true,
                           title = " Ground trace ", title_color = p0)

    win_gt.on_focus_acquired = (win)->begin
        set_window_title!(win, " Ground trace "; title_color = p2)
    end

    win_gt.on_focus_released = (win)->begin
        set_window_title!(win, " Ground trace "; title_color = p0)
    end

    # Create the window with the inputs.
    win_gt_inputs = create_window(win_gt, 18, 82, 1, 1; border = false)

    # Create the window to show the errors.
    win_gt_error = create_window(win_gt, 20, 10, 1, 83; border = false)

    # Create the window to show the ground trace.
    win_gt_plot = create_window(win_gt, LINES()-25, COLS()-24, 21, 1; border = false)

    str = scatterplot([0], [0];
                      border = :bold,
                      xlim = (-180,+180),
                      ylim = (-90,+90),
                      xlabel = "Longitude [°]",
                      ylabel = "Latitude [°]",
                      width = COLS()-56,
                      height = 20) |> string

    window_print(win_gt_plot, 1, str)

    # RAAN
    # --------------------------------------------------------------------------

    win_raan = create_window(LINES()-2, COLS()-21, 0, 21; border = true,
                             title = " RAAN ", title_color = p0)

    win_raan.on_focus_acquired = (win)->begin
        set_window_title!(win, " RAAN "; title_color = p2)
    end

    win_raan.on_focus_released = (win)->begin
        set_window_title!(win, " RAAN "; title_color = p0)
    end

    window_print(win_raan, 1, """
                 Compute the right ascension of the ascending node given a date and a desired local time at the Equator crossing.
                 """; pad = 1)

    win_raan_input  = create_window(win_raan, 3, 60, 3, 0; border = false)
    win_raan_error  = create_window(win_raan, 3, 20, 3, 62; border = false)
    win_raan_output = create_window(win_raan, 5, COLS()-23, 7, 0; border = true)

    # Instructions
    # --------------------------------------------------------------------------
    win_inst = create_window(2, COLS(), LINES()-2, 0; border = false)

    # Write the instructions in `bold`.
    set_color(win_inst, p0)
    window_println(win_inst, """
                   Press F1 to exit.
                   Press F2 to change the focus between visible panels.
                   """)

    unset_color(win_inst,p0)

    # Menus
    # ==========================================================================

    # Create the side menu.
    menu = create_menu(["Ground trace"; "RAAN"])
    set_menu_win(menu,win_menu)

    # Action when return is pressed and the menu is in focus.
    menu.on_return_pressed = (menu)->begin
        if current_item_name(menu) == "Ground trace"
            set_focus_chain(win_menu,win_gt)
            force_focus_change(2)
        else
            set_focus_chain(win_menu,win_raan)
            force_focus_change(2)
        end
    end

    # Forms
    # ==========================================================================

    # Ground trace
    # --------------------------------------------------------------------------

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
    enums = ["J2", "J4", "Two Body"]
    set_field_type(form, "prop", Val{:enum}, enums)

    # Post form.
    set_form_win(form, win_gt_inputs)

    form.on_return_pressed = (form)->begin
        plot_ground_trace(win_gt_plot,win_gt_error,form)
    end

    # RAAN
    # --------------------------------------------------------------------------

    ls = 20
    is = 30
    str_now = sprint(print,now())
    fields = [create_field(1, ls, 0,  1,       "Date",               color_background = p0, active = false);
              create_field(1, is, 0,  ls+1,    str_now,"date",       color_background = p1, passok = true);
              create_field(1, ls, 2,  1,       "Desired local time", color_background = p0, active = false);
              create_field(1, is, 2,  ls+1,    "","lt",              color_background = p1, passok = true);]
    form = create_form(fields)

    # Set field types.
    set_field_type(form, "lt", Val{:numeric}, 2, 0, 24)

    # Post form.
    set_form_win(form, win_raan_input)

    form.on_return_pressed = (form)->begin
        get_raan(form, win_raan_output, win_raan_error)
    end

    # Manager
    # ==========================================================================

    refresh_all_windows()

    # Initial focus chain.
    move_window_to_top(win_gt)
    set_focus_chain(win_menu,win_gt)
    init_focus_manager()

    # Wait for a key and process.
    ch,k = jlgetch()

    while k.ktype != :F1
        process_focus(k)
        ch,k = jlgetch()
    end

    destroy_tui()
end

menus_and_forms()
