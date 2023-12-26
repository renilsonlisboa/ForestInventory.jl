module ForestInventory

# Inclui os módulos auxiliares no projeto
include(joinpath(@__DIR__, "AAS.jl"))
include(joinpath(@__DIR__, "Save.jl"))
include(joinpath(@__DIR__, "ImportData.jl"))

# Exporta a função Inventory possibilitando ser chamada via terminal pelo usuário
export Inventory

    # Ativa os pacotes necessários para o programa rodar assim como os módulos auxiliares
    using QML, .Save, .ImportData, .AAS, DataFrames, CSV, XLSX

    # Função para seleção de arquivo em .CSV com dados para processamento
    function singleFile(arg)
        ImportData.singlefile(arg)
    end

    # Função salvar os resultados do processamento em .XLSX
    function saveFile(Resultado, uri)
        Save.saveFile(Resultado, uri)
    end

    # processamento do Inventário por meio da amostragem aleatória simples
    function calcAAS(Dados, Area, AreaParc, α, EAR)
        AAS.calcAAS(Dados, Area, AreaParc, α, EAR)
    end

    # Ativa o programa em QML
    function Inventory()
        
        @qmlfunction singleFile saveFile calcAAS

        current_directory = dirname(@__FILE__)

        loadqml(joinpath(current_directory, "sqml", "main.qml"))

        exec()

    end

end