document.addEventListener("DOMContentLoaded", function() {
  let button = document.getElementById('toggleButton');
  let form = document.getElementById('dropdownForm');

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
