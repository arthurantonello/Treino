function bissextoOuNao(ano){
    return (ano % 4 == 0 || (ano % 400 == 0 && ano % 100 != 0))
}

function huluculuOuNao(ano){
    return (ano % 15 == 0)
}

function bulukuluOuNao(ano){
    return (ano % 55 == 0 && bissextoOuNao(ano))
}

function anoEspecialOuNao(ano){
    console.log(`Ano: ${ano}`)
    if ((bissextoOuNao(ano) && huluculuOuNao(ano) && bulukuluOuNao) == false){
        return console.log ('Esse ano não há novidades')
    }else{
        if (bissextoOuNao(ano)) console.log (`Ano bissexto`)
        if (huluculuOuNao(ano)) console.log (`Ano do festival Huluculu`)
        if (bulukuluOuNao(ano)) console.log (`Ano do festival Bulukulu`)
    }
}

anoEspecialOuNao(2640)