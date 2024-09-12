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
  runjs(
    glue(
      "
      const jokeDiv = document.querySelector('.dad-joke-container');
      jokeDiv.classList.remove('hide');
      jokeDiv.textContent='{joke}';
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