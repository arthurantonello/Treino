import string

# Entrada do usuário
frase = input("Digite uma frase: ").lower()

# Remover pontuação e dividir a frase em palavras corretamente
arrayEntrada = [palavra.strip(string.punctuation) for palavra in frase.split()]

# Dicionário para contar ocorrências das palavras
contagem_palavras = {}

# Contar palavras corretamente
for palavra in arrayEntrada:
    if palavra.isalpha():  # Garante que a palavra contém apenas letras
        contagem_palavras[palavra] = contagem_palavras.get(palavra, 0) + 1

# Exibir resultado
for palavra, contagem in contagem_palavras.items():
    print(f"{palavra}: {contagem}")
