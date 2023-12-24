module AAS

export AAS

    using DataFrames, Statistics, Distributions, CSV, XLSX #Habilitar pacotes

    function CalcAAS()
        Volume = (Conversor.*Dados.Volume)
        Unidades = Dados.Unidades
        AAS = DataFrame(Unidades = Unidades, Volume= Volume)
        mean(Volume) #Média
        (length(Unidades)) #Número de unidades
        var(Volume) #Variância 
        sqrt(var(Volume)) #Desvio padrão
        (1-(length(Unidades)/N)) #Fator de correção
        (0.1*mean(Volume)) #Limite de erro da amostragem requerido
        t=quantile(TDist(length(Unidades)-1),1-alpha/2) #Valor de t
        if (1-(length(Unidades)/N)) ≥ 0.98 #f maior ou igual a 0,98 população infinita
        População = "é considerada infinita"   
            println(População)
        elseif (1-(length(Unidades)/N)) < 0.98 #f menor que 0,98 população finita
        População = "é considerada finita"    
            println(População)
            end     
        Tamanho_da_amostra =   if (1-(length(Unidades)/N)) ≥ 0.98 #f maior ou igual a 0,98 população infinita
            #População infinita. O tamanho da amostra é calculado pela seguinte equação:
            Infinita=(((t)^2)*var(Volume))/(((0.1*mean(Volume)))^2) 
            round(Infinita)
        elseif (1-(length(Unidades)/N)) < 0.98 #f menor que 0,98 população finita
            #População finita. O tamanho da amostra é calculado pela seguinte equação:
            Finita=(N*((t)^2)*var(Volume))/((N*(((0.1*mean(Volume)))^2))+(((t)^2)*var(Volume)))
            round(Finita)
        end 
        (var(Volume)/length(Unidades))*(1-(length(Unidades)/N)) #Variância média
        (sqrt((var(Volume)))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N))) #Erro padrão
        ((sqrt(var(Volume)))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N)))/mean(Volume)*100 #Erro padrão relativo
        ((sqrt(var(Volume))/mean(Volume))*100) #Coeficiente de variação
        (((((sqrt(var(Volume))/mean(Volume))*100))^2)/(length(Unidades)))*(1-(length(Unidades)/N)) #Variância média relativa
        #Erro de amostragem
        (t*(sqrt(var(Volume)))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N))) #Absoluto
        ((t*(sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N)))))/mean(Volume)*100 #Relativo
        #Limite do intervalo de confiança para média 
        (mean(Volume)-(t*(sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N))))) #Inferior
        (mean(Volume)+(t*(sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N))))) #Superior
        ((N*mean(Volume))/Conversor) #Total da população
        #Limite do intervalo de confiança para o total   
        ((N*mean(Volume))-N*(t*(sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N)))))/Conversor #Inferior
        ((N*mean(Volume))+N*(t*(sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N))))) #Inferior
        mean(Volume)-(t*(sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N)))) #Estimativa mínima de confiança
        #Tabela com os resultados
        if ((t*(sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N)))))/mean(Volume)*100 > EAR
            Observação = "Diante do exposto, conclui-se que os resultados obtidos na amostragem não satisfazem as exigências de
            precisão estabelecidas para o inventário, ou seja, um erro de amostragem máximo de ±10% da média  para confiabilidade designada. 
            O erro estimado foi maior que o limite fixado, sendo recomendado incluir mais unidades amostrais no inventário."
            println(Observação)
            elseif ((t*(sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N))))/mean(Volume))*100 ≤ EAR
            Observação  = "Diante do exposto, conclui-se que os resultados obtidos na amostragem satisfazem as exigências de
            precisão estabelecidas para o inventário, ou seja, um erro de amostragem máximo de ±10% da média para confiabilidade designada. 
            O erro estimado foi menor que o limite fixado, assim as unidades amostrais são suficientes para o inventário."
            println(Observação)
        end    
        Resultados = DataFrames.DataFrame(Variáveis=["Média (m³/ha)", "Limite inferior do intervalo de confiança para média (m³/ha)", 
        "Limite superior do intervalo de confiança para média (m³/ha)", "Total da população (m³)", "Limite inferior do intervalo de confiança para o total (m³)", 
        "Limite superior do intervalo de confiança para o total (m³)", "Erro padrão relativo (%)", "Área da população (ha)", "Erro da amostragem absoluto (m³/ha)", "Erro padrão (m³/ha)", "Desvio padrão (m³/ha)", 
        "Variância (m³/ha)²", "Variância da média (m³/ha)²", "Variância da média relativa (%)", "Coeficiente de variação (%)", "Limite de erro da amostragem requerido", "Estimativa mínima de confiança (m³/ha)",
        "Fator de correção", "Tamanho da amostra", "População", "Número total de unidades amostrais da população", 
        "Nível de significância (α)", "Observação"], Valores=[mean(Volume), (mean(Volume)-(t*(sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N))))), 
        (mean(Volume)+(t*(sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N))))), 
        ((N*mean(Volume))/Conversor), 
        ((N*mean(Volume))-N*(t*(sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N)))))/Conversor, 
        ((N*mean(Volume))+N*(t*(sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N))))),
        ((t*(sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N)))))/mean(Volume)*100, Área,
        (t*(sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N)))),
        (sqrt(var(Volume))/sqrt(length(Unidades)))*sqrt((1-(length(Unidades)/N))), sqrt(var(Volume)),   
        var(Volume), (var(Volume)/length(Unidades))*(1-(length(Unidades)/N)), 
        (((((sqrt(var(Volume))/mean(Volume))*100))^2)/(length(Unidades)))*(1-(length(Unidades)/N)), 
        ((sqrt(var(Volume))/mean(Volume))*100), (0.1*mean(Volume)), EAR, (1-(length(Unidades)/N)),
        Tamanho_da_amostra, População, N, alpha, Observação]) #Tabela de resultados
        XLSX.writetable(("F:/Version_09_07_21/iflorestal.jl/01.xlsx"), Dados=(collect(DataFrames.eachcol(AAS)), 
        DataFrames.names(AAS)), Resultados=(collect(DataFrames.eachcol(Resultados)),
        DataFrames.names(Resultados))) #Exportar para o Excel
end
_________________________________________________________________________________________________________________________________________

#Processamento do inventário
#Importar dados
Dados = CSV.read("F:/Version_09_07_21/aas.csv", DataFrame) 
#Informações necessárias
#Área da população
const Área = 45
#Número total de unidades de amostragem na população
const N = Área/0.1 
#Nível de significância (α)
const alpha = 0.05
const EAR = 10 #Erro da amostragem requerido
#Unidade de medida da variável
Unidade = "m³/0.1 ha" #Alterar em função do inventário
#Conversor para a unidade de área por hectare
Área_da_parcela=0.1
Conversor=1/Área_da_parcela
#AAS(Unidades, Volume)
AAS(Dados.Unidades, Dados.Volume) #Saída dos dados


    end

end