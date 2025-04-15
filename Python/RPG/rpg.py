# preciso iterar em cada onda
# a cada turno, atacar a vida_da_onda
# se a vida da onda for > 0 ataca 
# atualiza a vida da onda para vida_da_onda - habilidade_de_ataque
# diminui 1 de ataque no final
# aumenta qtd_turnos
# aumenta 5 na habilidade_de_ataque a cada onda

def calcular_turnos_defesa(ondas, habilidade_de_ataque):
    qtd_turnos = 0
    for onda in ondas:
        vida_da_onda = onda['inimigos'] * onda[ 'vidaInimigo']
        while vida_da_onda > 0:
            if habilidade_de_ataque <= 0:
                return -1
            vida_da_onda = vida_da_onda - habilidade_de_ataque # ataque
            habilidade_de_ataque = habilidade_de_ataque - 1
            qtd_turnos = qtd_turnos + 1
        
        habilidade_de_ataque = habilidade_de_ataque + 5
    
    return qtd_turnos

# Caso 1
ondas1 = [
    {'inimigos': 10, 'vidaInimigo': 25},
    {'inimigos': 5, 'vidaInimigo': 100},
    {'inimigos': 2, 'vidaInimigo': 200}
]
habilidade1 = 40
print(calcular_turnos_defesa(ondas1, habilidade1))  # Esperado: -1

# Caso 2
ondas2 = [
    {'inimigos': 10, 'vidaInimigo': 15},
    {'inimigos': 5, 'vidaInimigo': 60}
]
habilidade2 = 100
print(calcular_turnos_defesa(ondas2, habilidade2))  # Esperado: 5

# Caso 3
ondas3 = [
    {'inimigos': 5, 'vidaInimigo': 75},
    {'inimigos': 3, 'vidaInimigo': 150}
]
habilidade3 = 50
print(calcular_turnos_defesa(ondas3, habilidade3))  # Esperado: 20