prize_ui <- function(id) {
  ns <- NS(id)

  div(
    class = "prize",
    tags$button(class = "claim-btn", onclick = set_input_value(ns("get_joke")), disabled = TRUE),
    div(class = "dad-joke-container hide", "")
  )
}

prize_server <- function(id, timer) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$get_joke, {
      reset_claim_button()
      display_prize(get_dad_joke())
    })

    observeEvent(timer$progress(), {
      if (timer$current_mode == "pomodoro") {
        update_progress_text(timer$progress())
      }
    })
  })
}

update_progress_text <- function(progress) {
  if (progress < 1) {
    claim_btn_text <- glue("Progress: {floor(progress * 100)}%")
  } else {
    claim_btn_text <- "CLAIM YOUR REWARD 🎁"
  }

  runjs(
    glue(
      "
      const rewardBtn = document.querySelector('.claim-btn');
      rewardBtn.textContent='{claim_btn_text}';
      "
    )
  )
}

get_dad_joke <- function() {
  res <- GET("https://icanhazdadjoke.com/", add_headers("Accept" = "text/plain"))

  if (status_code(res) == 200) {
    content(res, as = "text", encoding = "UTF-8")
  } else {
    "Error retrieving dad joke :/"
  }
}