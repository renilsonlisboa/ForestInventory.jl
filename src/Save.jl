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

        # Remove o sufixo da URL (extensão caso selecionada)
        cleaned_path = split(cleaned_path, ".")[1]

        # Converte os resultados em DADOS e Resultados
        Dados = convert.(DataFrame, Dados)

        # Salva a tabela de resultado no PATH selecionado pelo usuário
        if i === 0
            writetable("$(cleaned_path).xlsx", Dados=(collect(eachcol(Dados[1])), 
            names(Dados[1])), Resultados=(collect(eachcol(Dados[2])),
            names(Dados[2])), overwrite = true) #Exportar para o Excel
        elseif i === 1
            XLSX.writetable(("$(cleaned_path).xlsx"), Dados=(collect(eachcol(Dados[1])), 
            names(Dados[1])), Informações_do_inventário=(collect(eachcol(Dados[2])), 
            names(Dados[2])), Por_estrato=(collect(eachcol(Dados[3])), 
            names(Dados[3])), Anova_da_estratificação=(collect(eachcol(Dados[4])), 
            names(Dados[4])), Resultados=( collect(eachcol(Dados[5])), 
            names(Dados[5]))) #Export to Excel
        elseif i === 6
            writetable("$(cleaned_path).xlsx", Dados=(collect(eachcol(Dados[1])), 
            names(Dados[1])), Primeira_ocasião=(collect(eachcol(Dados[2])), 
            names(Dados[2])), Segunda_ocasião=(collect(eachcol(Dados[3])), 
            names(Dados[3])), Crescimento_ou_mudança=(collect(eachcol(Dados[4])),   
            names(Dados[4])), overwrite = true) #Exportar para o Excel
        elseif i === 9
            writetable(("$(cleaned_path).xlsx"), Dados=(collect(eachcol(Dados[1])), 
            names(Dados[1])), Informações_do_inventário=(collect(eachcol(Dados[2])), 
            names(Dados[2])), Primeira_ocasião=(collect(eachcol(Dados[3])), 
            names(Dados[3])), Segunda_ocasião=(collect(eachcol(Dados[4])),
            names(Dados[4])), Crescimento_ou_mudança=(collect(eachcol(Dados[5])), 
            names(Dados[5])), overwrite = true) #Exportar para o Excel
        else
           error("Método para salvar resultados não definido")
           return 0
        end
    end
end