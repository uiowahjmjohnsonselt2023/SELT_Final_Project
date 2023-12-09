document.addEventListener('DOMContentLoaded', function() {
  var countrySelect = document.getElementById('country');
  var stateSelect = document.getElementById('state-select');
  countrySelect.addEventListener('change', function() {
    stateSelect.style.display = countrySelect.value === 'United States of America' ? 'block' : 'none';
  });
});


document.addEventListener('DOMContentLoaded', function() {
  var monthSelect = document.querySelector('#expiration_month');
  var yearSelect = document.querySelector('#expiration_year');
  var today = new Date();
  var currentYear = today.getFullYear();
  var currentMonth = today.getMonth() + 1;

  yearSelect.min = currentYear;

  if (currentMonth === 12) {
    yearSelect.value = currentYear + 1;
    monthSelect.value = 1;
  } else {
    yearSelect.value = currentYear;
    monthSelect.value = currentMonth;
  }
});

document.addEventListener('DOMContentLoaded', function() {
  var cardNumberInput = document.querySelector('.card-number-input');

  cardNumberInput.addEventListener('input', function(e) {
    var target = e.target;
    var value = target.value.replace(/\D/g, '').substring(0, 16); // Remove non-digits and limit to 16

    // Only process further if there's a value
    if (value) {
      var parts = value.match(/\d{1,4}/g); // Match groups of up to 4 digits
      if (parts) {
        target.value = parts.join(' '); // Rejoin the matched groups with a space
      }
      var position = target.selectionStart; // Get the cursor position
      if (position % 5 === 0 && position < target.value.length) {
        position++; // Adjust cursor position if it's at the spacing
      }
      target.setSelectionRange(position, position);
    } else {
      target.value = ''; // If there's no value, set the input to an empty string
    }
  }, false);
});

