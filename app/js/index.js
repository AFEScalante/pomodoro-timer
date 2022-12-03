const toggleMultipleClass = function(id1, id2, id3) {
  $(id1).toggleClass("selected");
  let id2_sel = $(id2).hasClass("selected");
  let id3_sel = $(id3).hasClass("selected");
  if (id2_sel)
    $(id2).removeClass("selected");
  if (id3_sel)
    $(id3).removeClass("selected");
};

export function togglePomodoroButton() {
  toggleMultipleClass(
    "#app-timer-timer_box-pom",
    "#app-timer-timer_box-short_break",
    "#app-timer-timer_box-long_break"
  );
}

export function toggleShortButton() {
  toggleMultipleClass(
    "#app-timer-timer_box-short_break",
    "#app-timer-timer_box-pom",
    "#app-timer-timer_box-long_break"
  );
}

// Toggle select class for Long Break button
export function toggleLongButton() {
  toggleMultipleClass(
    "#app-timer-timer_box-long_break",
    "#app-timer-timer_box-pom",
    "#app-timer-timer_box-short_break"
  );
}

export function changeStartButton() {
  $("#app-timer-timer_box-timer_control").toggleClass("btn-success");
  $("#app-timer-timer_box-timer_control").toggleClass("btn-danger");
}

export function changeBackground(button_type = "pom") {
  const time_box = $('.timer-box');
  if (button_type == "pom") {
    time_box.removeClass('green');
    time_box.removeClass('blue');
    time_box.addClass('red');
  } else if (button_type == "short") {
    time_box.addClass('green');
    time_box.removeClass('blue');
    time_box.removeClass('red');
  } else {
    time_box.removeClass('green');
    time_box.addClass('blue');
    time_box.removeClass('red');
  }
}
