module ForestInventory

export Inventory

    using QML

    function Inventory()

        loadqml(joinpath(pwd(), "src\\qml", "main.qml"))

        exec()

    end

end
