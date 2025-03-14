let nums = [7,1,5,4,3,4,6,0,9,5,8,2]
let aux = []
let output = []

for (let i = 0; i < nums.length; i++){
    aux.push(nums[i - 1])
    if (aux.includes(nums[i])) output.push(nums[i])   
}

console.log(output)