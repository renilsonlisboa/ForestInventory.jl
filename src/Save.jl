module Save
        
    # Ativa os pacotes usados para a função saveFile funcionar
    import QML: QString
    import DataFrames: DataFrame, eachcol, names
    import CSV: CSV.read
    import XLSX: XLSX.writetable 

    # Exporta as funções definidas nesse módulo
    export saveFile

    # Define a função  saveFile usada para salvar o arquivo de resultado
    function saveFile(Dados, uri, i)
        
        if uri !== nothing
            uri_s = QString(uri)
        else
            return 0
        end

        # Converte a entrada em QString do QML em String do Julia
        uri_s = QString(uri)

        # Remover o prefixo "file:///"
        cleaned_path = replace(uri_s, "file:///" => "")

        # Salva a tabela de resultado no PATH selecionado pelo usuário
        if i in 0:5
            writetable("$(cleaned_path).xlsx",Resultados=(collect(eachcol(Dados)), names(Dados)), overwrite = true) #Exportar para o Excel
        elseif i in 6:10
            XLSX.writetable(("$(cleaned_path).xlsx"), Dados=(collect(DataFrames.eachcol(Independente)), 
            DataFrames.names(Independente)), Primeira_ocasião=(collect(DataFrames.eachcol(Primeira_ocasião)), 
            DataFrames.names(Primeira_ocasião)), Segunda_ocasião=(collect(DataFrames.eachcol(Segunda_ocasião)), 
            DataFrames.names(Segunda_ocasião)), Crescimento_ou_mudança=(collect(DataFrames.eachcol(Mudança_crescimento)),   
            DataFrames.names(Mudança_crescimento))) #Exportar para o Excel
        end
    
    end

end