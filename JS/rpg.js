// Em jogos de defesa, onde é necessário proteger uma área, podemos ter múltiplas ondas de inimigos que vão chegando com força crescente. Cada onda tem um número de inimigos, e cada inimigo tem um valor de vida. Sua tarefa é calcular a quantidade total de turnos de ataque necessários para o defensor vencer todos os inimigos de todas as ondas com base em sua habilidade de ataque.

// Cada onda terá um número de inimigos e uma quantidade de vida por inimigo. Você tem uma habilidade de ataque que diminui em 1 a cada turno, mas que aumenta em 5 ao final de cada onda e assim pode derrotar os inimigos rapidamente.

// O ataque da sua habilidade sempre irá tirar o equivalente ao poderDeHabilidade. Caso você tenha um poderDeHabilidade de 50, um inimigo tenha 30 de vida e outro tenha também os 30, você irá matar o primeiro e deixar o segundo com 10 de vida.

// Quando a vida de um inimigo chega a 0 ou abaixo, ele é derrotado e somente após todos os inimigos de uma onda serem derrotas, inicia-se a próxima onda. Caso o seu dano chegue a 0 antes finalizar todas as ondas, o defensor perde e deve retornar -1 como o número de turnos.


// preciso iterar em cada onda
// a cada turno, atacando a vida_da_onda
// se a vida do inimigo for > 0 ataca 
// atualiza a vida do inimigo para vida_da_onda -= habilidade_de_ataque
// diminui 1 de ataque no final
// aumenta qtd_turnos
// aumenta 5 na habilidade_de_ataque a cada onda

function calcular_turnos_defesa(ondas, habilidade_de_ataque){
    let qtd_turnos = 0
    for (let onda of ondas){
        let vida_da_onda = onda.inimigos * onda.vidaInimigo
        while (vida_da_onda > 0){
            if (habilidade_de_ataque <= 0){
                return -1
            }
            vida_da_onda -= habilidade_de_ataque // ataque
            habilidade_de_ataque--
            qtd_turnos++
        }
        habilidade_de_ataque += 5
    }
    return qtd_turnos
}

//Caso 1
const ondas1 = [
    { inimigos: 10, vidaInimigo: 25 },
    { inimigos: 5, vidaInimigo: 100 },
    { inimigos: 2, vidaInimigo: 200 }];
let habilidade1 = 40;

console.log(calcular_turnos_defesa(ondas1, habilidade1)); // Esperado: -1

// Caso 2
const ondas2 = [
    { inimigos: 10, vidaInimigo: 15 },
    { inimigos: 5, vidaInimigo: 60 }
];
let habilidade2 = 100;

console.log(calcular_turnos_defesa(ondas2, habilidade2)); // Esperado: 5

// Caso 3
const ondas3 = [
{ inimigos: 5, vidaInimigo: 75 },
{ inimigos: 3, vidaInimigo: 150 }
];
let habilidade3 = 50;

console.log(calcular_turnos_defesa(ondas3, habilidade3)); // Esperado: 20