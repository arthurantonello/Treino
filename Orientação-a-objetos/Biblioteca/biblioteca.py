#  Livro: Cada livro tem um título, autor e status (se está disponível ou emprestado).

class Livro:
    def __init__(self, titulo, autor):
        self.titulo = titulo
        self.autor = autor
        self.status = "disponível"

    def emprestar(self):
        if self.status == "disponível":
            self.status = "emprestado"
            return True
        else:
            return False
        
    def devolver(self):
        if self.status == "emprestado":
            self.status = "disponível"
            return True
        else:
            return False

#  Usuário: Cada usuário tem um nome, um número de identificação e uma lista de livros emprestados.
class Usuario:
    def __init__(self, nome, id_usuario):
        self.nome = nome
        self.id_usuario = id_usuario
        self.livros_emprestados = []

    def emprestar_livro(self, livro):
        if livro.emprestar():
            self.livros_emprestados.append(livro)
            print(f"O livro {livro.titulo} foi emprestado para {self.nome}")
        else:
            print(f"O livro {self.titulo} não está disponível")

    def devolver_livro(self,livro):
        if livro in self.livros_emprestados:
            livro.devolver()
            print(f"O livro {livro.titulo} foi devolvido por {self.nome}")
        else:
            print(f"O livro {self.titulo} não está emprestado para {self.nome}")

#  Biblioteca: A biblioteca gerencia os livros e usuários. Ela pode adicionar novos livros, cadastrar novos usuários e emprestar livros para usuários.

class Biblioteca:
    def __init__(self):
        self.livros = []
        self.usuarios = []

    def adicionar_livro(self, livro):
        self.livros.append(livro)

    def cadastrar_usuario(self, usuario):
        self.usuarios.append(usuario)
    
    def listar_livros(self):
        print("Lista de livros, disponíveis e emprestados")
        for livro in self.livros:
            print(f"{livro.titulo} - {livro.status}")

    def listar_livros_emprestados_usuario(self, usuario):
        print(f"Lista de livros emprestados para {usuario.nome}")
        for livro in usuario.livros_emprestados:
            print(livro.titulo)

def menu():
    print("""Bem vindo à Biblioteca, o que gostaria de fazer?
            1 - Adicionar livro
            2 - Adicionar usuário
            3 - Emprestar livro
            4 - Devolução de livro
            5 - Exibir lista de livros
            6 - Exibir lista de livros emprestados""")
    # inserir a opcao dentro do loop, usando try, if, elif e except ValueError
    opcao = int(input("Digite uma opção: "))
    while opcao != 0:
        if opcao == 1:
            titulo = input("Digite o título; ")
            autor = input("Digite o autor: ")
            Biblioteca.adicionar_livro(titulo, autor)
            print("Livro adicionado")
        
        if opcao == 2:
            nome == input("Digite o nome para o usuário: ")
            id_usuario == input("Digite o ID")
            Biblioteca.cadastrar_usuario(nome, id_usuario)
            print("Usuário cadastrado")