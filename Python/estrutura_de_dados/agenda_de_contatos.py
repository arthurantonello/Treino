import os

lista_de_contatos = {'123':'Fulaninho', '51997302981': 'Arthur'}

def adicionar_contato(numero):
    lista_de_contatos[numero] = input('Digite o nome: ')
    print(f'Contato de {lista_de_contatos[numero]} adicionado com sucesso \n')

def buscar_contato(contato):
    if lista_de_contatos != {}:
        if lista_de_contatos[contato]:
            print(f'\nNome: {lista_de_contatos[contato]}')
            print(f'Número: {contato}\n')
    else:
        print('Lista de contatos vazia')

def remover_contato(contato):
    if lista_de_contatos[contato]:
        lista_de_contatos.pop(contato)

def listar_contatos():
    for contato in lista_de_contatos.items():
        print(f'\nNome: {contato[1]}')
        print(f'Número: {contato[0]}\n')

def atualizar_contato(contato):
    if contato in lista_de_contatos:
        remover_contato(contato)
        lista_de_contatos[contato] = input('Insira o novo número: ')
        adicionar_contato(contato)

def iniciar_contatos():
    os.system('cls')
    while True:
        print('1 - Adicionar contato')
        print('2 - Buscar contato')
        print('3 - Remover contato')
        print('4 - Listar todos contatos')
        print('5 - Atualizar contato')
        print('6 - Sair')
        opcao = int(input('Qual opção deseja escolher? '))

        if opcao == 1:
            numero = input('Digite o número: ')
            adicionar_contato(numero)

        if opcao == 2:
            contato = input('Digite o número da pessoa para buscar: ')
            buscar_contato(contato)

        if opcao == 3:
            contato = input('Digite o contato para remover: ')
            remover_contato(contato)
            print(f'Operação realizada com sucesso')

        if opcao == 4:
            listar_contatos()

        if opcao == 5:
            contato = input('Insira o número do contato que queira modificar: ')
            atualizar_contato(contato)

        if opcao == 6:
            return False
iniciar_contatos()