# Auxiliar Estratificada
using DataFrames, CSV

Dados = CSV.read("estrat.csv", DataFrame)
Unidade = Dados.Unidade
Estrato = Dados.Estrato
Area = 45
AreaParc = 1000 
N = (Area*10000)/AreaParc
Conversor = 10000/AreaParc
alpha = 0.05
nh = [7, 8, 7]
nh1 = 7
nh2 = 8
nh3 = 7
resultstring = ["Número de Unidades amostradas no estrato I", 
"Número de Unidades amostradas no estrato II", 
"Número de Unidades amostradas no estrato III"]
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

    return ["Número de Unidades Amostradas no Estrato $result" "Número potencial de Unidades do estrato $result"]
end

Informações_do_inventário = (
    DataFrame(
        Variáveis = [
            "Área da população (ha)", 
            "Número total potencial de Unidades da população", 
            "Nível de significância (α)",
            
            "Número de estratos", "Número de Unidades totais", 
            "Número potencial de Unidades do estrato I", 
            "Número potencial de Unidades do estrato II", 
            "Número potencial de Unidades do estrato III"
        ],
        Valores = [
            Area, 
            N, 
            alpha, 
            for i in 1:3
                mm = nh[i]
            end,
            length(unique(Estrato)), 
            length(Unidade), 
            (round((Area/(length(Unidade)))*nh1)*10), 
            (round((Area/(length(Unidade)))*nh2)*10), 
            (round((Area/(length(Unidade)))*nh3)*10)/N
        ]
    )
)