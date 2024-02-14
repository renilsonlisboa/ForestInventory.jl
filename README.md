# ForestInventory

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://renilsonlisboa.github.io/ForestInventory.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://renilsonlisboa.github.io/ForestInventory.jl/dev/)
[![Build Status](https://github.com/renilsonlisboa/ForestInventory.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/renilsonlisboa/ForestInventory.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/renilsonlisboa/ForestInventory.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/renilsonlisboa/ForestInventory.jl)

## ForestInventory

<p style="text-align: justify;">
O ForestInventory é um aplicativo desenvolvido em Linguagem Julia. Ele foi projetado para facilitar os processamentos dos processos de amostragem do inventário florestal. Nele é possível analisar 10 processos de amostragem do inventário florestal, que estão baseados no Livro de Inventário Florestal, 1997 de Sylvio Péllico Netto e Doádi Antônio Brena. Essa ferramenta tem o intuito de contribuir e facilitar o processamento de dados por pesquisadores, engenheiros florestais, estatísticos e pessoas que trabalhem com dados relacionados ao inventário florestal. Além disso, o seu uso é de livre acesso, possibilitando seu uso no ensino superior.
</p>

## Processos de Amostragem

- [Amostragem Aleatória Simples](https://repositorio.ufsm.br/bitstream/handle/1/28263/DIS_PPGAAA_2023_NARDINI_CLAITON.pdf?sequence=1&isAllowed=y#page=28)
- [Amostragem Estratificada](https://repositorio.ufsm.br/bitstream/handle/1/28263/DIS_PPGAAA_2023_NARDINI_CLAITON.pdf?sequence=1&isAllowed=y#page=29)
- [Amostragem Sistemática](https://repositorio.ufsm.br/bitstream/handle/1/28263/DIS_PPGAAA_2023_NARDINI_CLAITON.pdf?sequence=1&isAllowed=y#page=29)
- [Amostragem em Dois Estágios](https://repositorio.ufsm.br/bitstream/handle/1/28263/DIS_PPGAAA_2023_NARDINI_CLAITON.pdf?sequence=1&isAllowed=y#page=30)
- [Amostragem em Conglemerados](https://repositorio.ufsm.br/bitstream/handle/1/28263/DIS_PPGAAA_2023_NARDINI_CLAITON.pdf?sequence=1&isAllowed=y#page=31)
- [Amostragem Sistemática com Múltiplos Inícios Alatórios](https://repositorio.ufsm.br/bitstream/handle/1/28263/DIS_PPGAAA_2023_NARDINI_CLAITON.pdf?sequence=1&isAllowed=y#page=32)
- [Amostragem Independente](https://repositorio.ufsm.br/bitstream/handle/1/28263/DIS_PPGAAA_2023_NARDINI_CLAITON.pdf?sequence=1&isAllowed=y#page=32)
- [Amostragem com Repetição Total](https://repositorio.ufsm.br/bitstream/handle/1/28263/DIS_PPGAAA_2023_NARDINI_CLAITON.pdf?sequence=1&isAllowed=y#page=33)
- [Amostragem Dupla](https://repositorio.ufsm.br/bitstream/handle/1/28263/DIS_PPGAAA_2023_NARDINI_CLAITON.pdf?sequence=1&isAllowed=y#page=33)
- [Amostragem com Repetição Parcial](https://repositorio.ufsm.br/bitstream/handle/1/28263/DIS_PPGAAA_2023_NARDINI_CLAITON.pdf?sequence=1&isAllowed=y#page=34)

## Documentation

- Stable Documentation: [ForestInventory Stable Docs](https://renilsonlisboa.github.io/ForestInventory.jl/stable/)
- Development Documentation: [ForestInventory Dev Docs](https://renilsonlisboa.github.io/ForestInventory.jl/dev/)

## Installation

You can install ForestInventory.jl and its dependencies using the Julia package manager. Open the Julia REPL and run:

```julia
using Pkg

Pkg.add("https://github.com/renilsonlisboa/ForestInventory.jl")
```

Or you can install using ]

```julia
]add https://github.com/renilsonlisboa/ForestInventory.jl
```

## Using ForestInventory.jl

```julia
using ForestInventory

Inventory()
```