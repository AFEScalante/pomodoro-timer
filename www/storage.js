var currentState = {};

// Function to check if localStorage is available
function storageAvailable(type) {
  let storage;
  try {
      storage = window[type];
      const x = '__storage_test__';
      storage.setItem(x, x);
      storage.removeItem(x);
      return true;
  }
  catch (e) {
      return e instanceof DOMException && (
          // Everything except Firefox
          e.code === 22 ||
          // Firefox
          e.code === 1014 ||
          // Test name field too, because code might not be present
          // Everything except Firefox
          e.name === 'QuotaExceededError' ||
          // Firefox
          e.name === 'NS_ERROR_DOM_QUOTA_REACHED') &&
          // Acknowledge QuotaExceededError only if there's something already stored
          storage && storage.length !== 0;
  }
}

// Automatically load from localStorage when the session starts
$(document).on('shiny:sessioninitialized', function() {
  if (storageAvailable('localStorage')) {
      const pomodoroSettings = JSON.parse(window.localStorage.getItem('pomodoroSettings'));
      currentState = pomodoroSettings;
      Shiny.setInputValue('stored_values', pomodoroSettings, {priority: 'event'});
  } else {
      console.error("localStorage is not available.");
  }
});

function saveToLocalStorage(state) {
  if (storageAvailable('localStorage')) {
    localStorage.setItem('pomodoroSettings', JSON.stringify(state));
  } else {
    console.error("localStorage is not available.");
  }
}

Shiny.addCustomMessageHandler('update_current_state', function(state) {
  currentState = state;
});

$(window).on('beforeunload', function() {
  saveToLocalStorage(currentState);
});
