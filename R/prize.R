prize_ui <- function(id) {
  ns <- NS(id)

  div(
    class = "prize",
    tags$button("CLAIM YOUR REWARD!", class = "claim-btn", onclick = set_input_value(ns("get_joke")), disabled = TRUE),
    div(class = "dad-joke-container hide", "")
  )
}

prize_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$get_joke, {
      reset_claim_button()
      display_prize(get_dad_joke())
    })
  })
}

get_dad_joke <- function() {
  res <- GET("https://icanhazdadjoke.com/", add_headers("Accept" = "text/plain"))
  
  if (status_code(res) == 200) {
    content(res, as = "text", encoding = "UTF-8")
  } else {
    "Error retrieving dad joke :/"
  }
}