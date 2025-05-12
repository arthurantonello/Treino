import os
import uuid

class Cliente():
    def __init__(self, nome, cpf, data_nascimento, endereco) -> None:
        self.nome = nome
        self.cpf = cpf
        self.data_nascimento = data_nascimento
        self.endereco = endereco
        self.conta_corrente = None
        self.conta_poupanca = None

    def __str__(self) -> str:
        return  f"\nNome: {self.nome}\n" \
                f"CPF: {self.cpf}\n" \
                f"Nasc: {self.data_nascimento}\n" \
                f"End: {self.endereco}\n"
    
class ContaBancaria():
    def __init__(self, cliente, tipo_conta) -> None:
        self.numero_conta = str(uuid.uuid4())
        self.cliente = cliente

        self.saldo = 0
        self.tipo_conta = 'corrente' if tipo_conta == 'corrente' else 'poupança'
        self.limite_saque = 500 if tipo_conta == 'corrente' else 1000
        if not isinstance(cliente, Cliente):
            raise ValueError ('Cliente não é do tipo cliente.')
        if tipo_conta != 'corrente' and tipo_conta is not'poupança':
            raise ValueError ('Tipo de conta inválida.')
        if tipo_conta == 'corrente' and cliente.conta_corrente != None:
            raise ValueError ('Cliente já possui conta corrente.')
        
        cliente.conta_corrente = self.numero_conta

        if tipo_conta == 'poupança' and cliente.conta_poupanca != None:
            raise ValueError ('Cliente já possui conta poupança.')
        else:
            cliente.conta_poupanca = self.numero_conta

    def checar_validade_valor(self, valor_str):
        try:
            valor = float(valor_str)
            return valor if valor > 0 else None
        except ValueError:
            print('Valor inválido, insira apenas números.')
            return None
        

    def depositar(self, valor_str):
        valor = self.checar_validade_valor(valor_str)
        print(f'Depósito de R${valor:.2f} realizado com sucesso.') #:.2f informa que serão 2 casas decimais e float
        self.saldo += valor

    def sacar(self, valor_str):
        valor = self.checar_validade_valor(valor_str)
        if valor > self.saldo:
            return print('Saldo insuficiente.')
        if self.limite_saque < valor:
            return print(f'Falha, limite diário atual: R${self.limite_saque}.')
        
        self.limite_saque = self.limite_saque - valor if (self.limite_saque - valor) >= 0 else 0
        self.saldo = self.saldo - valor if (self.saldo - valor) >= 0 else 0
        print(25 * '-')
        print(f'Saque de R${valor:.2f} realizado com sucesso.')
        print(25 * '-')

    def transferir(self, banco, numero_outra_conta, valor_str):
        valor = self.checar_validade_valor(valor_str)
        if valor > self.saldo:
            return print('Saldo insuficiente.')
        if not banco.checar_existencia_conta(numero_outra_conta):
            return print('Conta inválida para transferir.')
        
        if numero_outra_conta == self.numero_conta:
            print('Não é possível transferir para a mesma conta.')
            return 
        outra_conta = banco.buscar_conta(numero_outra_conta)
        
        self.saldo = self.saldo - valor if (self.saldo - valor) >= 0 else 0
        outra_conta.saldo += valor
        print(f'Transferëncia de {self.cliente.nome} para {outra_conta.cliente.nome} realizada com sucesso.')

    def consultar_saldo(self):
        print(f'Saldo: R${self.saldo:.2f}.') 
    
    def consultar_limite_saque(self):
        print(f'\nLimite atual: R${self.limite_saque:.2f}.\n')

    def __str__(self):
        return f"""\
            Número da conta: {self.numero_conta}
            Cliente: {self.cliente}
            Saldo: R${self.saldo:.2f}
            Tipo de conta: {self.tipo_conta}
            Limite de saque: R${self.limite_saque:.2f}\
            """
    
