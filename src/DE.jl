module DE

export calcDE

    import DataFrames: DataFrame, transform, AsTable, ByRow
    import Statistics: mean, var, std
    import Distributions: TDist, quantile
    import CSV: CSV.read

    function calcDE(Dados,  Area, AreaParc, α, EAR, M) #Determina a função

        Area = Float64(Meta.parse(Area))
        AreaParc = Float64(Meta.parse(AreaParc))
        α = Float64(Meta.parse(α))
        EAR = Float64(Meta.parse(EAR))
        M = Float64(Meta.parse(M))

        N = Area

        Conversor = 10000/AreaParc

        Conjunto_de_dados = (Conversor.*Dados)

        #Tabela com estatítica descritiva por unidade secundária/bloco
        Tabela=transform(Conjunto_de_dados, AsTable(:) .=> ByRow.([I -> count(!ismissing, I), sum, mean, var]).=>[:n, :Soma, :Média, :Variância])

        if 1-(length(Tabela.n)/N) ≥ 0.98 #f maior ou igual a 0,98 população infinita
            População = "A população avaliada é considerada infinita"   
        elseif 1-(length(Tabela.n)/N) < 0.98 #f menor que 0,98 população finita
            População = "A população avaliada é considerada finita"    
        end
        
        Tamanho_da_amostra = if 1-(length(Tabela.n)/N) ≥ 0.98
             #População infinita. O tamanho da amostra é calculado pela seguinte equação:
             Infinita=((quantile(TDist(length(Tabela.n)-1),1-α/2))^2)*((sum(first(unique(Tabela.n))*
            (Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
            (length(Tabela.n)-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
            (first(unique(Tabela.n))-1)))/first(unique(Tabela.n))+(sum(Tabela.Variância*(first(unique(Tabela.n))-1))/
            (length(Tabela.n)*(first(unique(Tabela.n))-1))/first(unique(Tabela.n))))/
            (((0.1*(sum(Tabela.Média)/length(Tabela.n))))^2)
            round(Infinita)
        elseif 1-(length(Tabela.n)/N) < 0.98
             #População finita. O tamanho da amaostra é calculado pela seguinte equação:
             Finita=((quantile(TDist(length(Tabela.n)-1),1-α/2))^2)*((sum(first(unique(Tabela.n))*
            (Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
            (length(Tabela.n)-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
            (first(unique(Tabela.n))-1)))/first(unique(Tabela.n))+(sum(Tabela.Variância*(first(unique(Tabela.n))-1))/
            (length(Tabela.n)*(first(unique(Tabela.n))-1))./first(unique(Tabela.n))))/
            ((((0.1*(sum(Tabela.Média)/length(Tabela.n))))^2)+(1/N)*((quantile(TDist(length(Tabela.n)-1),1-α/2))^2)*
            ((sum(first(unique(Tabela.n))*(Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
            ((length(Tabela.n))-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
            (first(unique(Tabela.n))-1)))/first(unique(Tabela.n))+(sum(Tabela.Variância*(first(unique(Tabela.n))-1))/
            (length(Tabela.n)*(first(unique(Tabela.n))-1))/M)))
            round(Finita)
        end
        
        if (quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N)*((sum(first(unique(Tabela.n))*
            (Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
            (length(Tabela.n)-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
            (first(unique(Tabela.n))-1)))/first(unique(Tabela.n))/length(Tabela.n))+
            ((M-first(unique(Tabela.n)))/M)*(sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
            (first(unique(Tabela.n))-1))/(length(Tabela.n)*first(unique(Tabela.n))))))/
            (sum(Tabela.Média)/length(Tabela.n)))*100 > EAR
            Observação = "Diante do exposto, conclui-se que os resultados obtidos na amostragem não satisfazem as exigências de precisão estabelecidas para o inventário, ou seja, um erro de amostragem máximo de ±$(Int(EAR))% da média  para confiabilidade designada. \n\nO erro estimado foi maior que o limite fixado, sendo recomendado incluir mais unidades amostrais no inventário."
        elseif (quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N)*((sum(first(unique(Tabela.n))*
            (Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
            (length(Tabela.n)-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
            (first(unique(Tabela.n))-1)))/first(unique(Tabela.n))/length(Tabela.n))+
            ((M-first(unique(Tabela.n)))/M)*(sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
            (first(unique(Tabela.n))-1))/(length(Tabela.n)*first(unique(Tabela.n))))))/
            (sum(Tabela.Média)/length(Tabela.n)))*100 ≤ EAR
            Observação  = "Diante do exposto, conclui-se que os resultados obtidos na amostragem satisfazem as exigências de precisão estabelecidas para o inventário, ou seja, um erro de amostragem máximo de ±$(Int(EAR))% da média para confiabilidade designada. \n\nO erro estimado foi menor que o limite fixado, assim as unidades amostrais são suficientes para o inventário."
        end  

        Resultados = DataFrame(Variânciaiáveis=["Média (m³/ha)", "Limite inferior do intervalo de confiança para média (m³/ha)", 
        "Limite superior do intervalo de confiança para média (m³/ha)", "Total da população (m³)", "Limite inferior do intervalo de confiança para o total (m³)", 
        "Limite superior do intervalo de confiança para o total (m³)", "Área da população (ha)", "Erro da amostragem relativo (%)", 
        "Erro da amostragem absoluto (m³/ha)", "Erro padrão (m³/ha)", "Variância dentro das unidades (m³/ha)²", "Variância entre unidades (m³/ha)²", 
        "Estimativa da Variância (m³/ha)²", "Variância da média da população (m³/ha)²", "Limite do erro de amostragem requerido", 
        "Fator de correção", "População", "Tamanho da amostra", "Número total de unidades secundárias por unidade primária", "Número potencial de unidades primárias", 
        "Número de unidades primárias", "Número de unidades secundárias", "Nível de significância (α)", "Observação"], Valores=[(sum(Tabela.Média)/length(Tabela.n)), 
        ((sum(Tabela.Média)/length(Tabela.n))-quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N)*
        ((sum(first(unique(Tabela.n))*(Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
        (length(Tabela.n)-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1)))/first(unique(Tabela.n))/length(Tabela.n))+
        ((M-first(unique(Tabela.n)))/M)*(sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1))/
        (length(Tabela.n)*first(unique(Tabela.n))))))),
        
        ((sum(Tabela.Média)/length(Tabela.n))+quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N)*
        ((sum(first(unique(Tabela.n))*(Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
        (length(Tabela.n)-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1)))/first(unique(Tabela.n))/length(Tabela.n))+
        ((M-first(unique(Tabela.n)))/M)*(sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1))/(length(Tabela.n)*first(unique(Tabela.n))))))), 
        ((N*M*sum(Tabela.Média)/length(Tabela.n))/Conversor), 
        (((N*M*sum(Tabela.Média)/length(Tabela.n))-(N*M*quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N)*
        ((sum(first(unique(Tabela.n))*(Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
        (length(Tabela.n)-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1)))/first(unique(Tabela.n))/length(Tabela.n))+
        ((M-first(unique(Tabela.n)))/M)*(sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1))/(length(Tabela.n)*first(unique(Tabela.n))))))))/Conversor),
        (((N*M*sum(Tabela.Média)/length(Tabela.n))+(N*M*quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N)*
        ((sum(first(unique(Tabela.n))*(Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
        (length(Tabela.n)-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1)))/first(unique(Tabela.n))/length(Tabela.n))+
        ((M-first(unique(Tabela.n)))/M)*(sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1))/
        (length(Tabela.n)*first(unique(Tabela.n))))))))/Conversor), Area, 
        (quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N)*((sum(first(unique(Tabela.n))*
        (Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
        (length(Tabela.n)-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1)))/first(unique(Tabela.n))/length(Tabela.n))+
        ((M-first(unique(Tabela.n)))/M)*(sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1))/(length(Tabela.n)*first(unique(Tabela.n))))))/
        (sum(Tabela.Média)/length(Tabela.n)))*100, quantile(TDist(length(Tabela.n)-1),1-α/2)*sqrt((((N-length(Tabela.n))/N)*((sum(first(unique(Tabela.n))*
        (Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
        (length(Tabela.n)-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/
        (length(Tabela.n)*(first(unique(Tabela.n))-1)))/first(unique(Tabela.n))/length(Tabela.n))+
        ((M-first(unique(Tabela.n)))/M)*(sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1))/(length(Tabela.n)*first(unique(Tabela.n)))))), sqrt((((N-length(Tabela.n))/N)*((sum(first(unique(Tabela.n))*(Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
        (length(Tabela.n)-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1)))/first(unique(Tabela.n))/length(Tabela.n))+
        ((M-first(unique(Tabela.n)))/M)*(sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1))/(length(Tabela.n)*first(unique(Tabela.n)))))), 
        sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*(first(unique(Tabela.n))-1))/Conversor, 
        (sum(first(unique(Tabela.n))*(Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
        (length(Tabela.n)-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1)))/first(unique(Tabela.n))/Conversor, (((sum(first(unique(Tabela.n))*(Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
        (length(Tabela.n)-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1)))/first(unique(Tabela.n))/Conversor)+
        (sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*(first(unique(Tabela.n))-1))/Conversor)), 
        (((N-length(Tabela.n))/N)*((sum(first(unique(Tabela.n))*(Tabela.Média.-(sum(Tabela.Média)/length(Tabela.n))).^2)/
        (length(Tabela.n)-1)-sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*
        (first(unique(Tabela.n))-1)))/first(unique(Tabela.n))/length(Tabela.n))+((M-first(unique(Tabela.n)))/M)*
        (sum(Tabela.Variância*(first(unique(Tabela.n))-1))/(length(Tabela.n)*(first(unique(Tabela.n))-1))/
        (length(Tabela.n)*first(unique(Tabela.n)))))/Conversor, (0.1*(sum(Tabela.Média)/length(Tabela.n))), 1-(length(Tabela.n)/N), População, Tamanho_da_amostra,  
        M, N, length(Tabela.n), first(unique(Tabela.n)), α, Observação]) #Tabela de resultados  
        
        Resultados = [Conjunto_de_dados, Tabela, Resultados]

        return [Resultados, População, Observação]
    end
end