module AAS

import DataFrames: DataFrame
import Statistics: mean, var, std
import Distributions: TDist, quantile
import CSV: CSV.read

export CalcAAS

    function calcAAS(Dados, Area, AreaParc, α, EAR)

        Area = Float64(Meta.parse(Area))
        AreaParc = Float64(Meta.parse(AreaParc))
        α = Float64(Meta.parse(α))
        EAR = Float64(Meta.parse(EAR))

        N = (Area*10000)/AreaParc
        Conversor = 1/AreaParc
 
        Volume = (Conversor.*Dados.Volume)
        Unidades = Dados.Unidades
        
        AAS = DataFrame(Unidades = Unidades, Volume= Volume)
        
        Media = mean(Volume) #Média
        NumUni = (length(Unidades)) #Número de unidades
        Variancia = var(Volume) #Variância 
        DesvPad = std(Volume) #Desvio padrão
        FatorCorr = (1-(length(Unidades)/N)) #Fator de correção
        LE = (0.1*Media) #Limite de erro da amostragem requerido
        t = quantile(TDist(length(Unidades)-1),1-α/2) #Valor de t

        if (1-(NumUni/N)) ≥ 0.98 #f maior ou igual a 0,98 população infinita
        População = "é considerada infinita"   
            println(População)
        elseif (1-(NumUni/N)) < 0.98 #f menor que 0,98 população finita
        População = "é considerada finita"    
            println(População)
        end     
        
        Tamanho_da_amostra =   if (1-(NumUni/N)) ≥ 0.98 #f maior ou igual a 0,98 população infinita
            #População infinita. O tamanho da amostra é calculado pela seguinte equação:
            Infinita=(((t)^2)*Variancia)/(((0.1*Media))^2) 
            round(Infinita)
        elseif (1-(NumUni/N)) < 0.98 #f menor que 0,98 população finita
            #População finita. O tamanho da amostra é calculado pela seguinte equação:
            Finita=(N*((t)^2)*Variancia)/((N*(((0.1*Media))^2))+(((
                t)^2)*Variancia))
            round(Finita)
        end 
    
        VarMed = (Variancia/NumUni)*(1-(NumUni/N)) #Variância média

        ErroPad = (DesvPad/sqrt(NumUni))*sqrt((1-(NumUni/N))) #Erro padrão

        ErroPadRel = ErroPad/mean(Volume)*100 #Erro padrão relativo


        CV = (DesvPad/Media)*100 #Coeficiente de variação

        VarMedRel = (((((sqrt(Variancia)/Media)*100))^2)/(NumUni))*(1-(NumUni/N)) #Variância média relativa
        
        #Erro de amostragem
        ErroAmostAbs = ((t*(DesvPad))/sqrt(NumUni))*sqrt((1-(NumUni/N))) #Absoluto
        ErroAmostRel = ErroAmostAbs/Media*100 #Relativo
            
        #Limite do intervalo de confiança para média 
        LII = (Media-(t*DesvPad)/sqrt(NumUni))*sqrt((1-(NumUni/N))) #Inferior
        LIS = (Media+(t*DesvPad)/sqrt(NumUni))*sqrt((1-(NumUni/N))) #Superior
        ValTotal =  ((N*mean(Volume))/Conversor) #Total da população
        
        #Limite do intervalo de confiança para o total   
        LIItotal = ((N*Media)-N*(t*(DesvPad/sqrt(NumUni))*sqrt((1-(NumUni/N)))))/Conversor #Inferior
        LIStotal = ((N*Media)+N*(t*(DesvPad/sqrt(NumUni))*sqrt((1-(NumUni/N))))) #Inferior
        ConfMin = Media-(t*(DesvPad/sqrt(NumUni))*sqrt((1-(NumUni/N)))) #Estimativa mínima de confiança
        
        #Tabela com os resultados
        if ErroAmostRel > EAR
            Observação = "Diante do exposto, conclui-se que os resultados obtidos na amostragem não satisfazem as exigências deprecisão estabelecidas para o inventário, ou seja, um erro de amostragem máximo de ±10% da média  para confiabilidade designada. \n\nO erro estimado foi maior que o limite fixado, sendo recomendado incluir mais unidades amostrais no inventário."
        else
            Observação  = "Diante do exposto, conclui-se que os resultados obtidos na amostragem satisfazem as exigências de precisão estabelecidas para o inventário, ou seja, um erro de amostragem máximo de ±10% da média para confiabilidade designada. \n\nO erro estimado foi menor que o limite fixado, assim as unidades amostrais são suficientes para o inventário."
        end

        Resultados = DataFrame(Variáveis=["Média (m³/ha)", "Limite inferior do intervalo de confiança para média (m³/ha)", 
        "Limite superior do intervalo de confiança para média (m³/ha)", "Total da população (m³)", "Limite inferior do intervalo de confiança para o total (m³)", 
        "Limite superior do intervalo de confiança para o total (m³)", "Erro padrão relativo (%)", "Área da população (ha)", "Erro da amostragem absoluto (m³/ha)", "Erro padrão (m³/ha)", "Desvio padrão (m³/ha)", 
        "Variância (m³/ha)²", "Variância da média (m³/ha)²", "Variância da média relativa (%)", "Coeficiente de variação (%)", "Limite de erro da amostragem requerido", "Estimativa mínima de confiança (m³/ha)",
        "Fator de correção", "Tamanho da amostra", "População", "Número total de unidades amostrais da população", 
        "Nível de significância (α)", "Observação"], Valores=[Media, LII, LIS, ValTotal, LIItotal, LIStotal, ErroPadRel, Area, ErroAmostAbs, ErroPad, DesvPad, Variancia, VarMed, VarMedRel, CV, LE, EAR, FatorCorr, Tamanho_da_amostra, População, N, α, Observação])
     
        return [Resultados, População, Observação]
    end
end