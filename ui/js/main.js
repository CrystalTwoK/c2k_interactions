let interactionActive = false
let container = document.querySelector('.interaction-container');

$(document).ready(function () {
  window.addEventListener("message", function (event) {
    const data = event.data;
    if (data.type == "showNotify") {
      console.log('inside show');
      showNotification(data.label, data.img, data.button);
    } else if (data.type == "hideNotify"){
      console.log('inside hide');
      hideNotification();
    }
  });


  function showNotification(label, img, button){
    interactionActive = true;
    $("body").removeClass('hidden');
    container.innerHTML = `
    <div class="interaction-img"><img src="${img}"></div>
        <div class="interaction-text">   
            <div class="interaction-text-container">    
                <h1 class="animate__animated animate__fadeInDown">${label}</h1>
                <p class="animate__animated animate__fadeInDown">PREMI <button>${button.toUpperCase()}</button> PER INTERAGIRE</p>
            </div> 
        </div>`;
  }

  function hideNotification(){
    interactionActive = false;
    $("body").addClass('hidden');
    container.innerHTML = '';
  }

});