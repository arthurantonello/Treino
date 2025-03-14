const operations = ["--X","X++","X++"]
let x = 0
operations.forEach((element)=>{
    if (element.includes('-')){
        x--
    }else {
        x++
    }
})
console.log(x)