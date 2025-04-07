import os
import datetime
os.system('cls')

hoje = datetime.datetime.today()
data_padrao = hoje.strftime("%d-%m-%Y") #Inserido uma data padrão caso usuário não informe
# Lista de usuários vazia para programa zerado
# usuarios = {}

# Lista de usuários pré existentes para teste
usuarios = {
    "email@mail": {
        "nome": "Arthur",
        "idade": 25,
        "tarefas": [
            {"descricao": "Revisar código", "data": data_padrao},
            {"descricao": "Responder e-mails", "data": data_padrao},
            {"descricao": "Participar da daily", "data": data_padrao}
        ]
    },
    "user1@email.com": {
        "nome": "Alice",
        "idade": 30,
        "tarefas": [
            {"descricao": "Estudar Python", "data": data_padrao},
            {"descricao": "Praticar exercícios", "data": data_padrao},
            {"descricao": "Assistir aula gravada", "data": data_padrao}
        ]
    },
    "user2@email.com": {
        "nome": "Bruno",
        "idade": 22,
        "tarefas": [
            {"descricao": "Refatorar função", "data": data_padrao},
            {"descricao": "Atualizar documentação", "data": data_padrao},
            {"descricao": "Testar novas features", "data": data_padrao}
        ]
    },
    "user3@email.com": {
        "nome": "Carla",
        "idade": 27,
        "tarefas": [
            {"descricao": "Comer", "data": data_padrao},
            {"descricao": "Beber água", "data": data_padrao},
            {"descricao": "Jogar", "data": data_padrao}
        ]
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

def adicionar_tarefa(chave):
    tarefa = input('Insira a tarefa para adicionar: ')
    print('Digite a data da tarefa no formato DD-MM-YYYY,')
    data_str = input('Digite a data da tarefa no formato DD-MM-YYYY,\nou aperte enter para a data ser hoje: ')
    # Se não foi informada data, a padrão é instaurada e logo é formatado em ambas situações
    if not data_str:
        data_str = data_padrao
    data = datetime.datetime.strptime(data_str, '%d-%m-%Y') 

    # Para não haver usuário sem tarefas, uma em branco é inicializada caso já não tenha
    if "tarefas" not in usuarios[chave]:
            usuarios[chave]["tarefas"] = []
    nova_tarefa = {
        "descricao" : tarefa,
        "data" : data
    }
    usuarios[chave]["tarefas"].append(nova_tarefa)
    print("Tarefa adicionada com sucesso")

def listar_tarefas(chave):
    if usuario_existe(chave):
        print(f"Tarefas do usuário {usuarios[chave]['nome']}\n")
        for tarefas in usuarios[chave]['tarefas']: 
            print(f"- {tarefas['descricao']} - {tarefas['data']}")
        print("\n -------------\n")

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
            adicionar_tarefa(chave)
            
    if opcao == 3:
        chave = input('Insira o e-mail do usuário para listar as tarefa: ')
        listar_tarefas(chave)

    if opcao == 4:
        chave = input('Insira o e-mail usuário para remover a tarefa: ')
        listar_tarefas(chave)
        tarefa = input('Qual tarefa gostaria de remover? ')
        if tarefa in usuarios[chave]["tarefas"]:
            usuarios[chave]["tarefas"].remove(tarefa)
            print(f"Tarefa {tarefa} removida com sucesso")
        else:
            print(f"Tarefa {tarefa} não encontrada")

    if opcao == 5:
        for email, usuario in usuarios.items():
            print(f"Usuário: {usuario['nome']} - Idade: {usuario['idade']} - E-mail: {email}")
            if "tarefas" not in usuario:
                print("-- Sem tarefas --")
            else: 
                listar_tarefas(email)
    if opcao == 6:
        break