using TextUserInterfaces

function color_container(
    parent::WidgetContainer,
    layout::ObjectLayout,
    text::String,
    decoration::NCursesStyle
)
    c = create_widget(Val(:container), layout)
    add_widget!(parent, c)

    @tui_builder begin
        @tui_label(
            parent = c,
            top_anchor = (:parent, :top),
            left_anchor = (:parent, :left),
            right_anchor = (:parent, :right),
            height = 1,
            fill = true,
            alignment = :c,
            label = text,
        )

        @tui_label(
            parent = c,
            top_anchor = (__LAST__, :bottom),
            left_anchor = (:parent, :left),
            right_anchor = (:parent, :right),
            height = 1,
            fill = true,
            alignment = :c,
            theme = Theme(:default => decoration),
            label = "",
        )
    end

    return c
end

function color_table()
    initialize_tui()

    logger.enabled = true
    logger.level = DEBUG

    ckeys   = keys(TextUserInterfaces._XTERM_COLORS) |> collect
    cvalues = values(TextUserInterfaces._XTERM_COLORS) |> collect

    ids = sortperm(cvalues)

    ckeys = String.(ckeys[ids])
    cvalues = cvalues[ids]

    max_width = maximum(length.(ckeys)) + 2

    w = create_window(
        border = true,
        border_style = :rounded,
        theme  = Theme(:border => ncurses_style(:grey46, :transparent)),
        title  = " Color Table ",
        layout = ObjectLayout(
            bottom_anchor = Anchor(ROOT_WINDOW, :bottom, -3),
            left_anchor   = Anchor(ROOT_WINDOW, :left),
            right_anchor  = Anchor(ROOT_WINDOW, :right),
            top_anchor    = Anchor(ROOT_WINDOW, :top)
        ),
        buffer_size = (52 * 3, 5max_width + 4)
    )

    c = w.widget_container

    prev_widget = nothing

    for i in 1:52, j in 1:5
        id = (i - 1) * 5 + j

        id > length(ckeys) && break

        top_anchor = if isnothing(prev_widget)
            (:parent, :top)
        elseif j == 1
            (prev_widget, :bottom, 1)
        else
            (prev_widget, :top)
        end

        left_anchor = if j == 1
            (:parent, :left)
        else
            (prev_widget, :right, 1)
        end

        decoration = ncurses_style(:black, cvalues[id])

        prev_widget = color_container(
            c,
            ObjectLayout(
                top_anchor  = Anchor(top_anchor...),
                left_anchor = Anchor(left_anchor...),
                width       = max_width,
                height      = 2,
            ),
            string(ckeys[id]),
            decoration
        )
    end

    app_main_loop(; exit_keys = [:F1, "\eq"])
end

color_table()
