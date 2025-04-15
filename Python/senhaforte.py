import os,string
os.system('cls')

senha = input('Digite uma senha forte para verificar se é forte: ')

def forcaSenha(senha):
    senha_forte = True
    if not any(char in string.punctuation for char in senha):
        print('Insira ao menos um caractere especial')
        senha_forte = False
    if len(senha) < 8:
        print('Insira ao menos 8 caracteres')
        senha_forte = False
    if not any(char.isdigit() for char in senha):
        print('Insira ao menos um número')
        senha_forte = False
    if senha.lower() == senha:
        print('Digite ao menos uma letra maíscula')
        senha_forte = False
    if senha.upper() == senha:
        print('Digite ao menos uma letra minúscula')
        senha_forte = False
    if senha_forte:
        print ('A senha ', senha, ' é forte')
        return senha
    else:
        print('A senha não é forte')

forcaSenha(senha)
