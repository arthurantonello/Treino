import re

cpf = '864.689.950-00'

cpf_numerico = [int(digito) for digito in re.sub(r'\D', '', cpf)]


def calcular_digito_verificador(cpf_numerico,  qtd_peso):
    peso = qtd_peso + 1
    soma = 0
    final = 11
    for i in range(peso):
        soma += cpf_numerico[i] * peso
    resultado = (soma * 10) % 11
    return 0 if resultado == 10 else resultado
        

def verificador():
    if len(cpf_numerico) != 11:
        print('❌ CPF inválido')
        return False


    primeiro_digito = calcular_digito_verificador(cpf_numerico, 9)
    segundo_digito = calcular_digito_verificador(cpf_numerico, 10)

    if cpf_numerico[9] == primeiro_digito and cpf_numerico[10] == segundo_digito:
        print('✅ CPF válido')
        return True
    else:
        print('❌ CPF inválido')
        return False


verificador()

