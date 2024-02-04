module ART

export calcART

    import DataFrames: DataFrame, transform, AsTable, ByRow
    import Statistics: mean, var, std
    import Distributions: TDist, quantile
    import CSV: CSV.read

    function calcART(Dados, AreaParc, N1, N2, α)

        AreaParc = Float64(Meta.parse(AreaParc))
        α = Float64(Meta.parse(α))
        N1 = Int64(Meta.parse(N1))
        N2 = Int64(Meta.parse(N2))

        Conversor=1/AreaParc

        ###Primeira ocasião####
        Unidades = Dados[!,1]
        Ocasião_1 = (Conversor.*Dados[!,2])
        Ocasião_2 = (Conversor.*Dados[!,3])
        Independente = DataFrame(Unidades = Unidades, Ocasião_1 = Ocasião_1, Ocasião_2 = Ocasião_2)
    
        Primeira_ocasião = DataFrame(Variáveis=["Média (m³/ha)", "Limite inferior do intervalo de confiança para média (m³/ha)", 
        "Limite superior do intervalo de confiança para média (m³/ha)", "Total da população (m³)", "Limite inferior do intervalo de confiança para o total (m³)", 
        "Limite superior do intervalo de confiança para o total (m³)", "Área da população (ha)", "Erro da amostragem relativo (%)", 
        "Erro da amostragem absoluto (m³/ha)", "Erro padrão (m³/ha)", "Desvio padrão (m³/ha)", "Variância (m³/ha)²", "Variância da média (m³/ha)²", 
        "Número total de unidades", "Nível de de significância (α)"], Valores=[mean(Ocasião_1), ((mean(Ocasião_1))-((quantile(TDist((length(Ocasião_1))-1),1-α/2))*
        (sqrt(((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/(length(Ocasião_1))-1)/(length(Ocasião_1)))*(1-((length(Ocasião_1))/N1)))))),
        ((mean(Ocasião_1))+((quantile(TDist((length(Ocasião_1))-1),1-α/2))*(sqrt(((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/
        (length(Ocasião_1))-1)/(length(Ocasião_1)))*(1-((length(Ocasião_1))/N1)))))), (N1*(mean(Ocasião_1))/Conversor), (((N1*(mean(Ocasião_1)))-
        N1*((quantile(TDist((length(Ocasião_1))-1),1-α/2))*(sqrt(((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/(length(Ocasião_1))-1)/
        (length(Ocasião_1)))*(1-((length(Ocasião_1))/N1))))))/Conversor), (((N1*(mean(Ocasião_1)))+N1*((quantile(TDist((length(Ocasião_1))-1),1-α/2))*
        (sqrt(((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/(length(Ocasião_1))-1)/(length(Ocasião_1)))*(1-((length(Ocasião_1))/N1))))))/Conversor), N1, 
        (((quantile(TDist((length(Ocasião_1))-1),1-α/2))*(sqrt(((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/(length(Ocasião_1))-1)/(length(Ocasião_1)))*
        (1-((length(Ocasião_1))/N1)))))/(mean(Ocasião_1)))*100, (quantile(TDist((length(Ocasião_1))-1),1-α/2))*(sqrt(((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/
        (length(Ocasião_1))-1)/(length(Ocasião_1)))*(1-((length(Ocasião_1))/N1)))), sqrt(((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/(length(Ocasião_1))-1)/(length(Ocasião_1)))*
        (1-((length(Ocasião_1))/N1))), sqrt(sum((Ocasião_1.-(mean(Ocasião_1))).^2)/(length(Ocasião_1))-1), sum((Ocasião_1.-(mean(Ocasião_1))).^2)/(length(Ocasião_1))-1, 
        ((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/(length(Ocasião_1))-1)/(length(Ocasião_1)))*(1-((length(Ocasião_1))/N1)), length(Ocasião_1), α]) #Tabela de resultados
        
        Segunda_ocasião = DataFrame(Variáveis=["Média (m³/ha)", "Limite inferior do intervalo de confiança para média (m³/ha)", 
        "Limite superior do intervalo de confiança para média (m³/ha)", "Total da população (m³)", "Limite inferior do intervalo de confiança para o total (m³)", 
        "Limite superior do intervalo de confiança para o total (m³)", "Área da população (ha)", "Erro da amostragem relativo (%)", 
        "Erro da amostragem absoluto (m³/ha)", "Erro padrão (m³/ha)", "Desvio padrão (m³/ha)", "Variância (m³/ha)²", "Variância da média (m³/ha)²", 
        "Número total de unidades", "Nível de de significância (α)"], Valores=[mean(Ocasião_2), ((mean(Ocasião_2))-((quantile(TDist((length(Ocasião_2))-1),1-α/2))*
        (sqrt(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/(length(Ocasião_2))-1)/(length(Ocasião_2)))*(1-((length(Ocasião_2))/N2)))))), 
        ((mean(Ocasião_2))+((quantile(TDist((length(Ocasião_2))-1),1-α/2))*(sqrt(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/
        (length(Ocasião_2))-1)/(length(Ocasião_2)))*(1-((length(Ocasião_2))/N2)))))), (N2*(mean(Ocasião_2))/Conversor), 
        (((N2*(mean(Ocasião_2)))-N2*((quantile(TDist((length(Ocasião_2))-1),1-α/2))*(sqrt(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/
        (length(Ocasião_2))-1)/(length(Ocasião_2)))*(1-((length(Ocasião_2))/N2))))))/Conversor), ((N2*((mean(Ocasião_2)))+N2*
        ((quantile(TDist((length(Ocasião_2))-1),1-α/2))*(sqrt(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/(length(Ocasião_2))-1)/(length(Ocasião_2)))*
        (1-((length(Ocasião_2))/N2))))))/Conversor), N2, (((quantile(TDist((length(Ocasião_2))-1),1-α/2))*(sqrt(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/
        (length(Ocasião_2))-1)/(length(Ocasião_2)))*(1-((length(Ocasião_2))/N2)))))/(mean(Ocasião_2)))*100, 
        (quantile(TDist((length(Ocasião_2))-1),1-α/2))*(sqrt(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/
        (length(Ocasião_2))-1)/(length(Ocasião_2)))*(1-((length(Ocasião_2))/N2)))), sqrt(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/(length(Ocasião_2))-1)/
        (length(Ocasião_2)))*(1-((length(Ocasião_2))/N2))), sqrt(sum((Ocasião_2.-(mean(Ocasião_2))).^2)/(length(Ocasião_2))-1), 
        sum((Ocasião_2.-(mean(Ocasião_2))).^2)/(length(Ocasião_2))-1, ((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/(length(Ocasião_2))-1)/
        (length(Ocasião_2)))*(1-((length(Ocasião_2))/N2)), length(Ocasião_2), α]) #Tabela de resultados
        
        Mudança_crescimento = DataFrame(Variáveis=["Crescimento médio (m³/ha)", "Limite inferior do intervalo de confiança para média (m³/ha)", 
        "Limite superior do intervalo de confiança para média (m³/ha)", "Crescimento total estimado (m³)", "Limite inferior do intervalo de confiança para o total (m³)", 
        "Limite superior do intervalo de confiança para o total (m³)", "Área da população (ha)", "Erro da amostragem relativo (%)", 
        "Erro da amostragem absoluto (m³/ha)", "Erro padrão (m³/ha)", "Variância da média (m³/ha)²"], Valores=[mean(Ocasião_2)-mean(Ocasião_1), 
        ((mean(Ocasião_2)-mean(Ocasião_1))-quantile(TDist((((length(Ocasião_1))-1)+((length(Ocasião_2))-1))-1),1-α/2)*
        (sqrt(((((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/(length(Ocasião_1))-1)/(length(Ocasião_1)))*
        (1-((length(Ocasião_1))/N1)))+(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/(length(Ocasião_2))-1)/(length(Ocasião_2)))*(1-((length(Ocasião_2))/N2))))-
        (2*((sum((Ocasião_1.-(mean(Ocasião_1))).*(Ocasião_2.-(mean(Ocasião_2))))/(length(Dados.n)-1))/
        (length(Dados.n))))))), ((mean(Ocasião_2)-mean(Ocasião_1))+quantile(TDist((((length(Ocasião_1))-1)+((length(Ocasião_2))-1))-1),1-α/2)*
        (sqrt(((((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/(length(Ocasião_1))-1)/(length(Ocasião_1)))*
        (1-((length(Ocasião_1))/N1)))+(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/(length(Ocasião_2))-1)/(length(Ocasião_2)))*(1-((length(Ocasião_2))/N2))))-
        (2*((sum((Ocasião_1.-(mean(Ocasião_1))).*(Ocasião_2.-(mean(Ocasião_2))))/(length(Dados.n)-1))/
        (length(Dados.n))))))), N2*(mean(Ocasião_2)-mean(Ocasião_1)), ((N2*(mean(Ocasião_2)-mean(Ocasião_1)))-N2*quantile(TDist((((length(Ocasião_1))-1)+
        ((length(Ocasião_2))-1))-1),1-α/2)*(sqrt(((((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/
        (length(Ocasião_1))-1)/(length(Ocasião_1)))*(1-((length(Ocasião_1))/N1)))+(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/(length(Ocasião_2))-1)/(length(Ocasião_2)))*
        (1-((length(Ocasião_2))/N2))))-(2*((sum((Ocasião_1.-(mean(Ocasião_1))).*(Ocasião_2.-(mean(Ocasião_2))))/(length(Dados.n)-1))/
        (length(Dados.n))))))), ((N2*(mean(Ocasião_2)-mean(Ocasião_1)))+N2*quantile(TDist((((length(Ocasião_1))-1)+
        ((length(Ocasião_2))-1))-1),1-α/2)*(sqrt(((((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/
        (length(Ocasião_1))-1)/(length(Ocasião_1)))*(1-((length(Ocasião_1))/N1)))+(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/(length(Ocasião_2))-1)/(length(Ocasião_2)))*
        (1-((length(Ocasião_2))/N2))))-(2*((sum((Ocasião_1.-(mean(Ocasião_1))).*(Ocasião_2.-(mean(Ocasião_2))))/(length(Dados.n)-1))/
        (length(Dados.n))))))), N2, (quantile(TDist((((length(Ocasião_1))-1)+((length(Ocasião_2))-1))-1),1-α/2)*
        (sqrt(((((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/(length(Ocasião_1))-1)/(length(Ocasião_1)))*
        (1-((length(Ocasião_1))/N1)))+(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/(length(Ocasião_2))-1)/
        (length(Ocasião_2)))*(1-((length(Ocasião_2))/N2))))-(2*((sum((Ocasião_1.-(mean(Ocasião_1))).*(Ocasião_2.-(mean(Ocasião_2))))/(length(Dados.n)-1))/
        (length(Dados.n))))))/(mean(Ocasião_2)-mean(Ocasião_1)))*100, quantile(TDist((((length(Ocasião_1))-1)+((length(Ocasião_2))-1))-1),1-α/2)*
        (sqrt(((((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/(length(Ocasião_1))-1)/(length(Ocasião_1)))*
        (1-((length(Ocasião_1))/N1)))+(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/(length(Ocasião_2))-1)/
        (length(Ocasião_2)))*(1-((length(Ocasião_2))/N2))))-(2*((sum((Ocasião_1.-(mean(Ocasião_1))).*(Ocasião_2.-(mean(Ocasião_2))))/
        (length(Dados.n)-1))/(length(Dados.n)))))), sqrt(((((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/(length(Ocasião_1))-1)/(length(Ocasião_1)))*
        (1-((length(Ocasião_1))/N1)))+(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/(length(Ocasião_2))-1)/
        (length(Ocasião_2)))*(1-((length(Ocasião_2))/N2))))-(2*((sum((Ocasião_1.-(mean(Ocasião_1))).*(Ocasião_2.-(mean(Ocasião_2))))/(length(Dados.n)-1))/
        (length(Dados.n))))), ((((sum((Ocasião_1.-(mean(Ocasião_1))).^2)/(length(Ocasião_1))-1)/(length(Ocasião_1)))*
        (1-((length(Ocasião_1))/N1)))+(((sum((Ocasião_2.-(mean(Ocasião_2))).^2)/(length(Ocasião_2))-1)/
        (length(Ocasião_2)))*(1-((length(Ocasião_2))/N2))))-(2*((sum((Ocasião_1.-(mean(Ocasião_1))).*(Ocasião_2.-(mean(Ocasião_2))))/(length(Dados.n)-1))/
        (length(Dados.n))))]) #Tabela de resultados   

        Resultados = [Independente, Primeira_ocasião, Segunda_ocasião, Mudança_crescimento]
        
        return [Resultados]
    end
end