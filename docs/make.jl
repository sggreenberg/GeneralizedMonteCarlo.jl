using Pkg
pkg"activate .."
push!(LOAD_PATH, "../src/")

using Documenter, GeneralizedMonteCarlo

makedocs(
    sitename = "Generalized Monte Carlo",
    modules = [GeneralizedMonteCarlo],
    authors = "Scott Greenberg",
    pages = [
        "index.md",
    ]
)
