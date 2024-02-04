module ARP

export calcARP

    using DataFrames, Statistics, Distributions, CSV, XLSX #Habilitar pacotes

    function calcARP(Dados, AreaParc, N, α)

        AreaParc = Float64(Meta.parse(AreaParc))
        α = Float64(Meta.parse(α))
        N = Int64(Meta.parse(N))

        Conversor=1/AreaParc

        ###Primeira ocasião####
        Unidades = Dados[!,1]
        Ocasião_1 = (Conversor.*Dados[!,2])
        Ocasião_2 = (Conversor.*Dados[!,3])
        ARP = DataFrame(Unidades = Unidades, Ocasião_1 = Ocasião_1, Ocasião_2 = Ocasião_2)

        Informações_do_inventário = DataFrame(Variáveis=["Área da população (ha)", "Número total de unidades", 
        "Número de unidades da primeira ocasião", "Número de unidades da segunda ocasião", "Número de subamostras temporárias", 
        "Número de subamostras permanentes", "Número de novas subamostra temporárias", "Proporção ótima da subamostra temporária e substituída na segunda ocasião", 
        "Proporção ótima da subamostra permanente e remedida na segunda ocasião", "Nível de significância (α)"], Valores=[N, length(Unidades), 
        length(unique(skipmissing(Ocasião_1))), length(unique(skipmissing(Ocasião_2))), (length(Unidades))-(length(unique(skipmissing(Ocasião_2)))), 
        (length(Unidades))-(length(unique(skipmissing(Ocasião_1)))), ((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))), 
        ((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))/(length(unique(skipmissing(Ocasião_1)))), 
        ((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))/(length(unique(skipmissing(Ocasião_1)))), α])

        ###Primeira ocasião###  
        #Média das unidades de amostragem temporárias
        j=ARP[!, [:Ocasião_1]]
        g=Matrix(j)
        matriz=transpose(g)
        
        global Xu = 0
        
        for i in 1:((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))
            global Xu += matriz[i]/(((length(Unidades))-(length(unique(skipmissing(Ocasião_2))))))
        end
        
        #Média das unidades de amostragem permanentes
        global Xm = 0
        
        for i in (((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))+1):(length(unique(skipmissing(Ocasião_1))))
            global Xm += matriz[i]/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))
        end 
        
        #Variância das unidades de amostragem temporárias
        global A = 0
        global Sxu² = 0
        
        for i in 1:((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))
            global A += ((matriz[i].-Xu).^2)
            global Sxu² = A/(((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))-1)
        end
        
        #Variância das unidades de amostragem permanentes
        global C = 0
        global Sxm² = 0
        
        for i in (((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))+1):(length(unique(skipmissing(Ocasião_1))))
            global C += ((matriz[i].-Xm).^2)
            global Sxm² = C/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1)
        end

        Primeira_ocasião = DataFrame(Variáveis=["Média das unidades amostrais totais (m³/ha)", "Média das unidades amostrais temporárias (m³/ha)", 
        "Média das unidades amostrais permanentes (m³/ha)", "Limite inferior do intervalo de confiança para média (m³/ha)", 
        "Limite superior do intervalo de confiança para média (m³/ha)", "Total da população (m³)", 
        "Limite inferior do intervalo de confiança para o total (m³)", "Limite superior do intervalo de confiança para o total (m³)", 
        "Erro da amostragem relativo (%)", "Erro da amostragem absoluto (m³/ha)", "Erro padrão (m³/ha)", "Variância das unidades amostrais totais (m³/ha)²", 
        "Variância das unidades amostrais temporárias (m³/ha)²", "Variância das unidades amostrais permanentes (m³/ha)²", "Variância da média (m³/ha)²"], 
        Valores=[sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))), Xu, Xm, ((sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))-
        ((quantile(TDist((length(unique(skipmissing(Ocasião_1))))-1),1-α/2))*(sqrt(((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/
        (length(unique(skipmissing(Ocasião_1)))))).^2)/(length(unique(skipmissing(Ocasião_1))))-1)/(length(unique(skipmissing(Ocasião_1)))))*
        (1-((length(unique(skipmissing(Ocasião_1))))/N)))))), ((sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))+
        ((quantile(TDist((length(unique(skipmissing(Ocasião_1))))-1),1-α/2))*(sqrt(((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/
        (length(unique(skipmissing(Ocasião_1)))))).^2)/(length(unique(skipmissing(Ocasião_1))))-1)/(length(unique(skipmissing(Ocasião_1)))))*
        (1-((length(unique(skipmissing(Ocasião_1))))/N)))))), (N*(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))/Conversor), 
        (((N*(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1))))))-N*((quantile(TDist((length(unique(skipmissing(Ocasião_1))))-1),1-α/2))*
        (sqrt(((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)/(length(unique(skipmissing(Ocasião_1)))))*
        (1-((length(unique(skipmissing(Ocasião_1))))/N))))))/Conversor), (((N*(sum(skipmissing(Ocasião_1))/
        (length(unique(skipmissing(Ocasião_1))))))+N*((quantile(TDist((length(unique(skipmissing(Ocasião_1))))-1),1-α/2))*
        (sqrt(((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)/(length(unique(skipmissing(Ocasião_1)))))*
        (1-((length(unique(skipmissing(Ocasião_1))))/N))))))/Conversor), (((quantile(TDist((length(unique(skipmissing(Ocasião_1))))-1),1-α/2))*
        (sqrt(((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)/(length(unique(skipmissing(Ocasião_1)))))*
        (1-((length(unique(skipmissing(Ocasião_1))))/N)))))/(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1))))))*100, 
        (quantile(TDist((length(unique(skipmissing(Ocasião_1))))-1),1-α/2))*(sqrt(((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/
        (length(unique(skipmissing(Ocasião_1)))))).^2)/(length(unique(skipmissing(Ocasião_1))))-1)/(length(unique(skipmissing(Ocasião_1)))))*
        (1-((length(unique(skipmissing(Ocasião_1))))/N)))), sqrt(((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)/(length(unique(skipmissing(Ocasião_1)))))*
        (1-((length(unique(skipmissing(Ocasião_1))))/N))),  sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1, Sxu², Sxm², ((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)/(length(unique(skipmissing(Ocasião_1)))))*
        (1-((length(unique(skipmissing(Ocasião_1))))/N))]) #Tabela de resultados 
        
        #Média de unidades de amostragem permanentes
        j=ARP[!, [:Ocasião_2]]
        g=Matrix(j)
        matriz=transpose(g)
        
        global Ym = 0
        
        for i in (((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))+1):(length(unique(skipmissing(Ocasião_1))))
            global Ym += matriz[i]/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))
        end 
        
        #Média de novas unidades de amostragem temporárias
        j=ARP[!, [:Ocasião_2]]
        g=Matrix(j)
        matriz=transpose(g)
        
        global Yn = 0
        
        for i in ((length(unique(skipmissing(Ocasião_1))))+1):(length(Unidades))
            global Yn += matriz[i]/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))
        end
        
        #Variância de unidades de amostragem permanentes
        j=ARP[!, [:Ocasião_2]]
        g=Matrix(j)
        matriz=transpose(g)
        
        global B = 0
        global Sym² = 0
        
        for i in (((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))+1):(length(unique(skipmissing(Ocasião_1))))
            global B += ((matriz[i].-Ym).^2)
            global Sym² = B/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1)
        end

        #Variância de novas unidades de amostragem temporárias
        j=ARP[!, [:Ocasião_2]]
        g=Matrix(j)
        matriz=transpose(g)

        global B = 0
        global Syn² = 0
        
        for i in ((length(unique(skipmissing(Ocasião_1))))+1):(length(Unidades))
            global B += ((matriz[i].-Yn).^2)
            global Syn² = B/((((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))-1)
        end

        #Variâncias de unidades permanentes e temporárias
        j=ARP[!, [:Ocasião_1]]
        g=Matrix(j)
        matriz=transpose(g)
        D = [matriz[i].-Xm for i in (((length(Unidades))-
            (length(unique(skipmissing(Ocasião_2)))))+1):(length(unique(skipmissing(Ocasião_1))))]
        j=ARP[!, [:Ocasião_2]]
        g=Matrix(j)
        matriz=transpose(g)
        
        J = [matriz[i].-Ym for i in (((length(Unidades))-
            (length(unique(skipmissing(Ocasião_2)))))+1):(length(unique(skipmissing(Ocasião_1))))]
        sum(D.*J)/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1)
        (sum(D.*J)/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1))/
        (sqrt(Sxm²)*sqrt(Sym²)) #Coeficiente de correlação entre os volumes das unidades permanentes medidas nas duas ocasiões
        ((sum(D.*J)/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1))/
        (sqrt(Sxm²)*sqrt(Sym²)))*(sqrt(Sym²)/sqrt(Sxm²))
        
        #Constantes "a" e "b" 
        a=((((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))*(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_2)))))/(length(unique(skipmissing(Ocasião_1))))))/
        ((length(unique(skipmissing(Ocasião_2))))-((((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))/
        (length(unique(skipmissing(Ocasião_1)))))*((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))*((((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²))))^2))))*
        (((sum(D.*J)/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))*
        (sqrt(Sym²)/sqrt(Sxm²))) ##Constante a
        
        c=((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))/((length(unique(skipmissing(Ocasião_2))))-
        ((((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))/(length(unique(skipmissing(Ocasião_1)))))*
        (((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))*((((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²))))^2))) #Constante c

        Segunda_ocasião = DataFrame(Variáveis=["Média das unidades amostrais totais (m³/ha)", "Média das unidades amostrais permanente (m³/ha)", 
        "Média das novas unidades amostrais temporárias (m³/ha)", "Média corrente (m³/ha)", "Limite inferior do intervalo de confiança para média (m³/ha)", 
        "Limite superior do intervalo de confiança para média (m³/ha)", "Total da população (m³)", 
        "Limite inferior do intervalo de confiança para o total (m³)", "Limite superior do intervalo de confiança para o total (m³)", 
        "Erro da amostragem relativo (%)", "Erro da amostragem absoluto (m³/ha)", "Erro padrão (m³/ha)", 
        "Variância das unidades amostrais totais (m³/ha)²", "Variância das novas unidades amostrais temporárias (m³/ha)²", 
        "Variância das unidades amostrais permanentes (m³/ha)²", "Variância da média (m³/ha)²", "Coeficiente de correlação", "Constante a", 
        "Constante c"], Valores=[sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))), Yn, Ym, ((a*Xu)-(a*Xm)+(c*Ym)+(1-c)*Yn), 
        ((((a*Xu)-(a*Xm)+(c*Ym)+(1-c)*Yn))-((quantile(TDist((length(unique(skipmissing(Ocasião_2))))-1),1-α/2))*
        (sqrt(((a^2)*(sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)*((1/((length(Unidades))-(length(unique(skipmissing(Ocasião_2))))))+(1/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))))+((c^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/
        (length(unique(skipmissing(Ocasião_2)))))).^2)/(length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))))+(((1-c)^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/
        (length(unique(skipmissing(Ocasião_2)))))).^2)/(length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))))-((2*a*c*((sum(D.*J)/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²))))*
        ((sqrt(Sym²)*sqrt(Sxm²))/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))))))), 
        ((((a*Xu)-(a*Xm)+(c*Ym)+(1-c)*Yn))+((quantile(TDist((length(unique(skipmissing(Ocasião_2))))-1),1-α/2))*
        (sqrt(((a^2)*(sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)*((1/((length(Unidades))-(length(unique(skipmissing(Ocasião_2))))))+(1/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))))+((c^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/
        (length(unique(skipmissing(Ocasião_2)))))).^2)/(length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))))+(((1-c)^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/
        (length(unique(skipmissing(Ocasião_2)))))).^2)/(length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))))-((2*a*c*((sum(D.*J)/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1))/
        (sqrt(Sxm²)*sqrt(Sym²))))*((sqrt(Sym²)*sqrt(Sxm²))/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))))))), 
        (N*(((a*Xu)-(a*Xm)+(c*Ym)+(1-c)*Yn))/Conversor), (((N*(((a*Xu)-(a*Xm)+(c*Ym)+(1-c)*Yn)))-N*((quantile(TDist((length(unique(skipmissing(Ocasião_2))))-1),1-α/2))*
        (sqrt(((a^2)*(sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)*((1/((length(Unidades))-(length(unique(skipmissing(Ocasião_2))))))+(1/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))))+((c^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/
        (length(unique(skipmissing(Ocasião_2)))))).^2)/(length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))))+(((1-c)^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/
        (length(unique(skipmissing(Ocasião_2)))))).^2)/(length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))))-((2*a*c*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²))))*((sqrt(Sym²)*sqrt(Sxm²))/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))))))))/Conversor), (((N*(((a*Xu)-(a*Xm)+(c*Ym)+(1-c)*Yn)))+N*((quantile(TDist((length(unique(skipmissing(Ocasião_2))))-1),1-α/2))*
        (sqrt(((a^2)*(sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)*((1/((length(Unidades))-(length(unique(skipmissing(Ocasião_2))))))+(1/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))))+((c^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/
        (length(unique(skipmissing(Ocasião_2)))))).^2)/(length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))))+(((1-c)^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/
        (length(unique(skipmissing(Ocasião_2)))))).^2)/(length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))))-((2*a*c*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²))))*((sqrt(Sym²)*sqrt(Sxm²))/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))))))))/Conversor), (((quantile(TDist((length(unique(skipmissing(Ocasião_2))))-1),1-α/2))*(sqrt(((a^2)*(sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/
        (length(unique(skipmissing(Ocasião_1)))))).^2)/(length(unique(skipmissing(Ocasião_1))))-1)*((1/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_2))))))+(1/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))))+((c^2)*
        ((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))))+(((1-c)^2)*
        ((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))))-((2*a*c*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²))))*((sqrt(Sym²)*sqrt(Sxm²))/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))))))/
        (((a*Xu)-(a*Xm)+(c*Ym)+(1-c)*Yn)))*100, (quantile(TDist((length(unique(skipmissing(Ocasião_2))))-1),1-α/2))*
        (sqrt(((a^2)*(sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)*((1/((length(Unidades))-(length(unique(skipmissing(Ocasião_2))))))+(1/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))))+((c^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))))+(((1-c)^2)*
        ((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))))-((2*a*c*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²))))*((sqrt(Sym²)*sqrt(Sxm²))/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))))), sqrt(((a^2)*(sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)*((1/((length(Unidades))-(length(unique(skipmissing(Ocasião_2))))))+(1/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))))+((c^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))))+(((1-c)^2)*
        ((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))))-((2*a*c*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²))))*((sqrt(Sym²)*sqrt(Sxm²))/((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))))), 
        sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1, Syn², Sym², ((a^2)*(sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)*((1/((length(Unidades))-(length(unique(skipmissing(Ocasião_2))))))+(1/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))))+((c^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))))+(((1-c)^2)*
        ((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))))-((2*a*c*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²))))*((sqrt(Sym²)*sqrt(Sxm²))/
        ((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))), (sum(D.*J)/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1))/
        (sqrt(Sxm²)*sqrt(Sym²)), a, c]) #Tabela de resultados
            
        ###Crescimento ou mudança###
        #Estimativa direta 
        #É necessário achar os coeficientes "A" e "B" para calcular a crescimento médio 
        A=(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))/((length(unique(skipmissing(Ocasião_2))))-
        ((((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))/(length(unique(skipmissing(Ocasião_1)))))*((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))*((sum(D.*J)/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))^2)))+
        (((((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))*(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))/(length(unique(skipmissing(Ocasião_1))))))/
        ((length(unique(skipmissing(Ocasião_2))))-((((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))/(length(unique(skipmissing(Ocasião_1)))))*
        ((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))^2)))*
        (((sum(D.*J)/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))*(sqrt(Sxm²)/sqrt(Sym²))))
        
        B=((-((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))*(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_2)))))/(length(unique(skipmissing(Ocasião_1))))))/
        ((length(unique(skipmissing(Ocasião_2))))-((((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))/
        (length(unique(skipmissing(Ocasião_1)))))*((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))^2)))*
        (((sum(D.*J)/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))*
        (sqrt(Sym²)/sqrt(Sxm²)))-(((length(unique(skipmissing(Ocasião_2))))*(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))/(length(unique(skipmissing(Ocasião_1))))))/
        ((length(unique(skipmissing(Ocasião_2))))-((((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))/
        (length(unique(skipmissing(Ocasião_1)))))*((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))^2)))

    
        
        #Melhor estimativa da média direta da primeira ocasião
        #Para isso é necessário encontrar os coeficientes "b" "c" dados pelas seguintes equações:
        
        b=((length(unique(skipmissing(Ocasião_2))))*(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))/
        (length(unique(skipmissing(Ocasião_1))))))/((length(unique(skipmissing(Ocasião_2))))-
        ((((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))/(length(unique(skipmissing(Ocasião_1)))))*
        ((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))^2))
        
        c=((-((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))*(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))/(length(unique(skipmissing(Ocasião_1))))))/
        ((length(unique(skipmissing(Ocasião_2))))-((((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))/
        (length(unique(skipmissing(Ocasião_1)))))*((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))^2)))*(sqrt(Sxm²)/sqrt(Sym²))
        
        #A partir deste ponto, encontra-se a média direta da primeira ocasião
        X=((1-b)*Xu)+(b*Xm)+(c*Ym)-(c*Yn) 
        
        Mudança_crescimento = DataFrame(Variáveis=["Crescimento médio (m³/ha)", "Média direta da primeira ocasião (m³/ha)",
        "Limite inferior do intervalo de confiança para média (m³/ha)", "Limite superior do intervalo de confiança para média (m³/ha)", 
        "Crescimento total estimado (m³)", "Limite inferior do intervalo de confiança para o total (m³)", 
        "Limite superior do intervalo de confiança para o total (m³)", "Erro da amostragem relativo (%)", "Erro da amostragem absoluto (m³/ha)", 
        "Erro padrão (m³/ha)", "Variância da média", "Coeficientes A", "Coeficiente B", "Coeficientes b", "Coeficiente c"], 
        Valores=[(A*Ym)+((1-A)*Yn)+(B*Xm)-((1+B)*Xu), X, ((((a*Xu)-(a*Xm)+(c*Ym)+(1-c)*Yn)-X)-((quantile(TDist((((length(unique(skipmissing(Ocasião_1))))-1)+
        ((length(unique(skipmissing(Ocasião_2))))-1))-1),1-α/2))*(sqrt((A^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/
        (length(unique(skipmissing(Ocasião_2)))))).^2)/(length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))+((1-A)^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/
        (length(unique(skipmissing(Ocasião_2)))))).^2)/(length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))+(B^2)*((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/
        (length(unique(skipmissing(Ocasião_1)))))).^2)/(length(unique(skipmissing(Ocasião_1))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))+((1+B)^2)*((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/
        (length(unique(skipmissing(Ocasião_1)))))).^2)/(length(unique(skipmissing(Ocasião_1))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_2))))))+2*A*B*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))*((sqrt(Sxm²)*sqrt(Sym²))/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))))))), (((quantile(TDist((((length(unique(skipmissing(Ocasião_1))))-1)+((length(unique(skipmissing(Ocasião_2))))-1))-1),1-α/2))*(sqrt((A^2)*
        ((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))+((1-A)^2)*
        ((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))+(B^2)*
        ((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))+((1+B)^2)*
        ((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_2))))))+2*A*B*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))*((sqrt(Sxm²)*sqrt(Sym²))/((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))))))/
        (((a*Xu)-(a*Xm)+(c*Ym)+(1-c)*Yn)-X))*100, N*(((a*Xu)-(a*Xm)+(c*Ym)+(1-c)*Yn)-X), ((N*(((a*Xu)-(a*Xm)+(c*Ym)+(1-c)*Yn)-X))-N*((quantile(TDist((((length(unique(skipmissing(Ocasião_1))))-1)+
        ((length(unique(skipmissing(Ocasião_2))))-1))-1),1-α/2))*(sqrt((A^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/
        (length(unique(skipmissing(Ocasião_2)))))).^2)/(length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))+((1-A)^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/
        (length(unique(skipmissing(Ocasião_2)))))).^2)/(length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))+(B^2)*((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/
        (length(unique(skipmissing(Ocasião_1)))))).^2)/(length(unique(skipmissing(Ocasião_1))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))+((1+B)^2)*((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/
        (length(unique(skipmissing(Ocasião_1)))))).^2)/(length(unique(skipmissing(Ocasião_1))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_2))))))+2*A*B*((sum(D.*J)/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))*
        ((sqrt(Sxm²)*sqrt(Sym²))/((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))))))), ((N*(((a*Xu)-(a*Xm)+(c*Ym)+(1-c)*Yn)-X))+N*((quantile(TDist((((length(unique(skipmissing(Ocasião_1))))-1)+
        ((length(unique(skipmissing(Ocasião_2))))-1))-1),1-α/2))*(sqrt((A^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/
        (length(unique(skipmissing(Ocasião_2)))))).^2)/(length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))+((1-A)^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/
        (length(unique(skipmissing(Ocasião_2)))))).^2)/(length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))+(B^2)*((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/
        (length(unique(skipmissing(Ocasião_1)))))).^2)/(length(unique(skipmissing(Ocasião_1))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1))))))+((1+B)^2)*((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/
        (length(unique(skipmissing(Ocasião_1)))))).^2)/(length(unique(skipmissing(Ocasião_1))))-1)/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_2))))))+2*A*B*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))*((sqrt(Sxm²)*sqrt(Sym²))/((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))))))), (((quantile(TDist((((length(unique(skipmissing(Ocasião_1))))-1)+((length(unique(skipmissing(Ocasião_2))))-1))-1),1-α/2))*(sqrt((A^2)*
        ((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))+((1-A)^2)*
        ((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))+(B^2)*
        ((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))+((1+B)^2)*
        ((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_2))))))+2*A*B*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))*((sqrt(Sxm²)*sqrt(Sym²))/((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))))))/
        (((a*Xu)-(a*Xm)+(c*Ym)+(1-c)*Yn)-X))*100, (quantile(TDist((((length(unique(skipmissing(Ocasião_1))))-1)+((length(unique(skipmissing(Ocasião_2))))-1))-1),1-α/2))*(sqrt((A^2)*
        ((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))+((1-A)^2)*
        ((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))+(B^2)*
        ((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))+((1+B)^2)*
        ((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_2))))))+2*A*B*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))*((sqrt(Sxm²)*sqrt(Sym²))/
        ((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))))), sqrt((A^2)*((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))+((1-A)^2)*
        ((sum((skipmissing(Ocasião_2).-(sum(skipmissing(Ocasião_2))/(length(unique(skipmissing(Ocasião_2)))))).^2)/
        (length(unique(skipmissing(Ocasião_2))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))+(B^2)*
        ((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))+((1+B)^2)*
        ((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)/((length(Unidades))-(length(unique(skipmissing(Ocasião_2))))))+2*A*B*((sum(D.*J)/(((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))*((sqrt(Sxm²)*sqrt(Sym²))/
        ((length(Unidades))-(length(unique(skipmissing(Ocasião_1))))))), ((sum((skipmissing(Ocasião_1).-(sum(skipmissing(Ocasião_1))/(length(unique(skipmissing(Ocasião_1)))))).^2)/
        (length(unique(skipmissing(Ocasião_1))))-1)/(length(unique(skipmissing(Ocasião_1)))))*(1-((((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))*((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))*((sum(D.*J)/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1))/(sqrt(Sxm²)*sqrt(Sym²)))^2)/
        (((length(unique(skipmissing(Ocasião_1))))*(length(unique(skipmissing(Ocasião_2)))))-(((length(Unidades))-(length(unique(skipmissing(Ocasião_2)))))*((length(Unidades))-
        (length(unique(skipmissing(Ocasião_1)))))*((sum(D.*J)/(((length(Unidades))-(length(unique(skipmissing(Ocasião_1)))))-1))/
        (sqrt(Sxm²)*sqrt(Sym²)))^2)))), A, B, b, c]) #Tabela de resultados
        
        Resultados = [ARP, Informações_do_inventário, Primeira_ocasião, Segunda_ocasião, Mudança_crescimento]
        
        return [Resultados]
    end
end