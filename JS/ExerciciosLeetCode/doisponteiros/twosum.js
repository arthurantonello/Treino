const nums = [2,7,11,15], target = 9
nums.sort((a, b) => a-b) //Ordena crescentemente

var twoSum = function(nums, target) { 
    if (nums.length < 2 || nums.length >= (10**4)){ //Restrições
        return -1
    }else{
        let i = 0 //Ponteiro 1
        let j = nums.length - 1 //Ponteiro 2

        while (i < j){
            let soma = nums[i] + nums[j] 
            if (soma == target) return [nums[i], nums[j]] //Caso o ponteiro 1 e 2 já estejam nos números necessários
            
            if (soma > target) j-- //Se a soma der maior que o target, diminui o ponteiro 2 no final da lista
            else i++ ///Se a soma der menor que o target, aumenta o ponteiro 2 no início da lista
        }
    }
    return [] //Retorna um array vazio caso não haja a soma
};

console.log(twoSum(nums,target))