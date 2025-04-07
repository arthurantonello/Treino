import os
os.system('cls')

usuarios = {}

while True:
    print("\n=== Sistema de Cadastro ===")
    print("1. Cadastrar usuário")
    print("2. Listar usuários")
    print("3. Buscar usuário por e-mail")
    print("4. Remover usuário")
    print("5. Sair")
    opcao = int(input('Digite a opção que gostaria de realizar: '))

    if opcao == 1:
        nome = input('Insira o nome do novo usuário: ')
        idade = int(input('Insira a idade: '))
        email = input('Insira o e-mail: ')
        
        usuarios[email] = {'nome': nome, 'idade': idade}
        print(f"Novo usuário {nome} cadastrado")

    if opcao == 2:
        print("Lista de usuários:")
        for email, dados in usuarios.items():
            print(f"Usuário: {dados['nome']} - Idade: {dados['idade']} - E-mail: {email}")

    if opcao == 3:
        pesquisa = input('Digite o e-mail para buscar: ')
        if pesquisa in usuarios:
            print(f"Usuário: {usuarios[pesquisa]['nome']} - Idade: {usuarios[pesquisa]['idade']} - E-mail: {pesquisa}")
        else:
            print('Não há esse usuário')

    if opcao == 4:
        usuario = input('Digite o e-mail do usuário para o remover: ')
        if usuario in usuarios:
            nome_usuario = usuarios[usuario]['nome']
            usuarios.pop(usuario)
            # print('Usuário removido')
            # print(usuarios)
            print(f"Usuário(a) {nome_usuario} removido")
        else:
            print('Não há esse usuário')

    if opcao == 5:
        print('Programa encerrado')
        break
