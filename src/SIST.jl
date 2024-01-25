module SIST

export calcSIST

    using DataFrames, Statistics, Distributions, CSV, XLSX #Habilitar pacotes

    function calcSIST(Dados, Area, AreaParc, α, EAR) #Determinar função

        Area = Float64(Meta.parse(Area))
        AreaParc = Float64(Meta.parse(AreaParc))
        α = Float64(Meta.parse(α))
        EAR = Float64(Meta.parse(EAR))

        N = (Area*10000)/AreaParc
        Conversor = 1/AreaParc

        Conjunto_de_dados = (Conversor.*Dados)
        #Tabela com estatítica descritiva por unidade secundária/bloco
        Tabela=transform(Conjunto_de_dados, AsTable(:) .=> ByRow.([I -> count(!ismissing, I), sum, mean, var]).=>[:n, :Soma, :Média, :Variância])

        m=length(Tabela.n) #Número de faixas
        nj=first(unique((Tabela.n))) #Número de unidades
        n=(length(Tabela.n)*first(unique((Tabela.n)))) #Número de unidades amostrais totais
        
        if (1-((length(Tabela.n)*first(unique((Tabela.n))))/N)) ≥ 0.98 #f maior ou igual a 0,98 população infinita
            População = "A população avalaida é considerada infinita"   
        elseif (1-((length(Tabela.n)*first(unique((Tabela.n))))/N)) < 0.98 #f menor que 0,98 população finita
            População = "A população avaliada é considerada finita"    
        end
        
        g=Matrix(Dados)
        matriz=transpose(g)
        
        global a = 0
        global Sx² = 0

        for i in 1:length(matriz)-1
            if i % first(unique((Tabela.n))) == 0
                continue
            end

            global a += (sum(matriz[i]-matriz[i+1])^2)

            Sx² = (a/(2*(length(Tabela.n)*first(unique((Tabela.n))))*((length(Tabela.n)*first(unique((Tabela.n))))-length(Tabela.n))))*
                (1-((length(Tabela.n)*first(unique((Tabela.n))))/N)) #Estimativa aproximada da variância da média
        end

        # Verifica se a população é FINITA ou INFINITA
        if (((quantile(TDist((length(Tabela.n)*first(unique((Tabela.n))))-1), 1-α/2))*sqrt(Sx²))/mean(Tabela.Média))*100 > EAR
            Observação = "Diante do exposto, conclui-se que os resultados obtidos na amostragem não satisfazem as exigências de precisão estabelecidas para o inventário, ou seja, um erro de amostragem máximo de $(Int(EAR))% da média  para confiabilidade designada. \n\nO erro estimado foi maior que o limite fixado, sendo recomendado incluir mais unidades amostrais no inventário."
        elseif (((quantile(TDist((length(Tabela.n)*first(unique((Tabela.n))))-1), 1-α/2))*sqrt(Sx²))/mean(Tabela.Média))*100 ≤ EAR
            Observação  = "Diante do exposto, conclui-se que os resultados obtidos na amostragem satisfazem as exigências de precisão estabelecidas para o inventário, ou seja, um erro de amostragem máximo de ±$(Int(EAR))% da média para confiabilidade designada. \n\nO erro estimado foi menor que o limite fixado, assim as unidades amostrais são suficientes para o inventário."
        end

        Resultados = (
            DataFrame(Variáveis=["Média (m³/ha)", "Limite inferior do intervalo de confiança para média (m³/ha)", 
            "Limite superior do intervalo de confiança para média (m³/ha)", "Total da população (m³)", "Limite inferior do intervalo de confiança para o total (m³)", 
            "Limite superior do intervalo de confiança para o total (m³)", "Área da população (ha)", "Erro da amostragem relativo (%)", 
            "Erro padrão absoluto (m³/ha)", "Erro padrão da média (m³/ha)", "Variância da média (m³/ha)²", "Fator de correção", "População", 
            "Unidades amostrais possíveis", "Número de unidades amostrais totais", "Número de unidades do inventário florestal", 
            "Número de faixas do inventário florestal",  "Nível de significância (α)", "Observação"], 
            Valores=[mean(Tabela.Média), mean(Tabela.Média)-((quantile(TDist((length(Tabela.n)*first(unique((Tabela.n))))-1), 
            1-α/2))*sqrt(Sx²)), mean(Tabela.Média)+((quantile(TDist((length(Tabela.n)*first(unique((Tabela.n))))-1), 
            1-α/2))*sqrt(Sx²)), ((N*mean(Tabela.Média))/Conversor), (((N*mean(Tabela.Média))-N*((quantile(TDist((length(Tabela.n)*first(unique((Tabela.n))))-1), 
            1-α/2))*sqrt(Sx²)))/Conversor), (((N*mean(Tabela.Média))+N*((quantile(TDist((length(Tabela.n)*first(unique((Tabela.n))))-1), 
            1-α/2))*sqrt(Sx²)))/Conversor), Area, (((quantile(TDist((length(Tabela.n)*first(unique((Tabela.n))))-1), 
            1-α/2))*sqrt(Sx²))/mean(Tabela.Média))*1000, ((quantile(TDist((length(Tabela.n)*first(unique((Tabela.n))))-1), 1-α/2))*sqrt(Sx²)), 
            sqrt(Sx²), Sx², (1-((length(Tabela.n)*first(unique((Tabela.n))))/N)), População, N, (length(Tabela.n)*first(unique((Tabela.n)))), 
            first(unique((Tabela.n))), length(Tabela.n), α, Observação])
        ) #Tabela de resultados
        
        return [Resultados, População, Observação]

    end 
end