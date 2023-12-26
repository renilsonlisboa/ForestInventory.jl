module ForestInventory

include(joinpath(@__DIR__, "AAS.jl"))
include(joinpath(@__DIR__, "Save.jl"))
include(joinpath(@__DIR__, "ImportData.jl"))

# Exporta a função Inventory possibilitando ser chamada via terminal pelo usuário
export Inventory

    using QML, .Save, .ImportData, .AAS, DataFrames, CSV, XLSX

    function singleFile(arg)
        ImportData.singlefile(arg)
    end

    function saveFile(Resultado, uri)
        Save.saveFile(Resultado, uri)
    end

    function calcAAS()
    end

    function Inventory()
        
        @qmlfunction singleFile saveFile calcAAS
        
        current_directory = dirname(@__FILE__)

        loadqml(joinpath(current_directory, "src", "qml", "main.qml"))

        exec()

    end

end