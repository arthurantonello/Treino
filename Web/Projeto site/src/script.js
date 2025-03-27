const areas = {
    front : 'Aprenda React ou Vue',
    back : 'Aprenda C# ou Java' 
}

function aparecePrompt(){
    let resposta = prompt(`Qual área decide seguir, "front" ou "back"?`)
    if(areas.hasOwnProperty(resposta)){
        alert(areas[resposta])
        console.log(resposta)
    }else{
        let erro = alert('Área não encontrada, vamos tentar novamente')
            aparecePrompt()
    }
}
