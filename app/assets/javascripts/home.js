
  window.addEventListener('DOMContentLoaded', (event) => {
  const container = document.getElementById('suggested-items');
  let scrollAmount = 0;
  const scrollStep = 300;
  const maxScroll = container.scrollWidth - container.clientWidth;

  document.getElementById('scroll-left').addEventListener('click', () => {
  scrollAmount -= scrollStep;
  if(scrollAmount < 0) {
  scrollAmount = 0;
}
  container.scrollLeft = scrollAmount;
});

  document.getElementById('scroll-right').addEventListener('click', () => {
  scrollAmount += scrollStep;
  if(scrollAmount > maxScroll) {
  scrollAmount = maxScroll;
}
  container.scrollLeft = scrollAmount;
});
});

