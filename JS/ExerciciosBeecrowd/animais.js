const prompt = require('prompt-sync')()

const tabela = {
    vertebrado: {
        ave: {
            carnivoro: "aguia",
            onivoro: "pomba"
        },
        mamifero: {
            onivoro: "homem",
            herbivoro: "vaca"
        }
    },
    invertebrado: {
        inseto: {
            hematofago: "pulga",
            herbivoro: "lagarta"
        },
        anelideo:{
            hematofago: "sanguessuga",
            onivoro: "minhoca"
        }
    }
}

function buscarAnimal(obj, caminho){
    let valor = obj
    for (let chave of caminho){
        if (valor[chave] !== undefined){
            valor = valor[chave];  // Acessa a chave do objeto
        } else {
            return `Caminho ${caminho.join(' -> ')} não encontrado!`;  // Caso algum nível não exista
        }
    }
    return valor
}

let chavesInput = prompt("Insira as chaves separadas por espaço: ")

let caminho = chavesInput.trim().split(" ")

let resultado = buscarAnimal(tabela, caminho);
console.log(resultado); // Exibe o resultado ou erro