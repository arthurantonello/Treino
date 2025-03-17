let contagem = 0
function hanoi(N, Orig, Dest, Temp) {
    contagem++
    if (N === 1) {
        console.log(`Mover o disco 1 de ${Orig} para ${Dest}`);
    } else {
        // Mover N-1 discos de Orig para Temp usando Dest como auxiliar
        hanoi(N - 1, Orig, Temp, Dest);
        
        // Mover o disco N de Orig para Dest
        console.log(`Mover o disco ${N} de ${Orig} para ${Dest}`);
        
        // Mover os N-1 discos de Temp para Dest usando Orig como auxiliar
        hanoi(N - 1, Temp, Dest, Orig);
    }
}

// Exemplo de chamada para 3 discos
hanoi(3, 'A', 'C', 'B');
console.log(`Total de movimentos: ${contagem}`)
