const prompt = require('prompt-sync')();

let valor = parseInt(prompt("Insira o valor: ")); // Garantir que o valor seja um número inteiro

function calc(valor){
    let resultado = [
        { nota: 'notaCem', quantidade: 0 },
        { nota: 'notaCinquenta', quantidade: 0 },
        { nota: 'notaVinte', quantidade: 0 },
        { nota: 'notaDez', quantidade: 0 },
        { nota: 'notaCinco', quantidade: 0 },
        { nota: 'notaDois', quantidade: 0 },
        { nota: 'notaUm', quantidade: 0 }
    ];

    // Laço para calcular as quantidades de notas
    while (valor > 0) {
        if (valor >= 100) {
            valor -= 100;
            resultado[0].quantidade++;
        } else if (valor >= 50) {
            valor -= 50;
            resultado[1].quantidade++;
        } else if (valor >= 20) {
            valor -= 20;
            resultado[2].quantidade++;
        } else if (valor >= 10) {
            valor -= 10;
            resultado[3].quantidade++;
        } else if (valor >= 5) {
            valor -= 5;
            resultado[4].quantidade++;
        } else if (valor >= 2) {
            valor -= 2;
            resultado[5].quantidade++;
        } else if (valor >= 1) {
            valor -= 1;
            resultado[6].quantidade++;
        }
    }

    // Exibindo o resultado
    console.log(`Seu valor foi separado em:`);
    console.log(`${resultado[0].quantidade} notas de 100`);
    console.log(`${resultado[1].quantidade} notas de 50`);
    console.log(`${resultado[2].quantidade} notas de 20`);
    console.log(`${resultado[3].quantidade} notas de 10`);
    console.log(`${resultado[4].quantidade} notas de 5`);
    console.log(`${resultado[5].quantidade} notas de 2`);
    console.log(`${resultado[6].quantidade} notas de 1`);
}

// Chamando a função
calc(valor);
