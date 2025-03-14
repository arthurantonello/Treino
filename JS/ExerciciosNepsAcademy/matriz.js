let entradas = [
    [2, 7, 6],
    [9, 5, 1],
    [4, 3, 8]
]

function somaEntradas(){
    let soma = []
    for (let i = 0; i < entradas.length; i++){
        soma[i] = 0
        for (let j = 0; j < entradas[i].length; j++){
            soma[i] += parseInt(entradas[i][j])
            
        }
        console.log(`Soma da linha ${i}: ${soma[i]}\n`)
    }
}

somaEntradas()