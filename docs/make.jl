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
        "Library" => "lib/library.md",
    ],
)

deploydocs(
    repo = "github.com/ronisbr/TextUserInterfaces.jl.git",
    target = "build",
)
