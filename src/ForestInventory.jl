module ForestInventory

# Inclui os módulos auxiliares ao escopo principal do projeto
include(joinpath(@__DIR__, "src/AAS.jl")) # Amostragem Aleatória Simples
include(joinpath(@__DIR__, "src/ESTRAT.jl")) # Amostragem Estratificada
include(joinpath(@__DIR__, "src/SIST.jl")) # Amostragem Sistemática
include(joinpath(@__DIR__, "src/DE.jl")) # Amostragem Dois Estágios
include(joinpath(@__DIR__, "src/CONGL.jl")) # Amostragem em Conglomerados
include(joinpath(@__DIR__, "src/MULTI.jl")) # Amostragem co Multíplos Inicios Aleatórios
include(joinpath(@__DIR__, "src/IND.jl")) # Amostragem Individual
include(joinpath(@__DIR__, "src/ART.jl")) # Amostragem com Repetição Total
include(joinpath(@__DIR__, "src/AD.jl")) # Amostragem Dupla
include(joinpath(@__DIR__, "src/ARP.jl"))  # Amostragem com Repetição Parcial
include(joinpath(@__DIR__, "src/Save.jl")) # Função para salvar arquivos de resultados
include(joinpath(@__DIR__, "src/ImportData.jl")) # Função para importar dados .CSV

# Importar as funções utilizadas provenientes do pacote QML
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