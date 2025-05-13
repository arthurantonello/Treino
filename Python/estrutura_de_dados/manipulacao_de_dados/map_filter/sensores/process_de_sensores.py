leituras = [
    "Dispositivo A: 25.4°C", 
    "Dispositivo B: 30,1 C", 
    "Erro: NaN",
    "Dispositivo C: 22.8°C", 
    "28.5 graus", 
    "Dispositivo D: --",
    23.0,
    "Dispositivo E: 31.2°C"
]

### Filtragem e Limpeza
# Remover leituras inválidas ("Erro: NaN", "--", etc.)
def remover_leituras_invalidas(leitura):
    leitura_valida = leitura
    if isinstance(leitura, str):
        leitura_valida = '' if 'NaN' in leitura or '--' in leitura else leitura
    return leitura_valida


# ### Conversão e Padronização
# Extrair apenas valores numéricos (ignorar unidades, textos e símbolos)
# Converter todos os valores para float
# Padronizar decimais (substituir , por .)

def separar_numeros(leitura):
    if isinstance(leitura,(int, float)):
        return float(leitura)
    chars_validos = [c for c in leitura if c.isdigit() or c in ',.-']
    numero_str = ''.join(chars_validos)
    numero_str = numero_str.replace(',', '.')
    return float(numero_str) if numero_str else None

def filtrar_numeros(leitura):
    return list(filter(lambda x: x != None,
                        (map(processar, leituras))
                        )
                    )

def processar(leitura):
    x = remover_leituras_invalidas(leitura)
    x = separar_numeros(x)
    return x

# ### Cálculo de Estatísticas
# Calcular:

#     ✅ Média das temperaturas
#preciso primeiro fazer a soma com sum e depois dividir pela quantidade de itens, com len



#     🔼 Valor máximo

#     🔽 Valor mínimo

#     📊 Número de leituras válidas



# resultado = list(filter(lambda x: x != '',
#                         (map(remover_leituras_invalidas, leituras)
#                             )
#                         )
#                     )
resultado = list(filter(lambda x: x != None,
                        (map(processar, leituras))
                        )
                    )

media = sum(resultado) / len(resultado)
print(media)
#print(resultado)