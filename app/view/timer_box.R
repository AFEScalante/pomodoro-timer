box::use(
  shiny[...],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = "buttons-timer",
    actionButton(ns("pom"), label = "Pomodoro", class = "btn-primary"),
    actionButton(ns("short_break"), label = "Short Break", class = "btn-success"),
    actionButton(ns("long_break"), label = "Long Break", class = "btn-success")
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}
