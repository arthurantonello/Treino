# 🚀 Desafio: Processamento de Dados de Sensores IoT

## 📋 **Contexto**  
Você é responsável por processar leituras de temperatura de dispositivos IoT. Os dados chegam em formatos inconsistentes e precisam ser padronizados para análise.

## 📊 **Dados Brutos**
```python
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
```

## 🎯 Tarefas Principais
### Filtragem e Limpeza
Remover leituras inválidas ("Erro: NaN", "--", etc.)

Extrair apenas valores numéricos (ignorar unidades, textos e símbolos)

### Conversão e Padronização
Converter todos os valores para float

Padronizar decimais (substituir , por .)

### Cálculo de Estatísticas
Calcular:

    ✅ Média das temperaturas

    🔼 Valor máximo

    🔽 Valor mínimo

    📊 Número de leituras válidas

### Resultado esperado:
```
# Leituras processadas: [25.4, 30.1, 22.8, 28.5, 23.0, 31.2]
# Estatísticas:
# - Média: 26.83
# - Máxima: 31.2
# - Mínima: 22.8
# - Total válidas: 6
```