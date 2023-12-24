module ForestInventory

# Importa os módulos auxiliares para cálculos e funções
import AAS, Save, ImportData

# Exporta a função Inventory possibilitando ser chamada via terminal pelo usuário
export Inventory

    using QML

    function Inventory()

        loadqml(joinpath(pwd(), "src\\qml", "main.qml"))

        exec()

    end

end
