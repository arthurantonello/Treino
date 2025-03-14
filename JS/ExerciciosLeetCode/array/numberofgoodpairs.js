const nums = [1,1,1,1]

goodpair = () => {
    let contagem = 0
    
    for (let i = 0; i < nums.length; i++){
        for (let j = i + 1; j< nums.length; j++){
            if (nums[i] === nums[j]){
                contagem++
            }
        }
    }
    console.log(contagem)
}

goodpair()