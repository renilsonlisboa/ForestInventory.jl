module ESTRAT
# Amostragem Estratificada 

export calcESTRAT

    import DataFrames: DataFrame, transform, AsTable, ByRow, groupby, combine
    import Statistics: mean, var, std
    import Distributions: TDist, quantile
    import CSV: CSV.read

    function calcESTRAT(Dados, Area, AreaParc, α, EAR, nh1, nh2, nh3) #Determinar função
        
        Area = Float64(Meta.parse(Area))
        AreaParc = Float64(Meta.parse(AreaParc))
        α = Float64(Meta.parse(α))
        EAR = Float64(Meta.parse(EAR))
        nh1 = Int64(Meta.parse(nh1))
        nh2 = Int64(Meta.parse(nh2))
        nh3 = Int64(Meta.parse(nh3))

        N = (Area*10000)/AreaParc

        Conversor = 10000/AreaParc
        
        Volume = (Conversor.*Dados.Volume)
        Unidade = Dados.Unidade
        Estrato = Dados.Estrato

        Conjunto_de_dados = DataFrame(Estrato = Estrato, Unidade = Unidade, Volume = Volume)

        Informações_do_inventário = DataFrame(Variáveis=["Área da população (ha)", 
        "Número total potencial de Unidades da população", "Nível de significância (α)", "Número de Unidades amostradas no estrato I", 
        "Número de Unidades amostradas no estrato II", "Número de Unidades amostradas no estrato III", 
        "Número de estratos", "Número de Unidades totais", "Número potencial de Unidades do estrato I", 
        "Número potencial de Unidades do estrato II", "Número potencial de Unidades do estrato III"], 
        Valores=[Area, N, α, nh1, nh2, nh3, length(unique(Estrato)), length(Unidade), 
        (round((Area/(length(Unidade)))*nh1)*10), (round((Area/(length(Unidade)))*nh2)*10), 
        (round((Area/(length(Unidade)))*nh3)*10)/N]) #Tabela de resultados

        #Tabela com estatítica descritiva pro estrato
        Tabela= combine(groupby(Conjunto_de_dados, :Estrato)) do df
            (Unidade=length(unique(df.Unidade)), Total= sum(df.Volume), Média= mean(df.Volume), Variância= var(df.Volume), 
            Erro_padrão= sqrt(var(df.Volume)))
        end

        Anova_da_estratificação = DataFrame(Fontes_de_variação=["Entre estratos", "Dentro dos estratos", "Total"], 
        gl=[length(unique(Estrato))-1 , length(Unidade)-length(unique(Estrato)), length(Unidade)-1], 
        SQ=[sum(Tabela.Unidade.*(Tabela.Média.-mean(Volume)).^2), 
        sum((Volume.-mean(Volume)).^2)-sum(Tabela.Unidade.*(Tabela.Média.-mean(Volume)).^2), 
        sum((Volume.-mean(Volume)).^2)], 
        QM=[(sum(Tabela.Unidade.*(Tabela.Média.-mean(Volume)).^2))/(length(unique(Estrato))-1), 
        (sum((Volume.-mean(Volume)).^2)-sum(Tabela.Unidade.*(Tabela.Média.-mean(Volume)).^2))/
        (length(Unidade)-length(unique(Estrato))), (sum((Volume.-mean(Volume)).^2))/
        (length(Unidade)-1)], F=[((sum(Tabela.Unidade.*(Tabela.Média.-mean(Volume)).^2))/
        (length(unique(Estrato))-1))/
        ((sum((Volume.-mean(Volume)).^2)-sum(Tabela.Unidade.*(Tabela.Média.-mean(Volume)).^2))/
        (length(Unidade)-length(unique(Estrato)))), "", ""])

        t=quantile(TDist(length(Unidade)-1),1-α/2) #Valor de t 

        if (1-(length(Unidade)/N)) ≥ 0.98 #f maior ou igual a 0,98 população infinita
            População = "A população avaliada é considerada infinita"   
        elseif (1-(length(Unidade)/N)) < 0.98 #f menor que 0,98 população finita
            População = "A população avaliada é considerada finita"    
        end
        Tamanho_da_amostra = if (1-(length(Unidade)/N)) ≥ 0.98
            #População infinita. O tamanho da amostra é calculado pela seguinte equação:
            Infinita=(((t)^2)*sum(((round((Area/(length(Unidade)))*nh1)*10)/N; 
            (round((Area/(length(Unidade)))*nh2)*10)/N; 
            (round((Area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância)))/(((0.1*mean(Volume)))^2)
            round(Infinita)
        elseif (1-(length(Unidade)/N)) < 0.98
            #População finita. O tamanho da amostra é calculado pela seguinte equação:
            Finita=(((t)^2)*sum(((round((Area/(length(Unidade)))*nh1)*10)/N; 
            (round((Area/(length(Unidade)))*nh2)*10)/N; 
            (round((Area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância)))/
            (((0.1*mean(Volume)))^2)+((t)^2)*(sum(((round((Area/(length(Unidade)))*nh1)*10)/N; 
            (round((Area/(length(Unidade)))*nh2)*10)/N; 
            (round((Area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N)
            round(Finita)
        end

        if (((t*sqrt(((((((round((Area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
            ((((round((Area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
            ((((round((Area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
            length(unique(Estrato)))-(sum(((round((Area/(length(Unidade)))*nh1)*10)/N; (round((Area/(length(Unidade)))*nh2)*10)/N; 
            (round((Area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N)))/mean(Volume))*100) > EAR
            Observação = "Diante do exposto, conclui-se que os resultados obtidos na amostragem não satisfazem as exigências deprecisão estabelecidas para o inventário, ou seja, um erro de amostragem máximo de ±$(EAR)% da média  para confiabilidade designada. \n\nO erro estimado foi maior que o limite fixado, sendo recomendado incluir mais unidades amostrais no inventário."
        elseif (((t*sqrt(((((((round((Area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
            ((((round((Area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
            ((((round((Area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
            length(unique(Estrato)))-(sum(((round((Area/(length(Unidade)))*nh1)*10)/N; (round((Area/(length(Unidade)))*nh2)*10)/N; 
            (round((Area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N)))/mean(Volume))*100) ≤ EAR
            Observação  = "Diante do exposto, conclui-se que os resultados obtidos na amostragem satisfazem as exigências de precisão estabelecidas para o inventário, ou seja, um erro de amostragem máximo de ±$(EAR)% da média para confiabilidade designada. \n\nO erro estimado foi menor que o limite fixado, assim as unidades amostrais são suficientes para o inventário."
        end  

        Resultados = DataFrame(Variáveis=["Média estratificada (m³/ha)", "Limite inferior do intervalo de confiança para Média (m³/ha)", 
        "Limite superior do intervalo de confiança para Média (m³/ha)", "Total da população (m³)", 
        "Limite inferior do intervalo de confiança para o total (m³)", "Limite superior do intervalo de confiança para o total (m³)", "Área da população (ha)",
        "Erro da amostragem relativo (%)", "Erro da amostragem absoluto (m³/ha)", "Erro padrão (m³/ha)", "Desvio padrão (m³/ha)", 
        "Variância estrato I (m³/ha)²", "Variância estrato II (m³/ha)²", "Variância estrato III (m³/ha)²", "Variância estratificada (m³/ha)²", 
        "Variância da média relativa (%)", "Fator de correção", "Limite de erro da amostragem requerido", 
        "Tamanho da amostra estrato I", "Tamanho da amostra estrato II", "Tamanho da amostra estrato III", 
        "Tamanho da amostra", "População", "Observação"], Valores=[mean(Volume), (mean(Volume)-(t*sqrt(((((((round((Area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((Area/(length(Unidade)))*nh1)*10)/N; 
        (round((Area/(length(Unidade)))*nh2)*10)/N; 
        (round((Area/(length(Unidade)))*nh3)*10)/
        N*Tabela.Variância))/N)))), (mean(Volume)+(t*sqrt(((((((round((Area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((Area/(length(Unidade)))*nh1)*10)/N; 
        (round((Area/(length(Unidade)))*nh2)*10)/N; 
        (round((Area/(length(Unidade)))*nh3)*10)/
        N*Tabela.Variância))/N)))), ((N*mean(Volume))/Conversor), (((N*mean(Volume))-N*(t*sqrt(((((((round((Area/(length(Unidade)))*nh1)*10)/N)^2)*
        sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((Area/(length(Unidade)))*nh1)*10)/N; 
        (round((Area/(length(Unidade)))*nh2)*10)/N; 
        (round((Area/(length(Unidade)))*nh3)*10)/
        N*Tabela.Variância))/N))))/Conversor), (((N*mean(Volume))+N*(t*sqrt(((((((round((Area/(length(Unidade)))*nh1)*10)/N)^2)*
        sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((Area/(length(Unidade)))*nh1)*10)/N; 
        (round((Area/(length(Unidade)))*nh2)*10)/N; 
        (round((Area/(length(Unidade)))*nh3)*10)/
        N*Tabela.Variância))/N))))/Conversor), Area, (((t*sqrt(((((((round((Area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((Area/(length(Unidade)))*nh1)*10)/N; 
        (round((Area/(length(Unidade)))*nh2)*10)/N; 
        (round((Area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N)))/
        mean(Volume))*100), (t*sqrt(((((((round((Area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((Area/(length(Unidade)))*nh1)*10)/N; 
        (round((Area/(length(Unidade)))*nh2)*10)/N; 
        (round((Area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N))), sqrt(((((((round((Area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((Area/(length(Unidade)))*nh1)*10)/N; 
        (round((Area/(length(Unidade)))*nh2)*10)/N; 
        (round((Area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N)), sqrt(mean(Tabela.Variância)), 
        ((((round((Area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)), 
        ((((round((Area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)), 
        ((((round((Area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)), mean(Tabela.Variância), 
        ((((((round((Area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((Area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((Area/(length(Unidade)))*nh1)*10)/N; 
        (round((Area/(length(Unidade)))*nh2)*10)/N; 
        (round((Area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N), (1-(length(Unidade)/N)), (0.1*mean(Volume)), 
        (round((Area/(length(Unidade)))*nh1)*10)/N*(round(Finita)), 
        (round((Area/(length(Unidade)))*nh2)*10)/N*(round(Finita)), 
        (round((Area/(length(Unidade)))*nh3)*10)/N*(round(Finita)), Tamanho_da_amostra, População, Observação]) #Tabela de resultados    

        Resultados = [Dados, Informações_do_inventário, Por_estrato, Anova_da_estratificação, Resultados]

        return [Resultados, População, Observação]

    end#Tabela de resultados    
end