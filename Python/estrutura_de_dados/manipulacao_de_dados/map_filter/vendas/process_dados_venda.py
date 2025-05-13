# Receber valores em R$ e float
vendas = ["R$1.234,56", "R$890,12", 450.0, "R$3.000,50", 720.75]

# 1. Padronizar todos os valores para `float`.
def padronizar_valor(valor):
    if isinstance(valor, str): 
        novo_valor = valor.replace('R$', '').replace('.', '').replace(',', '.')
        return float(novo_valor)
    else:
        return float(valor)

# 2. Calcular um bônus de 10% sobre cada venda.
def calcular_bonus(valor):
    return valor * 1.1

# 3. Arredondar o resultado para 2 casas decimais.
def arredondar_valor(valor):
    return round(valor, 2)

def processar(vendas):
    x = padronizar_valor(vendas)
    x = calcular_bonus(x)
    x = arredondar_valor(x)
    return x

resultado = list(map(processar, vendas))

print(resultado)

# Versão enxuta com lambda
resultado = list(map(
    lambda x: round(x * 1.1 , 2),
    map(
        lambda x: float(x.replace('R$', '').replace('.', '').replace(',', '.')) if isinstance(x, str) else x,
            vendas
    )
))

print(resultado)

