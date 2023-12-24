module ForestInventory

import AAS

export Inventory

    using QML

    function Inventory()

        loadqml(joinpath(pwd(), "src\\qml", "main.qml"))

        exec()

    end

end
