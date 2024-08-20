header_ui <- function(id) {
  ns <- NS(id)

  tags$header(
    class = "header",
    tags$a(class = "pomodoro-timer", "Pomodoro Timer"),
    tags$img(class = "editbutton-icon", src = "images/editbutton.svg")
  )
}

header_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}