const prompt = require('prompt-sync')();



//quantidade de leds necessários para cada número
const pesoLeds = [
    { numero: 0, leds: 6 },
    { numero: 1, leds: 2 },
    { numero: 2, leds: 5 },
    { numero: 3, leds: 5 },
    { numero: 4, leds: 4 },
    { numero: 5, leds: 5 },
    { numero: 6, leds: 6 },
    { numero: 7, leds: 3 },
    { numero: 8, leds: 7 },
    { numero: 9, leds: 6 }
];

//separar os números em um array


//adiciona a posição i do arrayLeds na auxiliar e soma na contagem o peso correspondente
function contagemLeds (arrayLeds){
    let contagem = 0
    for (let i = 0; i < arrayLeds.length; i++){
        let digito = arrayLeds[i]
        contagem += pesoLeds[digito].leds
    }
    console.log(`${arrayLeds}  |  ${contagem}`)
}

function quantosLeds(){
    let qtdTestes = parseInt(prompt("Insira a quantidade de testes: ")); 
    console.log(qtdTestes)
    for(let i = 0; i < qtdTestes; i++){
        let numLeds = []
        numLeds[i] = parseInt(prompt("Insira o número a ser mostrado: "));
        let arrayLeds = numLeds[i].toString().split("")
        contagemLeds(arrayLeds)
    }
}

quantosLeds()
