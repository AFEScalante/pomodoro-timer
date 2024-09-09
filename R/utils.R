set_input_value <- function(id, value = 1) {
  glue("Shiny.setInputValue('{id}', '{value}', {{priority: 'event'}})")
}

set_pressed_button <- function(input_id) {
  runjs(
    glue("
      $('.timer-btn').removeClass('pressed');
      $('#{input_id}').addClass('pressed');
    ")
  )
}
