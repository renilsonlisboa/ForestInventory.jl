module ForestInventory

# Inclui os módulos auxiliares no projeto
include(joinpath(@__DIR__, "src/AAS.jl"))
include(joinpath(@__DIR__, "src/SIST.jl"))
include(joinpath(@__DIR__, "src/Save.jl"))
include(joinpath(@__DIR__, "src/ImportData.jl"))


import QML: QString, @qmlfunction, loadqml, exec

# Exporta a função Inventory possibilitando ser chamada via terminal pelo usuário
export Inventory

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

    # processamento do Inventário por meio da amostragem aleatória simples
    function calcSIST(Dados, Area, AreaParc, α, EAR)
        SIST.calcSIST(Dados, Area, AreaParc, α, EAR)
    end
    
    # Ativa o programa em QML
    function Inventory()
        
        @qmlfunction singleFile saveFile calcAAS calcSIST

        current_directory = dirname(@__FILE__)

        loadqml(joinpath(current_directory, "src/qml", "main.qml"))

        exec()

    end

end