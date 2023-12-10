if (window.location.pathname.startsWith('/search')) {
  document.addEventListener("DOMContentLoaded", function() {
    var button = document.getElementById('toggleButton');
    var form = document.getElementById('dropdownForm');

    button.addEventListener('click', function() {
      if (form.style.display === "none") {
        form.style.display = "block";
        button.textContent = "Hide Filters";
      } else {
        form.style.display = "none";
        button.textContent = "Show Filters";
      }
    });
  });
}
