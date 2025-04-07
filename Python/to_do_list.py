import os
os.system('cls')

# Lista de usuários vazia para programa do zero
# usuarios = {}

# Lista de usuários pré existentes para teste
usuarios = {
    "email@mail": {
        "nome": "Arthur",
        "idade": 25,
        "tarefas": ["Revisar código", "Responder e-mails", "Participar da daily"]
    },
    "user1@email.com": {
        "nome": "Alice",
        "idade": 30,
        "tarefas": ["Estudar Python", "Praticar exercícios", "Assistir aula gravada"]
    },
    "user2@email.com": {
        "nome": "Bruno",
        "idade": 22,
        "tarefas": ["Refatorar função", "Atualizar documentação", "Testar novas features"]
    },
    "user3@email.com": {
        "nome": "Carla",
        "idade": 27,
        "tarefas": ["Comer", "Beber água", "Jogar"]
    }
}

def usuario_existe(chave):
    if chave not in usuarios:
        print("Usuário não existe")
        return False
    else:
        return True


def cadastrar_usuario():
    nome = input('Insira o nome do novo usuário: ')
    idade = int(input('Insira a idade: '))
    email = input('Insira o e-mail: ')
    usuarios[email] = {"nome": nome, "idade": idade}

def adicionar_tarefa(chave,tarefa):
    if "tarefas" not in usuarios[chave]:
            usuarios[chave]["tarefas"] = []
    usuarios[chave]["tarefas"].append(tarefa)
    print("Tarefa adicionada com sucesso")

while True:
    print("\n=== Sistema de Cadastro ===")
    print("1. Cadastrar usuário")
    print("2. Adicionar tarefa a um usuário pelo e-mail")
    print("3. Listar tarefas de um usuário")
    print("4. Remover tarefa específica de um usuário")
    print("5. Listar todos os usuários e tarefas")
    print("6. Sair")
    opcao = int(input('Digite a opção que gostaria de realizar: '))

    if opcao == 1:
        cadastrar_usuario()

    if opcao == 2:
        chave = input('Insira o e-mail do usuário para adicionar a tarefa: ')
        if usuario_existe(chave):
            tarefa = input('Insira a tarefa para adicionar: ')
            adicionar_tarefa(chave, tarefa)
            

    if opcao == 3:
        chave = input('Insira o e-mail do usuário para listar as tarefa: ')
        if usuario_existe(chave):
            print("\n -------------\n")
            print(f"Tarefas do usuário {usuarios[chave]['nome']}\n")
            for tarefas in usuarios[chave]["tarefas"]: 
                print(f"- {tarefas}")
            print("\n -------------\n")

    if opcao == 4:
        chave = input('Insira o e-mail usuário para remover a tarefa: ')
        if usuario_existe(chave):
            print(f"Tarefas do usuário {usuarios[chave]['nome']}")
            for tarefas in usuarios[chave]["tarefas"]: 
                print(f"- {tarefas}")
            tarefa = input('Qual tarefa gostaria de remover? ')
            if tarefa in usuarios[chave]["tarefas"]:
                usuarios[chave]["tarefas"].remove(tarefa)
                print(f"Tarefa {tarefa} removida com sucesso")
            else:
                print(f"Tarefa {tarefa} não encontrada")

    if opcao == 5:
        for email, usuario in usuarios.items():
            print(f"Usuário: {usuario['nome']} - Idade: {usuario['idade']} - E-mail: {email}")
            print("Tarefas:")
            if "tarefas" not in usuario:
                print("-- Sem tarefas --")
            else: 
                for tarefa in usuario["tarefas"]: 
                    print(f"- {tarefa}")
            print("---------------")
    if opcao == 6:
        break

