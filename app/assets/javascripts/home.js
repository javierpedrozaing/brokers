$(document).on('turbolinks:load', function(){
  const multipleCardCarousel = document.querySelector(
    "#carouselExampleIndicators"
  );

  if (window.matchMedia("(min-width: 1200px)").matches) {
    var carousel = new bootstrap.Carousel(multipleCardCarousel, {
      interval: false,
    });
    var carouselWidth = $(".carousel-inner")[0].scrollWidth;
    var cardWidth = $(".carousel-item").width();
    var scrollPosition = 0;

    $(".carousel-control-next").on("click", function () {
      if (scrollPosition < carouselWidth - cardWidth * 4) {
        scrollPosition = scrollPosition + cardWidth;
        $(".carousel-inner").animate(
          { scrollLeft: scrollPosition },
          3000
        );
      }
    });
    $(".carousel-control-prev").on("click", function () {
      if (scrollPosition > 0) {
        scrollPosition = scrollPosition - cardWidth;
        $(".carousel-inner").animate(
          { scrollLeft: scrollPosition },
          3000
        );
      }
    });
  } else {
    $(multipleCardCarousel).addClass("slide");
  }
});