import os
os.system('cls')

class Carro:
    def __init__(self, marca, modelo, ano, cor):
        self.marca = marca
        self.modelo = modelo
        self.ano = ano
        self.cor = cor

    def andar(self, direcao):
        if direcao == 'frente':
            print('Andando para frente')
        elif direcao == 'trás':
            print('Andando para trás')

carro1 = Carro('Volkswagen', 'Polo', '2003', 'branco')

print(f"Marca: {carro1.marca}\nModelo: {carro1.modelo}")

carro1.andar('frente')

carro2 = Carro('Fiat','Palio', '2006', 'preto')

print(f"Marca: {carro2.marca}\nModelo: {carro2.modelo}")

carro2.andar('trás')