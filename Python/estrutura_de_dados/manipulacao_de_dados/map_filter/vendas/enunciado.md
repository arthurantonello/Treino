# 🎯 Desafio Prático: Aplicando `map()` em Python

## 📌 Contexto
Você trabalha em uma empresa e recebeu uma lista contendo os valores de vendas (em reais) de vários vendedores no último mês. Alguns valores estão em formato de string (com `"R$"` e `","`) e outros já estão como `float`. Seu objetivo é:

1. Padronizar todos os valores para `float`.
2. Calcular um bônus de 10% sobre cada venda.
3. Arredondar o resultado para 2 casas decimais.

---

## 📊 Dados de Exemplo
```python
vendas = ["R$1.234,56", "R$890,12", 450.0, "R$3.000,50", 720.75]
```

## 🛠️ Tarefas

### Limpeza dos Dados
Use map() para converter todos os itens da lista em float:

Remova "R$" e substitua "," por ".".

Exemplo: "R$1.234,56" → 1234.56

### Cálculo do Bônus
Use map() para calcular 10% de bônus sobre cada valor limpo.

### Arredondamento
Use map() para arredondar os resultados para 2 casas decimais.

### 🎚️ Saída Esperada
```
# Valores limpos: [1234.56, 890.12, 450.0, 3000.5, 720.75]
# Bônus: [123.46, 89.01, 45.0, 300.05, 72.08]  # Arredondados!
```