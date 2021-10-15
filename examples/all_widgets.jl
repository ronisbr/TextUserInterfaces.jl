using TextUserInterfaces

logger.enabled = true
logger.level = 3

function windows_and_widgets()
    init_tui()
    NCurses.noecho()

    p0 = ncurses_color(bold = false)
    p1 = ncurses_color(bold = true)
    p2 = ncurses_color(:yellow, :black)
    p3 = ncurses_color(:black, :white)

    w,c  = create_window_with_container(
        border = true,
        title = "All widgets"
    )

    label = @tui_label(
        parent = c,
        left = 0,
        top = 0,
        text = "This is a label."
    )

    ansi_label = @tui_ansi_label(
        parent = c,
        anchor_left = (label, :left),
        anchor_top = (label, :bottom),
        text = "\e[33m\e[1mThis is an ANSI label."
    )

    button_c = @tui_container(
        parent = c,
        border = true,
        anchor_left = (label, :left),
        anchor_right = (:parent, :right),
        anchor_top = (ansi_label, :bottom),
        height = 3
    )

    button_1 = @tui_button(
        parent = button_c,
        left = 1,
        top = 1,
        label = "Button 1"
    )

    button_2 = @tui_button(
        parent = button_c,
        anchor_left = (button_1, :right, 1),
        anchor_top = (button_1, :top),
        label = "Button 2"
    )

    button_3 = @tui_button(
        parent = button_c,
        anchor_left = (button_2, :right, 1),
        anchor_top = (button_2, :top),
        label = "Button 3"
    )

    canvas = @tui_canvas(
        parent = c,
        anchor_bottom = (:parent, :bottom),
        anchor_right = (:parent, :right),
        num_columns = 10,
        num_rows = 4
    )

    canvas.chars[1, 1:end] .= ["", "", "C", "A", "N", "V", "A", "S", "", ""]
    canvas.chars[2:end, 1:end] .= string.(rand(0:9, 3, 10))

    combo_box = @tui_combo_box(
        parent = c,
        anchor_right = (:parent, :right),
        anchor_top = (:parent, :top),
        data = ["Data $i" for i = 1:20]
    )

    linput_field = @tui_label(
        parent = c,
        anchor_left = (label, :left),
        anchor_top = (button_c, :bottom, 1),
        text = "Input field"
    )

    input_field = @tui_input_field(
        parent = c,
        anchor_left = (linput_field, :right),
        anchor_right = (:parent, :right),
        anchor_top = (button_c, :bottom),
        border = true
    )

    list_box = @tui_list_box(
        parent = c,
        anchor_left = (label, :left),
        anchor_top = (input_field, :bottom),
        height = 5,
        width = 20,
        data = ["Data $i" for i = 1:20]
    )

    radio_button_c = @tui_container(
        parent = c,
        border = true,
        anchor_left = (label, :left),
        anchor_right = (:parent, :right),
        anchor_top = (list_box, :bottom),
        height = 5
    )

    progress_bar = @tui_progress_bar(
        parent = c,
        anchor_left = (label, :left),
        anchor_top = (radio_button_c, :bottom),
        anchor_right = (:parent, :right)
    )

    @tui_horizontal_line(
        parent = c,
        anchor_left = (:parent, :left),
        anchor_right = (:parent, :right),
        anchor_top = (progress_bar, :bottom),
    )

    function update_progress_bar(radio_button)
        v = parse(Int, radio_button.label)
        change_value!(progress_bar, v)
    end

    radio_i = nothing

    for i = 1:2
        anchor_left = i == 1 ?
            Anchor(:parent, :left, 0) :
            Anchor(radio_i, :right, 0)

        radio_i = @tui_radio_button(
            parent = radio_button_c,
            anchor_left = anchor_left,
            anchor_top = (:parent, :top),
            width = 10,
            label = "$((i - 1) * 60)"
        )

        @connect_signal radio_i return_pressed update_progress_bar

        radio_j = radio_i

        for j = 2:3
            radio_j = @tui_radio_button(
                parent = radio_button_c,
                anchor_left = (radio_j, :left),
                anchor_top = (radio_j, :bottom),
                width = 10,
                label = "$((i - 1) * 60 + (j - 1) * 20)"
            )

            @connect_signal radio_j return_pressed update_progress_bar
        end
    end

    app_main_loop()
end

windows_and_widgets()
