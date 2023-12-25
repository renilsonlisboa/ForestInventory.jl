module Save

export saveFile
    
    using QML, DataFrames, CSV, XSLX 

    function saveFile(uri::DataFrame)

        XLSX.writetable(("C:/users/renil/.julia/dev/ForestInventory/resultado.xslx"), collect(DataFrames.eachcol(uri)), DataFrames.names(uri), overwrite = true) #Exportar para o Excel
        # Remover o prefixo "file:///"

    end

end