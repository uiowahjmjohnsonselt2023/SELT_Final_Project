document.addEventListener('DOMContentLoaded', function() {
  var countrySelect = document.getElementById('country');
  var stateSelect = document.getElementById('state-select');
  countrySelect.addEventListener('change', function() {
    stateSelect.style.display = countrySelect.value === 'United States of America' ? 'block' : 'none';
  });
});
