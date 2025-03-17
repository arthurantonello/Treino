import os
os.system('cls')

# recebe as palavras, passa para letra minúscula e remove espaços
entrada1 = input('Insira a primeira palavra: ').lower().replace(' ', '')
entrada2 = input('Insira a segunda palavra: ').lower().replace(' ', '')

# remove pontuações
entrada1 = entrada1.translate(str.maketrans('', '', string.punctuation))
entrada2 = entrada2.translate(str.maketrans('', '', string.punctuation))

palavra1 = sorted(entrada1)
palavra2 = sorted(entrada2)

if (palavra1 == palavra2):
    print('As palavras são anagramas!')
else:
    print('As palavras não são anagramas!')