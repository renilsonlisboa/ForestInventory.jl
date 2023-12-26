module ImportData

export singlefile
    
    using QML, DataFrames, CSV 

    function singlefile(uri)
        
        if uri !== nothing
            uri_s = QString(uri)
        else
            return 0
        end

        # Remover o prefixo "file:///"
        cleaned_path = replace(uri_s, "file:///" => "")
    
        Dados = CSV.read("$cleaned_path", DataFrame)

        return Dados

    end

end