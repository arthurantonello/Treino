let n = "1 1 1 20 20 20 20 3 3 3 3 3 3 3"

let valores = n.split(" ").map(num => parseInt(num));

function sequencia(entrada){
    let contagem = 1;  // Contagem da sequência atual
    let maiorSequencia = contagem;  // Maior sequência encontrada

    for (let i = 1; i < entrada.length; i++) {
        if (entrada[i] === entrada[i - 1]) {
            contagem++;  // Incrementa a sequência se o número for igual ao anterior
        } else {
            // Se a sequência atual for maior que a maior sequência encontrada
            if (contagem > maiorSequencia) {
                maiorSequencia = contagem;  // Atualiza a maior sequência
            }
            contagem = 1;  // Reinicia a contagem para o novo número
        }
    }

    // Verifica a última sequência após o final do loop
    if (contagem > maiorSequencia) {
        maiorSequencia = contagem;
    }

    console.log(
        `Total de elementos: ${entrada.length}
A maior sequência é de ${maiorSequencia} elementos.`);
}

sequencia(valores)