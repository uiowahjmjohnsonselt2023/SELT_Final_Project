if (window.location.pathname === '/users') {
  document.addEventListener('DOMContentLoaded', function() {
    // Code for handling countrySelect and stateSelect
    var countrySelect = document.getElementById('country');
    var stateSelect = document.getElementById('state-select');
    countrySelect.addEventListener('change', function() {
      stateSelect.style.display = countrySelect.value === 'United States of America' ? 'block' : 'none';
    });

    // Code for handling monthSelect and yearSelect
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

    // Code for handling cardNumberInput
    var cardNumberInput = document.querySelector('.card-number-input');

    cardNumberInput.addEventListener('input', function(e) {
      var target = e.target;
      var value = target.value.replace(/\D/g, '').substring(0, 16);

      // Only process further if there's a value
      if (value) {
        var parts = value.match(/\d{1,4}/g);
        if (parts) {
          target.value = parts.join(' ');
        }
        var position = target.selectionStart;
        if (position % 5 === 0 && position < target.value.length) {
          position++;
        }
        target.setSelectionRange(position, position);
      } else {
        target.value = '';
      }
    }, false);
  });
}
