module ImportData

export singlefile
    
    using QML, DataFrames, CSV 

    function singlefile(uri)
        
        uri_s = QString(uri)

        # Remover o prefixo "file:///"
        cleaned_path = replace(uri_s, "file:///" => "")
    
        Dados = CSV.read("$cleaned_path", DataFrame)

        if typeof(Dados) == DataFrame
            println("Funcionou")
        else
            println("faio")
        end

        return Dados

    end

end