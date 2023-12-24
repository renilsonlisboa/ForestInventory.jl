module ForestInventory

include(joinpath(@__DIR__, "AAS.jl"))
include(joinpath(@__DIR__, "Save.jl"))
include(joinpath(@__DIR__, "ImportData.jl"))

# Exporta a função Inventory possibilitando ser chamada via terminal pelo usuário
export Inventory

    using QML

    function Inventory()

        loadqml(joinpath(pwd(), "src\\qml", "main.qml"))

        exec()

    end

end
