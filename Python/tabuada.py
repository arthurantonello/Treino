numero = int(input('Insira um numero para saber a tabuada: '))

for n in range(1, 11):
    resultado = numero * n 
    print(numero, ' x ', n, ' = ', resultado)