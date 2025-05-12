from datetime import date, timedelta

class Livro():
    def __init__(self, titulo, autor, ano_publicacao, disponivel = True):
        self.titulo = titulo
        self.autor = autor
        self.ano_publicacao = ano_publicacao
        self.disponivel = bool(disponivel)

    def alterar_o_status(self):
        self.disponivel = not(self.disponivel)

class Usuario(): # base para aluno e professor
    id = 1
    def __init__(self, nome):
        self.nome = nome
        self.id = Usuario.id
        Usuario.id += 1
        self.tipo = None
        self.limite_de_livros = None
        self.prazo_de_devolucao = None
        self.lista_de_livros = []

    def visualizar_usuario(self):
        print(f'{self.nome}')
        print(f'{self.id}')
        print(f'{self.tipo}')
        print()

    def visualizar_lista_de_livros(self):
        for emprestimo in self.lista_de_livros:
            livro = emprestimo.livro
            print(f'Título: {livro.titulo}')
            print(f'Autor: {livro.autor}')
            print(f'Ano: {livro.ano_publicacao}')
            print(f'Emprestado em: {emprestimo.data_de_emprestimo.strftime("%d/%m/%Y")}')
            print(f'Devolução prevista: {emprestimo.data_de_devolucao.strftime("%d/%m/%Y")}')
            print()

    def pode_emprestar(self):
        return len(self.lista_de_livros ) < self.limite_de_livros

class Aluno(Usuario):
    def __init__(self, nome):
        super().__init__(nome)
        self.tipo = 'Aluno'
        self.limite_de_livros = 3
        self.prazo_de_devolucao = 7

class Professor(Usuario):
    def __init__(self, nome):
        super().__init__(nome)
        self.tipo = 'Professor'
        self.limite_de_livros = 5
        self.prazo_de_devolucao = 30

class Biblioteca():
    def __init__(self):
        self.lista_de_livros = []
        self.lista_de_usuarios = []

    def cadastrar_livro(self, livro):
        if isinstance(livro, Livro):
            self.lista_de_livros.append(livro)
        else:
            print('Insira um livro válido')

    def cadastrar_usuario(self, tipo, nome): 
        if tipo.lower() == 'aluno':
            usuario = Aluno(nome)
        elif tipo.lower() == 'professor':
            usuario = Professor(nome)
        else:
            print('Tipo de usuário inválido')
            return
        self.lista_de_usuarios.append(usuario)
        print(f'{tipo.title()} {nome} cadastrado com sucesso')
        return usuario

    def visualizar_lista_de_usuarios(self):
        for usuario in self.lista_de_usuarios:
            usuario.visualizar_usuario()
    
    def emprestar_livro(self, usuario, livro):
        if isinstance(usuario, Usuario):
            if isinstance(livro, Livro):
                if not livro.disponivel:
                    print(f'O livro {livro.titulo} não está disponível.')
                if usuario.pode_emprestar():
                    livro.alterar_o_status()
                    hoje = date.today()
                    devolucao = hoje + timedelta(days = usuario.prazo_de_devolucao)
                    emprestimo = Emprestimo(livro, hoje, devolucao)
                    usuario.lista_de_livros.append(emprestimo)
                    print(f'O livro {livro.titulo} foi emprestado para {usuario.nome} com sucesso.')
                else:
                    print(f'O {usuario.tipo} {usuario.nome} atingiu o limite de empréstimos.')
            else:
                print('Favor inserir um livro válido.')
        else:
            print('Favor inserir um usuário válido.')
            
        #atualiza status e regista data do empréstimo e devolucao

    def devolver_livro(self, usuario, livro):
        if isinstance(usuario, Usuario):
            if isinstance(livro, Livro):
                for emprestimo in usuario.lista_de_livros:
                    if emprestimo.livro == livro:
                        livro.alterar_o_status()
                        usuario.lista_de_livros.remove(emprestimo)
                        print(f'O livro {livro.titulo} foi devolvido por {usuario.nome} com sucesso.')
                        return
                print(f'O {usuario.tipo} {usuario.nome} não possui esse livro emprestado.')
            else:
                print('Favor inserir um livro válido.')
        else:
            print('Favor inserir um usuário válido.')

    def visualizar_lista_de_livros(self):
        print('----- LISTA DE LIVROS CADASTRADOS -----')
        for livro in self.lista_de_livros:
            print(f'Título: {livro.titulo}')
            print(f'Autor: {livro.autor}')
            print(f'Ano de publicação: {livro.ano_publicacao}')
            print(f'Disponível: {"Sim" if livro.disponivel else "Não"}')
            print()
    
    def listar_livros_emprestados_para(self, usuario):
        if isinstance(usuario, Usuario):
            print(f'---- Livros emprestados para o {usuario.tipo} {usuario.nome} ----')
            for emprestimo in usuario.lista_de_livros:
                livro = emprestimo.livro
                print(f'Título: {livro.titulo}')
                print(f'Autor: {livro.autor}')
                print(f'Ano de publicação: {livro.ano_publicacao}')
                print()
        else:
            print('Favor inserir um usuário válido.')
class Emprestimo():
    def __init__(self, livro, data_de_emprestimo, data_de_devolucao):
        self.livro = livro
        self.data_de_emprestimo = data_de_emprestimo
        self.data_de_devolucao = data_de_devolucao

biblioteca = Biblioteca()

# Cadastro de usuários
aluno1 = biblioteca.cadastrar_usuario('Aluno', 'Arthur')
professor1 = biblioteca.cadastrar_usuario('Professor', 'Elmario')

# Cadastro de livros
livro1 = Livro("Dom Casmurro", "Machado de Assis", 1899)
biblioteca.cadastrar_livro(livro1)
livro2 = Livro("O Hobbit", "J.R.R. Tolkien", 1937)
biblioteca.cadastrar_livro(livro2)
livro3 = Livro("Harry Potter e a Pedra Filosofal", "J.K. Rowling", 1997)
biblioteca.cadastrar_livro(livro3)
livro4 = Livro("Orgulho e Preconceito", "Jane Austen", 1813)
biblioteca.cadastrar_livro(livro4)
livro5 = Livro("A Revolução dos Bichos", "George Orwell", 1945)
biblioteca.cadastrar_livro(livro5)
livro6 = Livro("Capitães da Areia", "Jorge Amado", 1937)
biblioteca.cadastrar_livro(livro6)


# Empréstimo de livros
biblioteca.emprestar_livro(professor1, livro1)
biblioteca.emprestar_livro(professor1, livro2)
# biblioteca.emprestar_livro(professor1, livro3)
# biblioteca.emprestar_livro(professor1, livro4)
# biblioteca.emprestar_livro(professor1, livro5)
# biblioteca.emprestar_livro(professor1, livro6)

# Devolução de livros
# biblioteca.devolver_livro(professor1, livro1)

# Visualização
# biblioteca.visualizar_lista_de_usuarios()
# biblioteca.visualizar_lista_de_livros()
# biblioteca.listar_livros_emprestados_para(professor1)
# professor1.visualizar_lista_de_livros()