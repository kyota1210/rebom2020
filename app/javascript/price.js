function price (){
  const itemPrice = document.getElementById("item-price");
  itemPrice.addEventListener('keyup', ()=>{
    const itemPriceVal = itemPrice.value
    const itemAddTax = Math.floor(itemPrice.value / 10);
    const addTaxPrice = document.getElementById("add-tax-price");
    const profit = document.getElementById("profit");
    addTaxPrice.innerHTML = itemAddTax;
    profit.innerHTML = Math.floor(itemPriceVal - itemAddTax);
   });
}

setInterval(price, 1000);