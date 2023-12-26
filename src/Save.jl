module Save

export saveFile
    
    using QML, DataFrames, CSV, XLSX 

    function saveFile(Dados, uri)

        uri_s = QString(uri)

        # Remover o prefixo "file:///"
        cleaned_path = replace(uri_s, "file:///" => "")

        XLSX.writetable("$(cleaned_path).xlsx",Resultados=(collect(DataFrames.eachcol(Dados)), DataFrames.names(Dados)), overwrite = true) #Exportar para o Excel
    
    end

end