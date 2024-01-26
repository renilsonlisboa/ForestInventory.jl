module ForestInventory

# Inclui os módulos auxiliares no projeto
include(joinpath(@__DIR__, "src/AAS.jl"))
include(joinpath(@__DIR__, "src/ESTRAT.jl"))
include(joinpath(@__DIR__, "src/SIST.jl"))
include(joinpath(@__DIR__, "src/DE.jl"))
include(joinpath(@__DIR__, "src/CONGL.jl"))
include(joinpath(@__DIR__, "src/MULTI.jl"))
include(joinpath(@__DIR__, "src/IND.jl"))
include(joinpath(@__DIR__, "src/ART.jl"))
include(joinpath(@__DIR__, "src/AD.jl"))
include(joinpath(@__DIR__, "src/ARP.jl")) 
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

    # processamento do Inventário por meio da amostragem aleatória sistemática
    function calcSIST(Dados, Area, AreaParc, α, EAR)
        SIST.calcSIST(Dados, Area, AreaParc, α, EAR)
    end

    # processamento do Inventário por meio da amostragem aleatória dois estágios
    function calcDE(Dados, Area, AreaParc, α, EAR, M)
        DE.calcDE(Dados, Area, AreaParc, α, EAR, M)
    end

    # processamento do Inventário por meio da amostragem em conglomerados
    function calcCONGL(Dados, Area, AreaParc, α, EAR)
        CONGL.calcCONGL(Dados, Area, AreaParc, α, EAR)
    end

    # processamento do Inventário por meio da amostragem sistemática com múltiplos inícios aleatórios
    function calcMULTI(Dados, Area, AreaParc, α, EAR)
        MULTI.calcMULTI(Dados, Area, AreaParc, α, EAR)
    end
    
    # Função de inicialização do programa em QML
    function Inventory()
        
        # Exporta as funções do Julia para o QML
        @qmlfunction singleFile saveFile calcAAS calcSIST calcDE calcCONGL calcMULTI

        # Obtém o diretório atual
        current_directory = dirname(@__FILE__)

        # Localiza e carrega o arquivo de base QML
        loadqml(joinpath(current_directory, "src/qml", "main.qml"))

        # Executa o arquivo QML carregado no comando anterior
        exec()

    end

end