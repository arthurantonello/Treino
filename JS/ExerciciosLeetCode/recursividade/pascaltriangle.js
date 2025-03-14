var generate = function(numRows) {
    // Se o número de linhas for menor que 1, retorna um array vazio
    if(numRows < 1) return [];
    
    // Se o número de linhas for 1, retorna o triângulo de Pascal com apenas a primeira linha
    if(numRows === 1) return [[1]];

    // Inicializa o triângulo com a primeira linha contendo apenas o número 1
    const triangle = [[1]];

    // Loop para construir cada linha do triângulo, começando da segunda linha (índice 1)
    for(let i = 1; i < numRows; i++) {
        // Obtém a linha anterior do triângulo
        let prevRow = triangle[i - 1];
        
        // Inicializa a nova linha atual
        const curRow = [];

        // O primeiro elemento da linha sempre é 1
        curRow.push(1);

        // Preenche os valores internos da linha (exceto as bordas)
        for(let j = 1; j < prevRow.length; j++) {
            // Cada número é a soma dos dois números diretamente acima na linha anterior
            curRow[j] = prevRow[j] + prevRow[j - 1];
        }

        // O último elemento da linha sempre é 1
        curRow.push(1);

        // Adiciona a linha atual ao triângulo
        triangle.push(curRow);
    }

    // Retorna o triângulo de Pascal gerado
    return triangle;
};
