module AD

export calcAD

    using DataFrames, Statistics, Distributions, CSV, XLSX #Habilitar pacotes

    function calcAD(Dados, AreaParc, N, α)

        AreaParc = Float64(Meta.parse(AreaParc))
        α = Float64(Meta.parse(α))
        N = Int64(Meta.parse(N))

        Conversor=1/AreaParc

        ###Primeira ocasião####
        Unidades = Dados[!,1]
        Ocasião_1 = (Conversor.*Dados[!,2])
        Ocasião_2 = (Conversor.*Dados[!,3])
        AD = DataFrame(Unidades = Unidades, Ocasião_1 = Ocasião_1, Ocasião_2 = Ocasião_2)

        #Média de unidades temporárias
        j=AD[!, [:Ocasião_1]]
        g=Matrix(j)
        matriz=transpose(g)
        
        global Xu = 0
        
        for i in 1:(length(Unidades)-(length(unique(Ocasião_2))))
            global Xu += matriz[i]/(length(Unidades)-(length(unique(Ocasião_2))))
        end 

        #Média de unidades permanentes
        global Xm = 0
        
        for i in ((length(Unidades)-(length(unique(Ocasião_2))))+1):length(Unidades)
            global Xm += matriz[i]/(length(unique(Ocasião_2)))
        end 

        global a = 0
        global Sxu² = 0
        
        for i in 1:(length(Unidades)-(length(unique(Ocasião_2))))
            global a += ((matriz[i].-Xu).^2)
            global Sxu² = a/((length(Unidades)-(length(unique(Ocasião_2))))-1)
        end
        
        #Variância das unidades permanentes
        global b = 0
        global Sxm² = 0
        
        for i in ((length(Unidades)-(length(unique(Ocasião_2))))+1):length(Unidades)
            global b += ((matriz[i].-Xm).^2)
            global Sxm² = b/((length(unique(Ocasião_2)))-1)
        end

        Sxu=sqrt(Sxu²) #Desvio padrão das unidades temporárias
        Sxm=sqrt(Sxm²) #Desvio padrão das unidades permanentes
        Sx1=sqrt(sum((Ocasião_1.-((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))).^2)/
        ((length(Unidades))-1)) #Desvio padrão das unidades totais 

        Primeira_ocasião = DataFrame(Variáveis=["Média das unidades amostrais totais (m³/ha)", "Média das unidades amostrais temporárias (m³/ha)", 
        "Média das unidades amostrais permanentes (m³/ha)", "Limite inferior do intervalo de confiança para média (m³/ha)", "Limite superior do intervalo de confiança para média (m³/ha)", 
        "Total da população (m³)", "Limite inferior do intervalo de confiança para o total (m³)", "Limite superior do intervalo de confiança para o total (m³)", 
        "Área da população (ha)", "Erro da amostragem relativo (%)", "Erro da amostragem absoluto (m³/ha)", "Erro padrão (m³/ha)", 
        "Desvio padrão das unidades amostrais totais (m³/ha)", "Desvio padrão das unidades amostrais temporárias (m³/ha)", "Desvio padrão das unidades amostrais permanentes (m³/ha)", 
        "Variância das unidades amostrais totais (m³/ha)²", "Variância das unidades amostrais temporárias (m³/ha)²", "Variância das unidades amostrais permanentes (m³/ha)²", 
        "Variância da média (m³/ha)²", "Limite do erro de amostragem requerido", "Tamanho da amostra", "Número total de unidades amostradas", 
        "Unidades temporárias", "Unidades permanentes", "Proporção ótima da subamostra temporária e substituída na segunda ocasião", 
        "Proporção ótima da subamostra permanente e remedida na segunda ocasião", "Nível de de significância (α)"], Valores=[(((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm), Xu, Xm, ((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm)-((quantile(TDist((length(Unidades))-1),1-α/2))*
        (sqrt(((sum((Ocasião_1.-((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))).^2)/((length(Unidades))-1))/
        (length(Unidades)))*(1-((length(Unidades))/N)))))), ((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm)+((quantile(TDist((length(Unidades))-1),1-α/2))*
        (sqrt(((sum((Ocasião_1.-((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))).^2)/((length(Unidades))-1))/(length(Unidades)))*(1-((length(Unidades))/N)))))), 
        (N*(((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm)/Conversor), 
        (((N*(((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))-N*((quantile(TDist((length(Unidades))-1),1-α/2))*
        (sqrt(((sum((Ocasião_1.-((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))).^2)/((length(Unidades))-1))/
        (length(Unidades)))*(1-((length(Unidades))/N))))))/Conversor), (((N*(((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))+N*((quantile(TDist((length(Unidades))-1),1-α/2))*
        (sqrt(((sum((Ocasião_1.-((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))).^2)/((length(Unidades))-1))/(length(Unidades)))*(1-((length(Unidades))/N))))))/Conversor), 
        N, (((quantile(TDist((length(Unidades))-1),1-α/2))*(sqrt(((sum((Ocasião_1.-(((length(Unidades)-
        (length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm)).^2)/((length(Unidades))-1))/
        (length(Unidades)))*(1-((length(Unidades))/N)))))/(((length(Unidades)-(length(unique(Ocasião_2))))/
        (length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))*100, ((quantile(TDist((length(Unidades))-1),1-α/2))*(sqrt(((sum((Ocasião_1.-(((length(Unidades)-
        (length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm)).^2)/((length(Unidades))-1))/
        (length(Unidades)))*(1-((length(Unidades))/N))))), sqrt(((sum((Ocasião_1.-((((length(Unidades)-(length(unique(Ocasião_2))))/
        (length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))).^2)/
        ((length(Unidades))-1))/(length(Unidades)))*(1-((length(Unidades))/N))), sqrt(sum((Ocasião_1.-((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))).^2)/((length(Unidades))-1)), sqrt(Sxu²), sqrt(Sxm²), sum((Ocasião_1.-((((length(Unidades)-(length(unique(Ocasião_2))))/
        (length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))).^2)/((length(Unidades))-1), Sxu², Sxm², ((sum((Ocasião_1.-((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))).^2)/((length(Unidades))-1))/(length(Unidades)))*(1-((length(Unidades))/N)), 
        (0.05*(((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm)), 
        ((((quantile(TDist((length(Unidades))-1),1-α/2)))^2)*(sum((Ocasião_1.-((((length(Unidades)-
        (length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))).^2)/((length(Unidades))-1)))/
        (((((0.05*(((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))))^2)+
        (((((quantile(TDist((length(Unidades))-1),1-α/2)))^2)*(sum((Ocasião_1.-((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))).^2)/((length(Unidades))-1)))/N)), length(Unidades), length(Unidades)-(length(unique(Ocasião_2))), 
        length(unique(Ocasião_2)), (length(Unidades)-(length(unique(Ocasião_2))))/length(Unidades), (length(unique(Ocasião_2)))/length(Unidades), 
        α]) #Tabela de resultados
            
        ###Segunda ocasião###
        j=AD[!, [:Ocasião_1]]
        g=Matrix(j)
        matriz=transpose(g)
        a = [(matriz[i].- Xm) for i in ((length(Unidades)-(length(unique(Ocasião_2))))+1):length(Unidades)]
        h = (skipmissing(Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))))
        c = sum(a.*h)
        Sxy=c/((length(unique(Ocasião_2)))-1)
        
        #Variância da regressão
        z=[(matriz[i].^2) for i in ((length(Unidades)-(length(unique(Ocasião_2))))+1):length(Unidades)]
        
        Syx²=(1/((length(unique(Ocasião_2))-2))*((sum(skipmissing(Ocasião_2.^2)))-
        (((sum(skipmissing(Ocasião_1.*Ocasião_2))^2)/sum(z))))) 

        Segunda_ocasião = DataFrame(Variáveis=["Média das unidades amostrais permanentes", "Volume médio estimado se a segunda ocasião houvesse todas unidades amostrais", 
        "Limite inferior do intervalo de confiança para média (m³/ha)", "Limite superior do intervalo de confiança para média (m³/ha)", "Total da população (m³)", 
        "Limite inferior do intervalo de confiança para o total (m³)", "Limite superior do intervalo de confiança para o total (m³)", 
        "Área da população (ha)", "Erro da amostragem relativo (%)","Erro da amostragem absoluto (m³/ha)", "Erro padrão (m³/ha)", "Desvio padrão (m³/ha)", 
        "Variância (m³/ha)²", "Variância da regressão (m³/ha)²", "Variância da média (m³/ha)²", "Limite do erro de amostragem requerido", 
        "Tamanho da amostra", "Número total de unidades amostradas", "Nível de significância (α)"], Valores=[sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))), 
        (sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm), 
        ((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm))-((quantile(TDist((length(unique(Ocasião_2)))-1),1-α/2))*(sqrt((Syx²/(length(unique(Ocasião_2)))+
        (((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))-Syx²)/(length(Unidades))))))), 
        ((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm))+
        ((quantile(TDist((length(unique(Ocasião_2)))-1),1-α/2))*(sqrt((Syx²/(length(unique(Ocasião_2)))+
        (((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))-Syx²)/
        (length(Unidades))))))), (N*((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-(length(unique(Ocasião_2))))/
        (length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm))/Conversor), 
        (((N*((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-
        (length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm)))-N*
        ((quantile(TDist((length(unique(Ocasião_2)))-1),1-α/2))*(sqrt((Syx²/(length(unique(Ocasião_2)))+
        (((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1))))-Syx²)/(length(Unidades))))))))/Conversor), (((N*((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm)))+N*((quantile(TDist((length(unique(Ocasião_2)))-1),1-α/2))*(sqrt((Syx²/(length(unique(Ocasião_2)))+
        (((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1))))-Syx²)/(length(Unidades))))))))/Conversor), N, (((quantile(TDist((length(unique(Ocasião_2)))-1),1-α/2))*(sqrt((Syx²/(length(unique(Ocasião_2)))+
        (((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1))))-Syx²)/(length(Unidades)))))))/((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))))*((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-
        (length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm)))*100, 
        (quantile(TDist((length(unique(Ocasião_2)))-1),1-α/2))*
        (sqrt((Syx²/(length(unique(Ocasião_2)))+(((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))-Syx²)/(length(Unidades)))))), sqrt((Syx²/(length(unique(Ocasião_2)))+(((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))-Syx²)/(length(Unidades))))), 
        sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))), 
        sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))), 
        Syx², (Syx²/(length(unique(Ocasião_2)))+(((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))-Syx²)/(length(Unidades)))), 
        (0.05*((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm))), ((((quantile(TDist((length(unique(Ocasião_2)))-1),1-α/2)))^2)*((length(Unidades))*(Syx²)+((length(Unidades))-
        (length(Unidades)-(length(unique(Ocasião_2)))))*((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))-Syx²)))/((length(Unidades))*((((0.05*((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm)))))^2)), length(unique(Ocasião_2)), α]) #Tabela de resultados

        Mudança_crescimento = DataFrame(Variáveis=["Crescimento médio (m³/ha)", "Limite inferior do intervalo de confiança para média (m³/ha)", 
        "Limite superior do intervalo de confiança para média (m³/ha)", "Total da população (m³)", "Limite inferior do intervalo de confiança para o total (m³)", 
        "Limite superior do intervalo de confiança para o total (m³)", "Área da população (ha)", "Erro da amostragem relativo (%)", 
        "Erro da amostragem absoluto (m³/ha)", "Erro padrão (m³/ha)", "Variância média (m³/ha)²"], Valores=[((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-(length(unique(Ocasião_2))))/
        (length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm))-((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm)), (((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm))-((((length(Unidades)-
        (length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm)))-((quantile(TDist(((((length(Unidades))-1)+
        (length(unique(Ocasião_2))-1)))-1),1-α/2))*(sqrt(((((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1))))-Syx²)*((1+(Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))-2))/
        (((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))))))^2)))/(length(Unidades)))+
        (Syx²/(length(unique(Ocasião_2))))))), (((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm))-((((length(Unidades)-
        (length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm)))+((quantile(TDist(((((length(Unidades))-1)+
        (length(unique(Ocasião_2))-1)))-1),1-α/2))*(sqrt(((((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))-Syx²)*
        ((1+(Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))))-2))/(((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))))))^2)))/(length(Unidades)))+
        (Syx²/(length(unique(Ocasião_2))))))), N*(((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-(length(unique(Ocasião_2))))/
        (length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm))-((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))), ((N*(((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-
        (length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm))-((((length(Unidades)-
        (length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))))-N*((quantile(TDist(((((length(Unidades))-1)+
        (length(unique(Ocasião_2))-1)))-1),1-α/2))*
        (sqrt(((((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1))))-Syx²)*((1+(Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))-2))/
        (((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))))))^2)))/(length(Unidades)))+
        (Syx²/(length(unique(Ocasião_2)))))))), ((N*(((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-
        (length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm))-((((length(Unidades)-
        (length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))))+N*((quantile(TDist(((((length(Unidades))-1)+
        (length(unique(Ocasião_2))-1)))-1),1-α/2))*
        (sqrt(((((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1))))-Syx²)*((1+(Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))-2))/
        (((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))))))^2)))/(length(Unidades)))+
        (Syx²/(length(unique(Ocasião_2)))))))), N, (((quantile(TDist(((((length(Unidades))-1)+(length(unique(Ocasião_2))-1)))-1),1-α/2))*
        (sqrt(((((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1))))-Syx²)*((1+(Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))-2))/
        (((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))))))^2)))/(length(Unidades)))+
        (Syx²/(length(unique(Ocasião_2)))))))/(((sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2))))+
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((sqrt(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))/Sxm))*(((((length(Unidades)-(length(unique(Ocasião_2))))/(length(Unidades))*Xu)+
        ((length(unique(Ocasião_2)))/length(Unidades))*Xm))-Xm))-((((length(Unidades)-
        (length(unique(Ocasião_2))))/(length(Unidades))*Xu)+((length(unique(Ocasião_2)))/length(Unidades))*Xm))))*100, 
        (quantile(TDist(((((length(Unidades))-1)+(length(unique(Ocasião_2))-1)))-1),1-α/2))*
        (sqrt(((((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1))))-Syx²)*((1+(Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))))-2))/(((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))))))^2)))/(length(Unidades)))+
        (Syx²/(length(unique(Ocasião_2)))))), sqrt(((((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1))))-Syx²)*((1+(Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))-2))/(((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))))))^2)))/(length(Unidades)))+
        (Syx²/(length(unique(Ocasião_2))))), ((((sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1))))-Syx²)*((1+(Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1)))))))*
        ((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/(length(unique(Ocasião_2)))))).^2)/
        ((length(unique(Ocasião_2))-1)))))))-2))/(((Sxy/(sqrt(Sxm²*(sum((skipmissing((Ocasião_2.-(sum(skipmissing(Ocasião_2))/
        (length(unique(Ocasião_2)))))).^2)/((length(unique(Ocasião_2))-1))))))))^2)))/(length(Unidades)))+
        (Syx²/(length(unique(Ocasião_2))))]) #Tabela de resultados
        
        Resultados = [AD, Primeira_ocasião, Segunda_ocasião, Mudança_crescimento]
        
        return [Resultados]
    end
end