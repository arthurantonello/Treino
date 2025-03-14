const prompt = require('prompt-sync')();

let valor1 = parseInt(prompt("Insira o primeiro valor: "));
let valor2 = parseInt(prompt("Insira o segundo valor: "));

function calc(valor1,valor2){
    let soma = valor1 + valor2
    if (soma % 2 == 0)console.log ("0")
    else console.log(soma)
}

calc(valor1,valor2)