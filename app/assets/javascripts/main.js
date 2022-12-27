$( document ).ready(function() {  
  /**
   * Mobile nav toggle
   */
  $('.mobile-nav-toggle').on("click", function(){
    $('#navbar').toggleClass('navbar');
    $('#navbar').toggleClass('navbar-mobile');
    $('.mobile-nav-toggle').toggleClass('fa-bars');
    $('.mobile-nav-toggle').toggleClass('fa-rectangle-xmark');    
  });
   
});