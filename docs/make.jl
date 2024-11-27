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
    ],
)

deploydocs(;
    repo="github.com/singularitti/AffineScaler.jl",
    devbranch="main",
)
