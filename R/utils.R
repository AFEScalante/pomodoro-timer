neo_button <- function(input_id, content = "", class = NULL) {
  if (str_detect(class, "timer-btn")) btn_class <- "timer-btn"
  if (str_detect(class, "menu-btn")) btn_class <- "menu-btn"

  tags$button(
    id = input_id,
    content,
    class = class,
    onmousedown = "this.classList.add('pressing')",
    onmouseout = "this.classList.remove('pressing')",
    onmouseup = set_pressed_button(input_id, btn_class),
    # Add touch events for mobile
    ontouchstart = "this.classList.add('pressing')",
    ontouchend = set_pressed_button(input_id, btn_class)
  )
}

set_input_value <- function(id, value = 1) {
  glue("Shiny.setInputValue('{id}', '{value}', {{priority: 'event'}})")
}

set_pressed_button <- function(input_id, class = "timer-btn") {
  glue("
    $('.{class}').removeClass('pressed');
    $('#{input_id}').removeClass('pressing');
    $('#{input_id}').addClass('pressed');
    Shiny.setInputValue('{input_id}', '1', {{priority: 'event'}});
  ")
}

reset_claim_button <- function() {
  runjs(
    "const claimBtn = document.querySelector('.claim-btn');
     claimBtn.style.setProperty('--progress', '0');
     claimBtn.disabled = true;"
  )
}

update_claim_progress <- function(progress) {
  runjs(
    glue("
    const claimBtn = document.querySelector('.claim-btn');
    if (claimBtn) {{
      claimBtn.style.setProperty('--progress', '{progress}');
    }}
    ")
  )
}

enable_claim_button <- function() {
  runjs(
    "const claimBtn = document.querySelector('.claim-btn');
     claimBtn.disabled = false;
    "
  )
}

clock_input <- function(inputId, label = "Pomodoro", value = 10, color = "#e74c3c") {
  minutes <- value %/% 60
  seconds <- value %% 60

  tagList(
    div(
      class = "clock-container",
      tags$label(label, class = "clock-label"),
      div(
        class = "clock-inputs",
        style = sprintf("background-color: %s;", color),
        tags$input(
          type = "number",
          id = paste0(inputId, "_min"),
          class = "clock-input",
          value = sprintf("%02d", minutes),
          min = 0,
          max = 59
        ),
        span(":", class = "clock-separator"),
        tags$input(
          type = "number",
          id = paste0(inputId, "_sec"),
          class = "clock-input",
          value = sprintf("%02d", seconds),
          min = 0,
          max = 59
        )
      )
    ),
    tags$script(sprintf("initializeClock('%s', %d);", inputId, value))
  )
}

update_iter_display <- function(value) {
  runjs(
    glue(
      "
      const iterDiv = document.querySelector('.iter-display')
      iterDiv.textContent = '{value}'
      "
    )
  )
}

display_prize <- function(joke) {
  sanitized_joke <- stri_escape_unicode(joke)
  runjs(
    glue(
      "
      const jokeDiv = document.querySelector('.dad-joke-container');
      jokeDiv.classList.remove('hide');
      jokeDiv.textContent='{sanitized_joke}';
      "
    )
  )
}

hide_prize <- function() {
  runjs(
    glue(
      "
      const jokeDiv = document.querySelector('.dad-joke-container');
      jokeDiv.classList.add('hide');
      "
    )
  )
}

MODE_TITLE <- list(
  pomodoro = "Focus",
  short_break = "Short Break",
  long_break = "Long Break"
)
