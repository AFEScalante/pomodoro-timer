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
     claimBtn.disabled = true;"
  )
  timer$progress(0)
}