s = "ab-cd"

var reverseOnlyLetters = function(s) {
    if (1 <= s.length <= 100){
        let s_array = s.split("")
        let left = 0, aux = 0
        let right = s_array.length -1
        
        while (left < right){ //enquanto ponteiro left for menor que ponteiro right
            if (!(/^[a-zA-Z]$/.test(s_array[left]))){ //testa se é uma letra
                left++
            }
            else if (!(/^[a-zA-Z]$/.test(s_array[right]))){ //testa se é uma letra
                right--
            }
            else{ //se forem letras, eles trocam de lugar utilizando uma variável auxiliar
                aux = s_array[left]
                s_array[left] = s_array[right]
                s_array[right] = aux
                left++
                right--
            }
        }
        console.log(s_array.join(""))
    }
};
console.log(s)
reverseOnlyLetters(s)
