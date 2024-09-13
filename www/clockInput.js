function initializeClock(inputId) {
  const minInput = document.getElementById(inputId + '_min');
  const secInput = document.getElementById(inputId + '_sec');

  function enforceMinMax(input) {
    let value = parseInt(input.value) || 0;
    const min = parseInt(input.min);
    const max = parseInt(input.max);

    if (value < min) {
      value = min;
    } else if (value > max) {
      value = max;
    }

    // Ensure two digits are displayed
    input.value = String(value).padStart(2, '0');
  }

  function updateShinyValue() {
    const minutes = parseInt(minInput.value) || 0;
    const seconds = parseInt(secInput.value) || 0;
    const totalSeconds = minutes * 60 + seconds;
    Shiny.setInputValue(inputId, totalSeconds);
  }

  minInput.addEventListener('input', function() {
    enforceMinMax(minInput);
    updateShinyValue();
  });

  secInput.addEventListener('input', function() {
    enforceMinMax(secInput);
    updateShinyValue();
  });

  // Initialize
  enforceMinMax(minInput);
  enforceMinMax(secInput);
  updateShinyValue();
}