class Banco():
    def __init__(self) -> None:
        self.lista_de_contas = []
        self.lista_de_clientes = {}

    def buscar_cliente_pelo_cpf(self, cpf):
        return self.lista_de_clientes.get(cpf)
    
    def buscar_conta(self, numero_conta):
        for conta in self.lista_de_contas:
            if conta.numero_conta == numero_conta:
                return conta
        print(25 * '-')
        print('Conta não encontrada.')
        print(25 * '-')
        return None
    
    def validar_cpf(self, cpf):
        return len(cpf) == 11 and cpf.isdigit()
    
    def checar_existencia_conta(self, numero_conta):
        return self.buscar_conta(numero_conta) is not None
        
    def visualizar_conta(self, conta):
        if self.buscar_conta(conta.numero_conta):
            print(f'\nConta: {conta.numero_conta}')
            print(f'Cliente: {conta.cliente.nome}')
            print(f'Saldo: R${conta.saldo:.2f}')
            print(f'Tipo de conta: {conta.tipo_conta}')
            print(25 * '-')

    def cadastrar_cliente(self, cliente):
        if not isinstance(cliente, Cliente):
            return print('Cliente não é do tipo cliente.')

        if cliente.cpf in self.lista_de_clientes:
            return print('CPF já vinculado a um cliente.')

        self.lista_de_clientes[cliente.cpf] = cliente
        print(f'Cliente {cliente.nome} cadastrado com sucesso.')

    def criar_conta(self, cliente, tipo_conta):
        if not isinstance(cliente, Cliente):
            return print('Cliente não é do tipo cliente')
        if not self.buscar_cliente_pelo_cpf(cliente.cpf):
            return print('Cliente não cadastrado')
        nova_conta = ContaBancaria(cliente, tipo_conta)
        self.lista_de_contas.append(nova_conta)
        print(f'Conta {tipo_conta } criada com sucesso para {cliente.nome}.')
        
    def gerar_relatorio_contas(self):
        for conta in self.lista_de_contas:
            self.visualizar_conta(conta)
        self.calcular_total_depositado()

    def calcular_total_depositado(self):
        soma_depositos = 0
        for conta in self.lista_de_contas:
            soma_depositos += conta.saldo
        return f'\nTotal de todos depósitos: R${soma_depositos:.2f}'


def menu_conta(banco, numero_conta):
    os.system('cls')
    conta = banco.buscar_conta(numero_conta)
    while True:
        print('1 - Depositar')
        print('2 - Sacar')
        print('3 - Transferir')
        print('4 - Consultar saldo')
        print('5 - Consultar limite diário')
        print('6 - Voltar ao menu de Banco')
        try:
            opcao = int(input('Qual opção deseja escolher? '))
        except ValueError:
            print('Opção inválida.')
            continue

        if opcao == 1:
            os.system('cls')
            valor = input('Digite o valor para depositar: ')
            conta.depositar(valor)
        if opcao == 2:
            os.system('cls')
            valor = input('Digite o valor para sacar: ')
            conta.sacar(valor)
        if opcao == 3:
            os.system('cls')
            numero_outra_conta = input('Digite o número da outra conta para transferir: ')
            valor = input('Digite o valor a transferir: ')
            conta.transferir(banco, numero_outra_conta, valor)
        if opcao == 4:
            os.system('cls')
            conta.consultar_saldo()
        if opcao == 5:
            os.system('cls')
            conta.consultar_limite_saque()
        if opcao == 6:
            os.system('cls')
            print('Voltando ao menu anterior..')
            return False

def gerenciar_banco():
    os.system('cls')
    banco = Banco()
    while True:
        print('1 - Cadastrar cliente')
        print('2 - Cadastrar conta')
        print('3 - Visualizar conta')
        print('4 - Relatório de contas')
        print('5 - Menu de conta')
        print('6 - Sair')
        try:
            opcao = int(input('Qual opção deseja escolher? '))
        except ValueError:
            print('Opção inválida.')
            continue

        if opcao == 1:
            os.system('cls')
            nome = input('Insira o nome: ')
            cpf = input('Insira o CPF: ')
            data_nasc = input('Insira a data de nascimento: ')
            end = input('Insira o endereço completo: ')
            cliente = Cliente(nome, cpf, data_nasc, end)
            banco.cadastrar_cliente(cliente)

            # Dados para teste
            cliente1 = Cliente("João Silva", "123.456.789-00", "01/01/1990", "Rua A, 123")
            cliente2 = Cliente("Arthur", "789.456.123-00", "01/01/1990", "Rua A, 123")
            banco.cadastrar_cliente(cliente1)
            banco.cadastrar_cliente(cliente2)

        if opcao == 2:
            os.system('cls')
            cpf_cliente = input('Insira o CPF do cliente para cadastrar a conta: ')
            cliente = banco.buscar_cliente_pelo_cpf(cpf_cliente)
            print('Tipos de conta: corrente | poupança')
            tipo_conta = input('Insira o tipo de conta: ').lower().strip()
            if tipo_conta not in ['corrente', 'poupança']:
                print('Tipo de conta inválido.')
            banco.criar_conta(cliente, tipo_conta)

            # Dados para teste
            cpf_cliente = '123.456.789-00'
            cliente = banco.buscar_cliente_pelo_cpf(cpf_cliente)
            tipo_conta = 'corrente'
            banco.criar_conta(cliente, tipo_conta)
            cpf_cliente = '789.456.123-00'
            cliente = banco.buscar_cliente_pelo_cpf(cpf_cliente)
            tipo_conta = 'poupança'
            banco.criar_conta(cliente, tipo_conta)

        if opcao == 3:
            os.system('cls')
            numero_conta = input('Digite o número da conta: ')
            banco.visualizar_conta(banco.buscar_conta(numero_conta))

        if opcao == 4:
            os.system('cls')
            banco.gerar_relatorio_contas()

        if opcao == 5:
            os.system('cls')
            conta = input('Informe a conta para acessar: ')
            menu_conta(banco, conta)
        if opcao == 6:
            print('Saindo..')
            return False
        
gerenciar_banco()