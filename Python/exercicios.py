lista = [12, -2, 4, 8, 29, 45, 78, 36, -17, 2, 12, 8, 3, 3, -52]

def maior_elemento(lista):
    return max(lista)

def menor_elemento(lista):
    return min(lista)

def ver_numeros_pares(lista):
    lista_de_pares = []
    for numero in lista:
        if numero % 2 == 0:
            lista_de_pares.append(numero)
    return lista_de_pares

def ver_numeros_impares(lista):
    lista_de_impares = []
    for numero in lista:
        if numero % 2 != 0:
            lista_de_impares.append(numero)
    return lista_de_impares

def ver_ocorrencias(elemento, lista):
    return lista.count(elemento)

def ver_media(lista):
    return round((sum(lista) / len(lista)), 2)

def somar_negativos(lista):
    soma = 0
    for numero in lista:
        if numero < 0:
            soma += numero
    return soma


print(f'Maior elemento: {maior_elemento(lista)}')
print(f'Menor elemento: {menor_elemento(lista)}')
print(f'Números pares: {ver_numeros_pares(lista)}')
print(f'Números ímpares: {ver_numeros_impares(lista)}')
print(f'Ocorrências do número na lista: {ver_ocorrencias(12, lista)}')
print(f'Média dos itens da lista: {ver_media(lista)}')
print(f'Soma dos números negativos: {somar_negativos(lista)}')