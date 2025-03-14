const nums = [5,0,1,2,3,4]
const ars = []

nums.forEach(function(element, index){
    ars[index] = nums[nums[index]]
})    
console.log(ars)