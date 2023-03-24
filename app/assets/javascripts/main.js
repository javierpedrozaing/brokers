
$(document).on('turbolinks:load', function(){
  /**
   * Mobile nav toggle
   */
  $('.mobile-nav-toggle').on("click", function() {
    console.log("click button");
    $('#navbar').toggleClass('navbar');
    $('#navbar').toggleClass('navbar-mobile');
    $('.mobile-nav-toggle').toggleClass('fa-bars');
    $('.mobile-nav-toggle').toggleClass('fa-rectangle-xmark');
  });

  $('.navbar .dropdown > a').on('click', function(e){
    if ($('#navbar').hasClass('navbar-mobile')){
      e.preventDefault()
      $(this).next("ul").toggleClass('dropdown-active');
    }    
    return true;
  });

  $("input[type='radio']").on("click", function() {
    $('.close-transaction-fields').css("display", "none");
  });

  $('#user_state_close').on('click', function() {
    $('.close-transaction-fields').css("display", "block");
  });
  if ($("#user_state_close").is(":checked")) {
    $('.close-transaction-fields').css("display", "block");
  }
 
});