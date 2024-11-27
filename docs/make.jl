using AffineScaler
using Documenter

DocMeta.setdocmeta!(AffineScaler, :DocTestSetup, :(using AffineScaler); recursive=true)

makedocs(;
    modules=[AffineScaler],
    authors="singularitti <singularitti@outlook.com> and contributors",
    sitename="AffineScaler.jl",
    format=Documenter.HTML(;
        canonical="https://singularitti.github.io/AffineScaler.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Manual" => [
            "Installation Guide" => "man/installation.md",
            "Troubleshooting" => "man/troubleshooting.md",
        ],
        "Reference" => Any[
            "Public API" => "lib/public.md",
            # "Internals" => map(
            #     s -> "lib/internals/$(s)",
            #     sort(readdir(joinpath(@__DIR__, "src/lib/internals")))
            # ),
        ],
        "Developer Docs" => [
            "Contributing" => "developers/contributing.md",
            "Style Guide" => "developers/style-guide.md",
            "Design Principles" => "developers/design-principles.md",
        ],
    ],
)

deploydocs(;
    repo="github.com/singularitti/AffineScaler.jl",
    devbranch="main",
)
