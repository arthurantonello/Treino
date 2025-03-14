const prompt = require('prompt-sync')()

let x = parseInt(prompt('Insira o primeiro número: '))
let y = parseInt(prompt('Insira o segundo número: '))

let soma = (x,y) => {
    let resultado = x + y 
    console.log(`Sua soma resultou em ${resultado}`)
}

soma(x,y)
