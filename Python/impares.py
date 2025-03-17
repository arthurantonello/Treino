def impares(tamanho):
    soma = 0
    contagem = 0
    for n in range(tamanho + 1):
        if n % 2 != 0 and n % 3 == 0:
            contagem += 1
            soma += n
            print(n)

    print('A soma de todos os ', contagem, 'valores são', soma)

impares(500)