box::use(
  shiny[...],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    div(
      class = "buttons-timer",
      actionButton(ns("pom"), label = "Pomodoro", class = "btn-warning"),
      actionButton(ns("short_break"), label = "Short Break", class = "btn-success"),
      actionButton(ns("long_break"), label = "Long Break", class = "btn-success")
    ),
    div(
      class = "clock",
      textOutput(ns("clock"))
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$clock <- renderText(
      "Hello"
    )
  })
}
