module Save

export saveFile
    
    using QML, DataFrames, CSV, XSLX 

    function saveFile(uri::DataFrame)

        XLSX.writetable("resultado.xlsx",Resultados=(collect(DataFrames.eachcol(Resultados)), DataFrames.names(Resultados)), overwrite = true) #Exportar para o Excel
        # Remover o prefixo "file:///"

    end

end