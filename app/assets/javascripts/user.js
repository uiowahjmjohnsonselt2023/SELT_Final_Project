
document.addEventListener('DOMContentLoaded', function() {
  var countrySelect = document.getElementById('country');
  var stateSelect = document.getElementById('state-select');
  countrySelect.addEventListener('change', function() {
    stateSelect.style.display = countrySelect.value === 'United States of America' ? 'block' : 'none';
  });
});


document.addEventListener('DOMContentLoaded', function() {
  var expirationInput = document.querySelector('.expiration-date-input');
  var today = new Date();
  var month = today.getMonth() + 1; // getMonth() is zero-indexed
  var year = today.getFullYear();

  // Pad the month with a leading zero if necessary
  if (month < 10) {
    month = '0' + month;
  }

  // Set the min attribute to the current month and year
  expirationInput.min = year + '-' + month;
});
