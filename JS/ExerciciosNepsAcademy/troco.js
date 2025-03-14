let entrada = 80; // valor em centavos

let centavos = [0, 0, 0, 0, 0, 0]; //moedas de: 1, 50, 25, 10, 5, 1

function troco(valor) {
    let moedas = 0;
    
    // O loop vai continuar até que o valor se torne zero
    while (valor > 0) {  
        if (valor >= 100) {
            centavos[0]++; // Moeda de 1 real
            moedas++;
            valor -= 100;  // Subtrai 1 real
        } else if (valor >= 50) {
            centavos[1]++; // Moeda de 50 centavos
            moedas++;
            valor -= 50;  // Subtrai 50 centavos
        } else if (valor >= 25) {
            centavos[2]++; // Moeda de 25 centavos
            moedas++;
            valor -= 25;  // Subtrai 25 centavos
        } else if (valor >= 10) {
            centavos[3]++; // Moeda de 10 centavos
            moedas++;
            valor -= 10;  // Subtrai 10 centavos
        } else if (valor >= 5) {
            centavos[4]++; // Moeda de 5 centavos
            moedas++;
            valor -= 5;   // Subtrai 5 centavos
        } else if (valor >= 1) {
            centavos[5]++; // Moeda de 1 centavo
            moedas++;
            valor -= 1;   // Subtrai 1 centavo
        }
    }

    console.log(`
Quantidade de moedas: ${moedas}
Moedas de 1 real: ${centavos[0]}
Moedas de 50 centavos: ${centavos[1]}
Moedas de 25 centavos: ${centavos[2]}
Moedas de 10 centavos: ${centavos[3]}
Moedas de 5 centavos: ${centavos[4]}
Moedas de 1 centavo: ${centavos[5]}`);
}

troco(entrada);
