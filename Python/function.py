def minhaFuncao(valor1, valor2):
    return valor1 + valor2
        
            
while True:
    valor1 = int(input('Digite o valor 1: '))
    valor2 = int(input('Digite o valor 2: '))
    if (valor1 == 0 and valor2 == 0):
        break
    else:
        resposta = minhaFuncao(valor1, valor2)
        print('', valor1, ' + ', valor2, ' = ', minhaFuncao(valor1,valor2))



