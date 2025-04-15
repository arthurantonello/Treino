import os
os.system('cls')

class Pet:
    def __init__(self, nome, tipo, idade, vacinado):
        self.nome = nome
        self.tipo = tipo
        self.idade = int(idade)
        self.vacinado = bool(vacinado)
        self.dono = None

    def descrever(self):
        print(f'Nome do pet: {self.nome}')
        print(f'Espécie: {self.tipo}')
        print(f'Idade: {self.idade}')
        print(f'Vacina: {"Sim" if self.vacinado else "Não"}')
        if self.dono:
            print(f'Dono: {self.dono.nome}')

    def vacinar(self):
        if self.vacinado:
            print(f'O {self.tipo} {self.nome} já está vacinado')
        else: 
            print(f'O {self.tipo} {self.nome} foi vacinado')
            self.vacinado = True

class Dono:
    def __init__(self, nome, telefone):
        self.nome = nome
        self.telefone = int(telefone)
        self.pets = []

    def adicionar_pet(self, pet):
        if isinstance(pet, Pet):
            self.pets.append(pet)
            pet.dono = self
            print(f'O pet {pet.nome} foi adicionado à lista de {self.nome}')
        else:
            print("Erro: você precisa passar um objeto do tipo Pet.")

class Petshop:
    def __init__(self):
        self.lista_pets = []

    def adicionar_pet(self, pet):
        if isinstance(pet, Pet):
            self.lista_pets.append(pet)
            print(f'O pet {pet.nome} foi adicionado à lista')
        else:
            print("Erro: você precisa passar um objeto do tipo Pet.")

    def listar_pets(self):
        print("=== Pets cadastrados ===")
        for pet in self.lista_pets:
            pet.descrever()
            print()

    def listar_pets_por_dono(self, nome_do_dono):
        encontrados = [
            pet for pet in self.lista_pets
            if pet.dono and pet.dono.nome.lower() == nome_do_dono.lower()
        ]

        if encontrados:
            print(f'----- Pets do {nome_do_dono} -----')
            for pet in encontrados:
                pet.descrever()
                print()
        else:
            print(f'Nenhum pet encontrado para {nome_do_dono}')

    def vacinar_todos(self):
        for pet in self.lista_pets:
            pet.vacinar()

    def calcular_media_idades(self):
        if not self.lista_pets:
            print(f'Não há pets cadastrados')
            return
        soma_idades = sum(pet.idade for pet in self.lista_pets)
        media_idade = soma_idades/len(self.lista_pets)
        print(f'A média de idade dos animais é de {media_idade}')


pet1 = Pet('Momo', 'cachorro', '2', False)
pet2 = Pet('Sol', 'cachorro', '2', True)


dono1 = Dono('Arthur', 515151)
dono1.adicionar_pet(pet1)
dono1.adicionar_pet(pet2)


agropet = Petshop()
agropet.adicionar_pet(pet1)
agropet.adicionar_pet(pet2)

agropet.listar_pets_por_dono('Arthur')


