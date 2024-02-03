module ESTRAT
# Amostragem Estratificada 

export calcESTRAT

    import DataFrames: DataFrame, transform, AsTable, ByRow
    import Statistics: mean, var, std
    import Distributions: TDist, quantile
    import CSV: CSV.read

    function calcESTRAT(Dados, Area, AreaParc, α, EAR, estratos, nh) #Determinar função
        
        function toRoman(n)
            roman_numerals = Dict(
                1 => "I", 4 => "IV", 5 => "V", 9 => "IX", 10 => "X",
                40 => "XL", 50 => "L", 90 => "XC", 100 => "C",
                400 => "CD", 500 => "D", 900 => "CM", 1000 => "M"
            )

            result = ""
        
            for (value, numeral) in reverse(sort(collect(roman_numerals)))
                while n >= value
                    n -= value
                    result *= numeral
                end
            end
        
            return "Número de Unidades Amostradas no Estrato $result", "Número potencial de Unidades do estrato $result"
        end
        """
        Area = Float64(Meta.parse(Area))
        AreaParc = Float64(Meta.parse(AreaParc))
        α = Float64(Meta.parse(α))
        EAR = Float64(Meta.parse(EAR))
        Nestratos = Int64(Meta.parse(estratos))
        nh = Int64(Meta.parse(nh))
        """
        aux_vals = Vector{Float64}(undef, size(nh,1))
        var_estratos = Vector{Float64}(undef, size(nh,1))
        aux_calcEstrat = Vector{Float64}(undef, size(nh,1))
        tamanho_amostra_estrato = Vector{Float64}(undef, size(nh,1))
        aux_text = Matrix{String}(undef, size(nh,1), 2)
        fill!(aux_text, "")
    
        N = (Area*10000)/AreaParc

        Conversor = 10000/AreaParc

        Volume = (Conversor.*Dados.Volume)
        Estrato = Dados.Estrato
        Unidade = Dados.Unidade

        Conjunto_de_dados = DataFrame(Estrato = Estrato, Unidade = Unidade, Volume = Volume)

        NEstratos = length(unique(Estrato)) #Número de estratos
        NUnidade = length(Unidade) #Número de Unidades 
        


        for i in 1:(size(nh,1))
            aux_text[i,:] .= toRoman(i)
            aux_vals[i] = (round((Area/(length(Unidade)))*nh[i])*10)/N
        end

        Informações_do_inventário = (
            DataFrame(
                Variáveis = vcat(
                    "Área da população (ha)", 
                    "Número total potencial de Unidades da população", 
                    "Nível de significância (α)",
                    aux_inv[:,1],
                    "Número de estratos", "Número de Unidades totais",
                    aux_inv[:,2]
                ),
                Valores = vcat(
                    Area, 
                    N, 
                    alpha, 
                    nh,
                    length(unique(Estrato)), 
                    length(Unidade), 
                    aux_vals
                )
            )
        )      
        
        Tabela= combine(groupby(Conjunto_de_dados, :Estrato)) do df
                (Unidade=length(unique(df.Unidade)), 
                Total= sum(df.Volume), 
                Média= mean(df.Volume), 
                Variância= var(df.Volume), 
                Erro_padrão= sqrt(var(df.Volume)))
        end

        μestrat = mean(Volume) #Média estratificada
        var_estrat = mean(Tabela.Variância) #Variância estratificada
        desv_pad = sqrt(mean(Tabela.Variância)) #Desvio padrão estratificado

        Anova_da_estratificação = (
            DataFrame(
                Fontes_de_variação = [
                    "Entre estratos", 
                    "Dentro dos estratos", 
                    "Total"
                ], 
                GL = [
                    length(unique(Estrato))-1 , 
                    length(Unidade)-length(unique(Estrato)), 
                    length(Unidade)-1
                    ], 
                SQ = [
                    sum(Tabela.Unidade.*(Tabela.Média.-mean(Volume)).^2), 
                    sum((Volume.-mean(Volume)).^2)-sum(Tabela.Unidade.*(Tabela.Média.-mean(Volume)).^2), 
                    sum((Volume.-mean(Volume)).^2)
                ], 
                QM = [
                    (sum(Tabela.Unidade.*(Tabela.Média.-mean(Volume)).^2))/(length(unique(Estrato))-1), 
                    (sum((Volume.-mean(Volume)).^2)-sum(Tabela.Unidade.*(Tabela.Média.-mean(Volume)).^2))/
                    (length(Unidade)-length(unique(Estrato))), (sum((Volume.-mean(Volume)).^2))/
                    (length(Unidade)-1)
                ], 
                F = [
                    ((sum(Tabela.Unidade.*(Tabela.Média.-mean(Volume)).^2))/
                    (length(unique(Estrato))-1))/
                    ((sum((Volume.-mean(Volume)).^2)-sum(Tabela.Unidade.*(Tabela.Média.-mean(Volume)).^2))/
                    (length(Unidade)-length(unique(Estrato)))), 
                    "", 
                    ""
                ]
            )
        )


        ((round((area/(length(Unidade)))*nh1)*10)/N; (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância) 

        sum(((round((area/(length(Unidade)))*nh1)*10)/N; (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))

        (sum(((round((area/(length(Unidade)))*nh1)*10)/N; (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N)
        
        #Tamanho da amostra
        LE_Amostr = (0.1*mean(Volume)) #Limite de erro da amostragem requerido
        t = quantile(TDist(length(Unidade)-1),1-alpha/2) #Valor de t 
        FC = (1-(length(Unidade)/N)) #Fator de correção
        
        if (1-(length(Unidade)/N)) ≥ 0.98 #f maior ou igual a 0,98 população infinita
            População = "A população avalada é considerada infinita"   
        elseif (1-(length(Unidade)/N)) < 0.98 #f menor que 0,98 população finita
            População = "A população avaliada é considerada finita"    
        end
        
        Tamanho_da_amostra = if (1-(length(Unidade)/N)) ≥ 0.98
            #População infinita. O tamanho da amostra é calculado pela seguinte equação:
            Infinita=(((t)^2)*sum(((round((area/(length(Unidade)))*nh1)*10)/N; (round((area/(length(Unidade)))*nh2)*10)/N; (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância)))/(((0.1*mean(Volume)))^2)
        elseif (1-(length(Unidade)/N)) < 0.98
            #População finita. O tamanho da amostra é calculado pela seguinte equação:
            Finita=(((t)^2)*sum(((round((area/(length(Unidade)))*nh1)*10)/N; (round((area/(length(Unidade)))*nh2)*10)/N; (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância)))/(((0.1*mean(Volume)))^2)+((t)^2)*(sum(((round((area/(length(Unidade)))*nh1)*10)/N; (round((area/(length(Unidade)))*nh2)*10)/N; (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N)
        end

        #Dados necessários para calcular o tamanho da amostra em amostragem estratificada
        (round((area/(length(Unidade)))*nh1)*10)/N*(round(Finita))
        (round((area/(length(Unidade)))*nh2)*10)/N*(round(Finita))
        (round((area/(length(Unidade)))*nh3)*10)/N*(round(Finita))

        #Variância em cada estrato
        ((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))
        ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))
        ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))

        #Variância estratificada
        ((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
        (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N)

        #Erro padrão
        sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
        (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N))

        #Grau de liberdade
        ((round((area/(length(Unidade)))*nh1)*10)*((round((area/(length(Unidade)))*nh1)*10)-nh1))/nh1
        ((round((area/(length(Unidade)))*nh2)*10)*((round((area/(length(Unidade)))*nh2)*10)-nh2))/nh2
        ((round((area/(length(Unidade)))*nh3)*10)*((round((area/(length(Unidade)))*nh3)*10)-nh3))/nh3

        #Erro da amostragem
        (t*sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
        (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N))) #Absoluto

        (((t*sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
        (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N)))/
        mean(Volume))*100) #Relativo

        #Limite do intervalo de confiança para média
        (mean(Volume)-(t*sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
        (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/
        N*Tabela.Variância))/N)))) #Inferior 

        (mean(Volume)+(t*sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
        (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/
        N*Tabela.Variância))/N)))) #Superior

        #Total por estrato
        (round((area/(length(Unidade)))*nh1)*10); (round((area/(length(Unidade)))*nh2)*10); 
        (round((area/(length(Unidade)))*nh3)*10).*Tabela.Média

        #Total da população
        total_pop = ((N*mean(Volume))/Conversor)

        #Limite do intervalo de confiança para o total 
        (((N*mean(Volume))-N*(t*sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*
        sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
        (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/
        N*Tabela.Variância))/N))))/Conversor) #Inferior

        (((N*mean(Volume))+N*(t*sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*
        sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
        (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/
        N*Tabela.Variância))/N))))/Conversor) #Superior

        
        for i in 1:(size(nh,1))
            var_estratos[i] = ((((round((Area/(length(Unidade)))*nh[i])*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))
            tamanho_amostra_estrato[i] = (round((Area/(length(Unidade)))*nh[i])*10)/N*(round(Finita))
            aux_calcEstrat[i] = (((round((Area/(length(Unidade)))*nh[i])*10)/N) * Tabela.Variância[i])/N
        end
    
        if (((t*sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
            ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
            ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
            length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; (round((area/(length(Unidade)))*nh2)*10)/N; 
            (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N)))/mean(Volume))*100) > EAR
            Observação = "Diante do exposto, conclui-se que os resultados obtidos na amostragem não satisfazem as exigências de
            precisão estabelecidas para o inventário, ou seja, um erro de amostragem máximo de ±10% da Média  para confiabilidade designada. 
            O erro estimado foi maior que o limite fixado, sendo recomendado incluir mais Unidades amostrais no inventário."
        elseif (((t*sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
            ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
            length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; (round((area/(length(Unidade)))*nh2)*10)/N; 
            (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N)))/mean(Volume))*100) ≤ EAR
            Observação  = "Diante do exposto, conclui-se que os resultados obtidos na amostragem satisfazem as exigências de precisão estabelecidas para o inventário, ou seja, um erro de amostragem máximo de ±$(Int(EAR))% da média para confiabilidade designada. \n\nO erro estimado foi menor que o limite fixado, assim as unidades amostrais são suficientes para o inventário."
        end  
        
        """(mean(Volume)-(t*sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
        (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/
        N*Tabela.Variância))/N)))), 

    (mean(Volume)+(t*sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
        (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/
        N*Tabela.Variância))/N)))), 
        
    ((N*mean(Volume))/Conversor), 

    (((N*mean(Volume))-N*(t*sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*
        sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
        (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/
        N*Tabela.Variância))/N))))/Conversor), 

    (((N*mean(Volume))+N*(t*sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*
        sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
        ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
        length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
        (round((area/(length(Unidade)))*nh2)*10)/N; 
        (round((area/(length(Unidade)))*nh3)*10)/
        N*Tabela.Variância))/N))))/Conversor), """

        """
        (((t*sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
            ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
            ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
            length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
            (round((area/(length(Unidade)))*nh2)*10)/N; 
            (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N)))/
            mean(Volume))*100), 
        (t*sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
            ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
            ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
            length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
            (round((area/(length(Unidade)))*nh2)*10)/N; 
            (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N))), 
        sqrt(((((((round((area/(length(Unidade)))*nh1)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
            ((((round((area/(length(Unidade)))*nh2)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade))+
            ((((round((area/(length(Unidade)))*nh3)*10)/N)^2)*sum(Tabela.Variância/Tabela.Unidade)))/
            length(unique(Estrato)))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N; 
            (round((area/(length(Unidade)))*nh2)*10)/N; 
            (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância))/N)), 
        sqrt(mean(Tabela.Variância)), """


        Resultados = (
            DataFrame(
                Variáveis = vcat(
                    "Média estratificada (m³/ha)", 
                    "Limite inferior do intervalo de confiança para Média (m³/ha)", 
                    "Limite superior do intervalo de confiança para Média (m³/ha)", 
                    "Total da população (m³)", 
                    "Limite inferior do intervalo de confiança para o total (m³)", 
                    "Limite superior do intervalo de confiança para o total (m³)", 
                    "Área da população (ha)",
                    "Erro da amostragem relativo (%)", 
                    "Erro da amostragem absoluto (m³/ha)", 
                    "Erro padrão (m³/ha)", 
                    "Desvio padrão (m³/ha)", 
                    "Variância estrato I (m³/ha)²", 
                    "Variância estrato II (m³/ha)²", 
                    "Variância estrato III (m³/ha)²", 
                    "Variância estratificada (m³/ha)²", 
                    "Variância da média relativa (%)", 
                    "Fator de correção", 
                    "Limite de erro da amostragem requerido", 
                    "Tamanho da amostra estrato I", 
                    "Tamanho da amostra estrato II", 
                    "Tamanho da amostra estrato III", 
                    "Tamanho da amostra", 
                    "População", 
                    "Observação"
                ), 
                Valores = vcat(
                    μestrat, 
                    0,
                    0,
                    total_pop,
                    0,
                    0,
                    Area, 
                    0,
                    0,
                    0,
                    0,
                    var_estratos,
                    
                    mean(Tabela.Variância), 
                    (sum(var_estratos))/length(unique(Estrato))-(sum(aux_calcEstrat.*Tabela.Variância))/N,

                    (sum(var_estratos))/
                    
                    length(unique(Estrato))-(sum(((round((area/(length(Unidade)))*nh1)*10)/N*Tabela.Variância[1]; 
                          (round((area/(length(Unidade)))*nh2)*10)/N*Tabela.Variância[2]; 
                          (round((area/(length(Unidade)))*nh3)*10)/N*Tabela.Variância[3])))


                    
                    FC, 
                    LE_Amostr, 
                    tamanho_amostra_estrato,
                    round(Tamanho_da_amostra), 
                    População,
                    Observação
                )
            )
        ) 
    end#Tabela de resultados    
end