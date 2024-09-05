timer_ui <- function(id) {
  ns <- NS(id)

  div(
    class = "timer-container",
    tags$button("START", class = "start-btn", onclick = "console.log('Iniciaste')"),
    div(
      class = "clock",
      textOutput(ns("mins")),
      tags$img(class = "timer-separator", src = "images/twopoints.svg"),
      textOutput(ns("secs"))
    ),
    div(
      class = "timer-buttons",
      tags$button("pomodoro", class = "timer-btn tomato-bg"),
      tags$button("break", class = "timer-btn green-bg"),
      tags$button("reset", class = "timer-btn blue-bg")
    )
  )
}

timer_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$mins <- renderText("10")
    output$secs <- renderText("10")
  })
}