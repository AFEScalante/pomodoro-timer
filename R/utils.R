set_input_value <- function(id, value = 1) {
  glue("Shiny.setInputValue('{id}', '{value}', {{priority: 'event'}})")
}

set_pressed_button <- function(input_id, class = "timer-btn") {
  runjs(
    glue("
      $('.{class}').removeClass('pressed');
      $('#{input_id}').addClass('pressed');
    ")
  )
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
