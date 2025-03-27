notas = []

for x in range(5):
    cadastro = input('Digite o RGM: ')
    nota = float(input('Digite a nota: '))
    resultado = [cadastro, nota]
    notas.append(resultado)

print(notas)
for n in notas:
    aluno = n[0]
    nota = n[1]
    print('O aluno ', aluno, 'tirou a nota ', nota)