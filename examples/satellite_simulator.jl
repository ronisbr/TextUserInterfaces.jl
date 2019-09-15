using SatelliteToolbox
using TextUserInterfaces
using UnicodePlots

function satellite_simulator()
    # Initialize the Text User Interface.
    tui = init_tui()

    # Do not echo the typed characters and do no show the cursor.
    noecho()
    curs_set(0)

    # Initialize the colors that will be used.
    init_color(:light_blue, 700, 700, 1000)
    p0 = ncurses_color(bold = true)
    p1 = ncurses_color(:yellow,     :black, bold = true)
    p2 = ncurses_color(:green,      :black, underline = true)
    p3 = ncurses_color(:light_blue, :black)

    # Create the menu window.
    win_menu = create_window(LINES()-2, 20, 0, 0; border = true, title = " Menu ",
                             border_color = p1, title_color = p1)

    # Do not wait for a key to be pressed. Hence, we can call `jlgetch()`
    # without blocking everything.
    nodelay(win_menu.ptr,true)

    # Create the bottom window with the instructions.
    win_inst = create_window(2, COLS(), LINES()-2, 0; border = false)

    set_color(win_inst, p3)
    window_println(win_inst, """
                   Press ENTER to change the window.
                   Press F1 to exit.
                   """)
    unset_color(win_inst, p3)

    # Latitude and longitude information.
    win_lat_lon  = create_window(LINES()-2, COLS()-20, 0, 20;
                                 border = true, border_color = p1,
                                 title = " Satellite Simulator - Latitude and longitude ",
                                 title_color = p1)

    # Orbital elements information.
    win_orb_elem = create_window(LINES()-2, COLS()-20, 0, 20;
                                 border = true, border_color = p1,
                                 title = " Satellite Simulator - Orbit elements ",
                                 title_color = p1)

    # Create the menu.
    menu = create_menu([" Lat. and Lon. ", " Orbit Elements "]; mark = "")
    set_menu_win(menu,win_menu)

    # Create the panels.
    move_window_to_top(win_lat_lon)

    # Initial window update.
    refresh_all_windows()
    update_panels()

    # Initialize the orbit propagator.
    tle_scd1 = tle"""
    SCD 1
    1 22490U 93009B   18350.91204528  .00000219  00000-0  10201-4 0  9996
    2 22490  24.9683 170.6788 0043029 357.3326 117.9323 14.44539175364603
    """[1];

    orbp = init_orbit_propagator(Val{:sgp4}, tle_scd1);

    # Vectors to store the latitude and longitude.
    lat = Float64[]
    lon = Float64[]

    finished = false

    menu.on_return_pressed = (menu)->begin
        item = current_item(menu)

        if item == menu.items[1]
            move_window_to_top(win_lat_lon)
        else
            move_window_to_top(win_orb_elem)
        end
    end

    # Task to handle the keys
    # ==========================================================================

    @async begin
        set_focus_chain(win_menu)
        init_focus_manager()
        while true
            ch,k = jlgetch(win_menu.ptr)

            if k.ktype == :F1
                finished = true
                break
            else
                process_focus(k)
            end

            yield()
        end
    end

    # Task to update the windows
    # ==========================================================================

    while !finished
        # Propagate the orbit
        # ======================================================================

        o,r_teme,v_teme = step!(orbp, 10)

        r_PEF_TEME      = rECItoECEF(TEME(), PEF(), o.t)
        r_pef           = r_PEF_TEME*r_teme
        lat_k, lon_k, _ = ECEFtoGeodetic(r_PEF_TEME*r_teme)

        push!(lat, rad2deg(lat_k))
        push!(lon, rad2deg(lon_k))

        # Update window: Latitude and longitude
        # ======================================================================

        str = scatterplot(lon, lat;
                          border = :bold,
                          xlim = (-180,+180),
                          ylim = (-90,+90),
                          xlabel = "Longitude [°]",
                          ylabel = "Latitude [°]",
                          width = COLS()-52,
                          height = 20) |> string

        set_color(win_lat_lon, p2)
        window_print(win_lat_lon, 1, "Propagating SCD-1 orbit"; alignment = :c)
        unset_color(win_lat_lon, p2)
        set_color(win_lat_lon, p0)
        window_print(win_lat_lon, 3, str)
        unset_color(win_lat_lon, p0)

        # Update window: Orbit elements
        # ======================================================================

        str = "Semi-major axis: " * string(round(o.a/1000, digits = 3)  ) * " km\n" *
              "   Eccentricity: " * string(round(o.e, digits = 6)       ) * "\n" *
              "    Inclination: " * string(round(o.i*180/pi, digits = 3)) * "°\n" *
              "           RAAN: " * string(round(o.Ω*180/pi, digits = 3)) * "°\n" *
              "Arg. of Perigee: " * string(round(o.ω*180/pi, digits = 3)) * "°\n" *
              "   True anomaly: " * string(round(o.f*180/pi, digits = 3)) * "°"

        set_color(win_orb_elem,p0)
        window_print(win_orb_elem, 2, str; pad = 5)
        unset_color(win_orb_elem,p0)

        refresh_all_windows()
        update_panels()
        doupdate()

        sleep(0.005)
    end

    destroy_tui()
end

satellite_simulator()
