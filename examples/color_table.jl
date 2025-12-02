using TextUserInterfaces

# Create the container that holds the color label and shows a rectangle with the respective
# color.
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
            parent       = c,
            alignment    = :c,
            fill         = true,
            label        = text,
            height       = 1,
            left_anchor  = (:parent, :left),
            right_anchor = (:parent, :right),
            top_anchor   = (:parent, :top),
        )

        @tui_label(
            parent       = c,
            alignment    = :c,
            fill         = true,
            height       = 1,
            label        = "",
            theme        = Theme(:default => decoration),
            left_anchor  = (:parent, :left),
            right_anchor = (:parent, :right),
            top_anchor   = (__LAST__, :bottom),
        )
    end

    return c
end

function color_table()
    initialize_tui()

    logger.enabled = true
    logger.level = DEBUG

    ckeys   = keys(TextUserInterfaces._XTERM_NAMES) |> collect
    cvalues = values(TextUserInterfaces._XTERM_NAMES) |> collect

    ids = sortperm(cvalues)

    ckeys   = ckeys[ids]
    sckeys  = string.(ckeys)
    cvalues = cvalues[ids]

    max_width = maximum(length.(sckeys)) + 2

    # == Main Window =======================================================================

    w = create_window(
        border = true,
        border_style = :rounded,
        theme  = Theme(:border => tui_style(:red, :black)),
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

        decoration = tui_style(:black, ckeys[id])

        prev_widget = color_container(
            c,
            ObjectLayout(
                top_anchor  = Anchor(top_anchor...),
                left_anchor = Anchor(left_anchor...),
                width       = max_width,
                height      = 2,
            ),
            sckeys[id],
            decoration
        )
    end

    # == Bottom Window =================================================================

    # Bottom window to show information.
    bw = create_window(;
        border    = true,
        theme     = Theme(:border => tui_style(:grey46)),
        focusable = false,
        layout    = ObjectLayout(
            bottom_anchor = Anchor(ROOT_WINDOW, :bottom),
            left_anchor   = Anchor(ROOT_WINDOW, :left),
            right_anchor  = Anchor(ROOT_WINDOW, :right),
            height        = 3
        ),
    )

    # Create a bottom window for the information.
    cy  = "\e[33;1m"
    cg  = "\e[38;5;243m"
    cr  = "\e[0m"
    sep = cg * " | " * cr

    @tui_ansi_label(
        parent        = bw.widget_container,
        alignment     = :r,
        bottom_anchor = (:parent, :bottom),
        left_anchor   = (:parent, :left),
        right_anchor  = (:parent, :right),
        top_anchor    = (:parent, :top),
        text          = cy * "[F1 | Alt + q]" * cr * " : Quit"
    )

    app_main_loop(; exit_keys = [:F1, "\eq"])
end

color_table()
