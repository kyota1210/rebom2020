function count (){
  const postText = document.getElementById("post_text")
  postText.addEventListener('keyup', () =>{
    const countVal = postText.value.length;
    const charNum = document.getElementById("char-num");
    charNum.innerHTML = `${countVal}文字`;

    if(countVal > 200){
      charNum.setAttribute("style", "color:red")
    }else{
      charNum.setAttribute("style", "color: #354e59")
    }
  });
}

window.addEventListener('load', count);