import os
import random

def carregar_palavras():
    print("Diretório atual:", os.getcwd())
    with open('palavras.txt', 'r', encoding= 'utf-8') as arquivo:
        palavras = arquivo.read().splitlines()
        return random.choice(palavras)
    
def definir_palavra_oculta(palavra_secreta):
    return ['_'] * len(palavra_secreta)

palavra_secreta = carregar_palavras()
palavra_oculta = definir_palavra_oculta(palavra_secreta)
letras_chutadas = []
erros = 0


def apresentacao():
    os.system('cls')
    print('*********************************')
    print('***Bem vindo ao jogo da Forca!***')
    print('*********************************') 

def chute():
    global erros
    print(palavra_oculta)
    chute = input('Qual letra deseja chutar? ').lower()
    os.system('cls')
    if chute in letras_chutadas:
        
        print('Letra já chutada, tente outra: ')
        chute()
    else:
        posicao = 0
        acertou_a_letra = False
        letras_chutadas.append(chute)
        for letra in palavra_secreta:
            if chute == letra:
                palavra_oculta[posicao] = letra
                posicao += 1
                print(f'Acertou na casa {posicao}')
                acertou_a_letra = True
            else:
                posicao += 1
        if not acertou_a_letra:
            print('Errou! Tente novamente')
            erros += 1

        print(25 * '-')
        print(f'Chutes:{letras_chutadas}')
        print(f'Erros: {erros}')
        print(25 * '-')

def testar_ganhador():
    global acertou
    if list(palavra_secreta) ==  palavra_oculta:
        print(25 * '-')
        print('Parabéns, você ganhou!')
        print(f'A palavra secreta era {palavra_secreta}')
        jogar_novamente()
    return False

def testar_perdedor(erros):
    enforcou = erros == 6
    if enforcou:
        print('O boneco foi enforcado, infelizmente você perdeu! ')
        print(25 * '-')
        jogar_novamente()
    return False

def jogar_novamente():
    print('Deseja jogar novamente? "S" ou "N"')
    tentar_novamente = input('').upper()
    if tentar_novamente == 'S':
        reiniciar_jogo()
        return False
    else:
        return True

def reiniciar_jogo():
    os.system('cls')
    global erros, palavra_oculta, letras_chutadas
    palavra_oculta = ['_', '_', '_', '_', '_', '_']
    letras_chutadas = []
    erros = 0

def jogada():
    apresentacao()
    while True:
        chute()
        testar_ganhador()
        if testar_perdedor(erros):
            break


jogada()