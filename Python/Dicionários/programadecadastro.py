import os
os.system('cls')

entrada = 0
produtos = {}

def cadastrar_produto():
    codigo = input('Digite o código do produto: ')
    nome = input('Digite o nome do produto: ')
    quantidade = input('Digite a quantidade do produto: ')
    produtos[codigo] = {'nome': nome, 'quantidade': quantidade}
    return print('Produto cadastrado com sucesso\n')

def atualizar_quantidade():
    codigo = input('Qual código deseja alterar a quantidade? ')
    if codigo in produtos:
        print(f'A quantidade atual é de {produtos[codigo]["quantidade"]}')
        quantidade = input('Qual quantidade deseja inserir? ')
        produtos[codigo]['quantidade']= quantidade
        print(f'Quantidade alterada para {quantidade} com sucesso')
    else:
        print('Código de produto nao encontrado')

def remover_produto():
    codigo = input('Qual código deseja remover? ')
    if codigo in produtos: 
        del produtos[codigo]
        print(f'Produto de código {codigo} removido com sucesso')
    else:
        print('Código de produto não encontrado')

def exibir_estoque():
    if not produtos:
        print('Estoque vazio')
        return
    for codigo, produto in produtos.items():
        print(f'Código: {codigo}')
        print(f'Produto: {produto["nome"]}')
        print(f'Quantidade: {produto["quantidade"]}\n')


while entrada != 5:
    print('========= MENU =========')
    print('1 - Cadastrar produto')
    print('2 - Atualizar quantidade')
    print('3 - Remover produto')
    print('4 - Exibir estoque')
    print('5 - Sair')
    print('========================')
    entrada = int(input('Digite uma opção: '))
    if entrada == 1:
        cadastrar_produto()
        print(produtos)
    elif entrada == 2:
        atualizar_quantidade()
    elif entrada == 3:
        remover_produto()
    elif entrada == 4:
        exibir_estoque()
    




