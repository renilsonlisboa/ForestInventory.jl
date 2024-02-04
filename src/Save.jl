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
        elseif i in 6:8
            Dados = convert.(DataFrame, Dados)

            writetable("$(cleaned_path).xlsx", Dados=(collect(eachcol(Dados[1])), 
            names(Dados[1])), Primeira_ocasião=(collect(eachcol(Dados[2])), 
            names(Dados[2])), Segunda_ocasião=(collect(eachcol(Dados[3])), 
            names(Dados[3])), Crescimento_ou_mudança=(collect(eachcol(Dados[4])),   
            names(Dados[4])), overwrite = true) #Exportar para o Excel
        elseif i === 9
            Dados = convert.(DataFrame, Dados)

            writetable(("$(cleaned_path).xlsx"), Dados=(collect(eachcol(Dados[1])), 
            names(Dados[1])), Informações_do_inventário=(collect(eachcol(Dados[2])), 
            names(Dados[2])), Primeira_ocasião=(collect(eachcol(Dados[3])), 
            names(Dados[3])), Segunda_ocasião=(collect(eachcol(Dados[4])),
            names(Dados[4])), Crescimento_ou_mudança=(collect(eachcol(Dados[5])), 
            names(Dados[5])), overwrite = true) #Exportar para o Excel
        else
           println("Deu ruim") 
        end
    end

end