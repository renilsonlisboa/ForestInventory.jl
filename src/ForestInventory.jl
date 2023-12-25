module ForestInventory

include(joinpath(@__DIR__, "src/AAS.jl"))
include(joinpath(@__DIR__, "src/Save.jl"))
include(joinpath(@__DIR__, "src/ImportData.jl"))

# Exporta a função Inventory possibilitando ser chamada via terminal pelo usuário
export Inventory

    using QML, .Save, .ImportData

    function singleFile(arg)
        ImportData.singlefile(arg)
    end

    function Inventory()
        
        @qmlfunction singleFile

        loadqml(joinpath(pwd(), "src\\qml", "main.qml"))

        exec()

    end

end