module CONGL

export calcCONGL

    import DataFrames: DataFrame, transform, AsTable, ByRow
    import Statistics: mean, var, std
    import Distributions: TDist, quantile
    import CSV: CSV.read

    function calcCONGL(Dados, Area, AreaParc, α, EAR) #Determinar função

        Area = Float64(Meta.parse(Area))
        AreaParc = Float64(Meta.parse(AreaParc))
        α = Float64(Meta.parse(α))
        EAR = Float64(Meta.parse(EAR))

        N = (Area*10000)

        Conversor = 10000/AreaParc

        Conjunto_de_dados = (Conversor.*Dados)

        #Tabela com estatítica descritiva por unidades/blocos secundários
        Tabela=transform(Conjunto_de_dados, AsTable(:) .=> ByRow.([I -> count(!ismissing, I), sum, mean, var]).=>[:n, :Soma, :Média, :Variância])
        
        if (quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N))*(((sum(first(unique(Tabela.n)).*
            (Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/(length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/
            (length(Tabela.n)*(first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))/length(Tabela.n))+
            (sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*(first(unique(Tabela.n)).-1))./
            (length(Tabela.n)*first(unique(Tabela.n))))))/(sum(Tabela.Média)/(length(Tabela.n))))*100 > EAR
            Observação = "Diante do exposto, conclui-se que os resultados obtidos na amostragem não satisfazem as exigências de precisão estabelecidas para o inventário, ou seja, um erro de amostragem máximo de $(Int(EAR))% da média  para confiabilidade designada. \n\nO erro estimado foi maior que o limite fixado, sendo recomendado incluir mais unidades amostrais no inventário."
        elseif (quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N))*(((sum(first(unique(Tabela.n)).*
            (Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/(length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/
            (length(Tabela.n)*(first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))/length(Tabela.n))+
            (sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*(first(unique(Tabela.n)).-1))./
            (length(Tabela.n)*first(unique(Tabela.n))))))/(sum(Tabela.Média)/(length(Tabela.n))))*100 ≤ EAR
            Observação  = "Diante do exposto, conclui-se que os resultados obtidos na amostragem satisfazem as exigências de precisão estabelecidas para o inventário, ou seja, um erro de amostragem máximo de ±$(Int(EAR))% da média para confiabilidade designada. \n\nO erro estimado foi menor que o limite fixado, assim as unidades amostrais são suficientes para o inventário."
        end   

        Resultados = DataFrame(Variáveis=["Média (m³/ha)", "Limite inferior do intervalo de confiança para média (m³/ha)", 
        "Limite superior do intervalo de confiança para média (m³/ha)", "Total da população (m³)", "Limite inferior do intervalo de confiança para o total (m³)", 
        "Limite superior do intervalo de confiança para o total (m³)", "Área da população (ha)", "Erro padrão relativo (%)", "Erro da amostragem absoluto (m³/ha)", "Erro padrão (m³/ha)",
        "Variância dentro dos conglomerados (m³/ha)²", "Variância entre conglomerados (m³/ha)²", "Variância da população por subunidade (m³/ha)²", 
        "Variância da população total (m³/ha)²", "Variância da média (m³/ha)²", "Coeficiente de correlação intraconglomerados", "Tamanho da amostra",
        "Limite do erro de amostragem requerido", "Número de unidades primárias", "Número de unidades secundarias", "Nível de significância (α)", "Observação"], 
        Valores=[sum(Tabela.Média)/(length(Tabela.n)), ((sum(Tabela.Média)/(length(Tabela.n)))-(quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N))*
        (((sum(first(unique(Tabela.n)).*(Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/(length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*
        (first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))/length(Tabela.n))+(sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*
        (first(unique(Tabela.n)).-1))./(length(Tabela.n)*first(unique(Tabela.n))))))/(sum(Tabela.Média)/(length(Tabela.n))))*100), (sum(Tabela.Média)/(length(Tabela.n)))+(quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N))*
        (((sum(first(unique(Tabela.n)).*(Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/(length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*
        (first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))/length(Tabela.n))+(sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/
        (length(Tabela.n)*(first(unique(Tabela.n)).-1))./(length(Tabela.n)*first(unique(Tabela.n))))))), ((N*(first(unique(Tabela.n)))*
        (sum(Tabela.Média)/(length(Tabela.n))))/Conversor), (((N*(first(unique(Tabela.n)))*(sum(Tabela.Média)/(length(Tabela.n))))-
        ((N*first(unique(Tabela.n)))*quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N))*
        (((sum(first(unique(Tabela.n)).*(Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/
        (length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*
        (first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))/length(Tabela.n))+(sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/
        (length(Tabela.n)*(first(unique(Tabela.n)).-1))./(length(Tabela.n)*first(unique(Tabela.n))))))))/Conversor), (((N*(first(unique(Tabela.n)))*
        (sum(Tabela.Média)/(length(Tabela.n))))+((N*first(unique(Tabela.n)))*quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N))*
        (((sum(first(unique(Tabela.n)).*(Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/
        (length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*
        (first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))/length(Tabela.n))+(sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/
        (length(Tabela.n)*(first(unique(Tabela.n)).-1))./(length(Tabela.n)*first(unique(Tabela.n))))))))/Conversor), Area, 
        (quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N))*(((sum(first(unique(Tabela.n)).*
        (Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/(length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/
        (length(Tabela.n)*(first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))/length(Tabela.n))+
        (sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*(first(unique(Tabela.n)).-1))./
        (length(Tabela.n)*first(unique(Tabela.n))))))/(sum(Tabela.Média)/(length(Tabela.n))))*100, quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N))*(((sum(first(unique(Tabela.n)).*
        (Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/(length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/
        (length(Tabela.n)*(first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))/length(Tabela.n))+
        (sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*(first(unique(Tabela.n)).-1))./(length(Tabela.n)*first(unique(Tabela.n)))))), 
        sqrt((((N-length(Tabela.n))/N))*(((sum(first(unique(Tabela.n)).*(Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/
        (length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*(first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))/length(Tabela.n))+
        (sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*(first(unique(Tabela.n)).-1))./(length(Tabela.n)*first(unique(Tabela.n)))))), 
        sum(Tabela.Variância/length(Tabela.n))/Conversor, (((sum(first(unique(Tabela.n)).*(Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/
        (length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*(first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))))/Conversor, 
        (sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*(first(unique(Tabela.n)).-1))+(sum(first(unique(Tabela.n)).*(Tabela.Média.-sum(Tabela.Média)/
        (length(Tabela.n))).^2)/(length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*
        (first(unique(Tabela.n)).-1)))./first(unique(Tabela.n)))/Conversor, ((((sum(first(unique(Tabela.n)).*(Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/
        (length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*
        (first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))))/Conversor)+(sum(Tabela.Variância/length(Tabela.n))/Conversor), (((N-length(Tabela.n))/N))*((((sum(first(unique(Tabela.n)).*(Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/
        (length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*(first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))))/Conversor)/
        (length(Tabela.n))+(sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*(first(unique(Tabela.n)).-1))/Conversor)./
        (length(Tabela.n)*first(unique(Tabela.n))), (sum(first(unique(Tabela.n)).*(Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/
        (length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*(first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))/
        ((sum(first(unique(Tabela.n)).*(Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/(length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/
        (length(Tabela.n)*(first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))+sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/
        (length(Tabela.n)*(first(unique(Tabela.n)).-1))), round(((((quantile(TDist(length(Tabela.n)-1),1-α/2))^2)*(sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*
        (first(unique(Tabela.n)).-1))+(sum(first(unique(Tabela.n)).*(Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/(length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/
        (length(Tabela.n)*(first(unique(Tabela.n)).-1)))./first(unique(Tabela.n)))))./((((0.1*sum(Tabela.Média)/(length(Tabela.n)))).^2).*(first(unique(Tabela.n))))).*(1+(sum(first(unique(Tabela.n)).*(Tabela.Média.-sum(Tabela.Média)/
        (length(Tabela.n))).^2)/(length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*(first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))/
        ((sum(first(unique(Tabela.n)).*(Tabela.Média.-sum(Tabela.Média)/(length(Tabela.n))).^2)/(length(Tabela.n)-1).-sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/
        (length(Tabela.n)*(first(unique(Tabela.n)).-1)))./first(unique(Tabela.n))+sum(Tabela.Variância.*(first(unique(Tabela.n)).-1))/(length(Tabela.n)*(first(unique(Tabela.n)).-1)))'*
        (first(unique(Tabela.n)).-1)), (0.1*sum(Tabela.Média)/(length(Tabela.n))), length(Tabela.n), first(unique(Tabela.n)), α, Observação]) #Tabela de resultados  
        
        Resultados = [Conjunto_de_dados, Tabela, Resultados]

        return [Resultados, Observação]

    end
end