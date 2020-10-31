function pullDown() {
  const pullDownButton = document.getElementById("label1")
  const pullDownShow = document.getElementById("pulldown-show")

  pullDownButton.addEventListener('mouseover', function(){
    this.setAttribute("style", "background-color:#354e59;")
  })
  pullDownButton.addEventListener('mouseout', function(){
    this.removeAttribute("style", "background-color:#354e59;")
  })

  pullDownButton.addEventListener('click', function() {
    if (pullDownShow.getAttribute("style") == "display:block;") {
      pullDownShow.removeAttribute("style", "display:block;")
    } else {
      pullDownShow.setAttribute("style", "display:block;")
    }
  })
}

window.addEventListener('load', pullDown)