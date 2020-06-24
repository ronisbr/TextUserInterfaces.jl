using Documenter
using TextUserInterfaces

makedocs(
    modules = [TextUserInterfaces],
    format = Documenter.HTML(
        prettyurls = !("local" in ARGS),
        canonical = "https://ronisbr.github.io/TextUserInterfaces.jl/stable/",
    ),
    sitename = "Text User Interfaces",
    authors = "Ronan Arraes Jardim Chagas",
    pages = [
        "Home"    => "index.md",
        "Objects" => Any[
            "Object positioning" => "man/object_positioning.md",
        ],
        "Library" => Any[
            "TextUserInterfaces" => "lib/library.md",
            "NCurses"            => "lib/library_ncurses.md",
        ],
    ],
)

deploydocs(
    repo = "github.com/ronisbr/TextUserInterfaces.jl.git",
    target = "build",
)
