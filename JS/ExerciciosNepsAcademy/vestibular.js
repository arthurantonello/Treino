let qtdQuestoes = 7
let gabarito = "ABCDEABCDE"
let candidato = "BCDEABCDEA".toUpperCase()

let arrGabarito = gabarito.split("")
let arrCandidato = candidato.split("")

let acertos = 0

for (let i = 0; i < arrGabarito.length; i++){
        if (arrGabarito[i] == arrCandidato[i]){
            acertos++
        }
}

console.log(`Quantidade de questões: ${qtdQuestoes}
Quantidade de acertos: ${acertos}`)