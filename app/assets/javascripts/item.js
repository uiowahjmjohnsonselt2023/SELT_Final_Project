if (window.location.pathname.startsWith('/items/')) {
  document.addEventListener('DOMContentLoaded', function() {
    let slideIndex = 0;
    const slides = document.getElementsByClassName('item-carousel-image');
    const totalSlides = slides.length;

    function showSlide(index) {
      for (let slide of slides) {
        slide.style.display = 'none';
      }
      slideIndex = index;
      if (slideIndex >= totalSlides) { slideIndex = 0 }
      if (slideIndex < 0) { slideIndex = totalSlides - 1 }
      slides[slideIndex].style.display = 'block';
    }

    window.moveSlide = function(step) {
      showSlide(slideIndex + step);
    }

    showSlide(slideIndex);
  });
}
