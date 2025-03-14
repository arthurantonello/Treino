const prompt = require('prompt-sync')()

let str1 = prompt("Insira a primeira frase: ")
let str2 = prompt("Insira a segunda frase: ")


function comparaString(str1,str2){
    let tabela = Array(str1.length + 1)
    for (let i = 0; i< tabela.length; i++){
        tabela[i] = Array(str2.length + 1).fill(0)
    }

    let maiorComprimento = 0
    let indiceFinal = 0

    for (let i = 1; i < str1.length; i++){
        for (let j = 1; j < str2.length; j++){
            if (str1[i - 1] === str2[j - 1]){
                tabela[i][j] = tabela[i - 1][j - 1] + 1

                if (tabela[i][j] > maiorComprimento){
                    maiorComprimento = tabela[i][j]
                    indiceFinal = i
                }
            }else {
                tabela[i][j] = 0
            }
        }
    }
    return str1.slice(indiceFinal - maiorComprimento, indiceFinal)
}

let resultado = comparaString(str1, str2)

console.log(resultado)