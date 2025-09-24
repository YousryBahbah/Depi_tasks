const btn1 = document.getElementById("btn1");
const btnDark = document.getElementById("btn-dark");
const btnLight = document.getElementById("btn-light");
const p1 = document.getElementById("p1");
const username = document.getElementById("username");
const fonts = document.getElementById("fonts");
btn1.onclick = function (){
    if(username.value){
        p1.innerText = `welcome ${username.value}`;
        username.value = "";
    }
}
btnDark.onclick = function (){
    document.body.classList.add("dark")
    document.body.classList.remove("light")
}
btnLight.onclick = function (){
    document.body.classList.add("light")
    document.body.classList.remove("dark")
}
username.onkeyup = () => {
    p1.innerText = username.value;
}
p1.onmouseover = function (){
    this.style.backgroundColor = "brown";
    this.style.color = "#fff";
}
p1.onmouseout = function (){
    this.style.backgroundColor = "hotpink";
    this.style.color = "#fff";
}
fonts.onchange = function(){
    p1.style.fontSize = this.value;
}