using ForestInventory
using Documenter

DocMeta.setdocmeta!(ForestInventory, :DocTestSetup, :(using ForestInventory); recursive=true)

makedocs(;
    modules=[ForestInventory],
    authors="Renilson Lisboa Júnior <renilsonlisboajunior@gmail.com> and contributors",
    repo="https://github.com/renilsonlisboa/ForestInventory.jl/blob/{commit}{path}#{line}",
    sitename="ForestInventory.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://renilsonlisboa.github.io/ForestInventory.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/renilsonlisboa/ForestInventory.jl",
    devbranch="main",
)
