import os, uuid

tarefas = [
    {
        "id": '1',
        "titulo": "Estudar Python",
        "descricao": "Praticar CRUD em Python",
        "status": "Pendente"  # Pode ser: Pendente, Em andamento, Concluída
    }
]

def buscar_tarefa_por_id(id_tarefa):
    for tarefa in tarefas:
        if tarefa['id'] == id_tarefa:
            return tarefa
    return None

def checar_existencia(id_tarefa):
    tarefa = buscar_tarefa_por_id(id_tarefa)
    if tarefa:
        return True
    return False
        
def imprimir_tarefa(id_tarefa):
    tarefa = buscar_tarefa_por_id(id_tarefa)
    if not tarefa:
        print(f'Tarefa de ID {id_tarefa} não encontrada.')
        return
    
    print(f'\nID: {tarefa["id"]}')
    print(f'Tarefa: {tarefa["titulo"]}')
    print(f'Descrição: {tarefa["descricao"]}')
    print(f'Status: {tarefa["status"]}\n')

def adicionar_tarefa():
    titulo = input('Insira o título para a tarefa: ').strip()
    descricao = input('Insira a descricao para a tarefa: ').strip()

    nova_tarefa = {
        'id': str(uuid.uuid4()),
        "titulo": titulo,
        "descricao": descricao,
        "status": 'Pendente'
    }

    tarefas.append(nova_tarefa)
    print('\nTarefa adicionada com sucesso!\n')

def listar_todas_tarefas():
    if not tarefas:
        print('\nLista de tarefas vazia.\n')
    else:
        for tarefa in tarefas:
            print(f'\nID: {tarefa["id"]}')
            print(f'Tarefa: {tarefa["titulo"]}')
            print(f'Descrição: {tarefa["descricao"]}')
            print(f'Status: {tarefa["status"]}\n')
        

def atualizar_tarefa(id_tarefa):
    if not checar_existencia(id_tarefa):
        return print(f'Tarefa de ID {id_tarefa} não encontrada.')
    for tarefa in tarefas:
        if tarefa['id'] == id_tarefa:
            print('\nDeseja apenas atualizar o status? "S" / "N"')
            opcao = input('').upper()
            if opcao == "S":
                tarefa["status"] = 'Completo' if tarefa["status"] == 'Pendente' else 'Pendente'
            else:
                tarefa["titulo"] = input('Insira o novo título: ').strip()
                tarefa["descricao"] = input('Insira a nova descrição: ').strip()
            print('\nTarefa atualizada com sucesso!\n')
        else:
            print('\nTarefa não encontrada\n')

def remover_tarefa(id_tarefa):
    if not checar_existencia(id_tarefa):
        return print(f'Tarefa de ID {id_tarefa} não encontrada.')
    for tarefa in tarefas:
        if tarefa['id'] == id_tarefa:
            tarefas.remove(tarefa)
            print('\nTarefa removida com sucesso.\n')
            return

def buscar_tarefa(id_tarefa):
    checar_existencia(id_tarefa)
    imprimir_tarefa(id_tarefa)


def gerenciar_tarefas():
    os.system('cls')
    while True:
        print('1 - Adicionar tarefa')
        print('2 - Listar todas tarefas')
        print('3 - Atualizar tarefa')
        print('4 - Remover tarefa')
        print('5 - Buscar tarefa')
        print('6 - Sair')

        opcao = int(input('Digite a opção desejada: '))

        if opcao == 1:
            adicionar_tarefa()
        
        if opcao == 2:
            listar_todas_tarefas()
        
        if opcao == 3:
            id_tarefa = input('Digite o ID da tarefa que deseja atualizar: ')
            atualizar_tarefa(id_tarefa)

        if opcao == 4:
            id_tarefa = input('Digite o ID da tarefa que deseja remover: ')
            remover_tarefa(id_tarefa)
        
        if opcao == 5:
            id_tarefa = input('Digite o ID da tarefa que deseja buscar: ')
            buscar_tarefa(id_tarefa)

        if opcao == 6:
            print('\nSaindo..\n')
            return False

gerenciar_tarefas()