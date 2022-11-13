box::use(
  shiny[...],
)

box::use(
  app/view/timer_box,
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = "timer-box",
    timer_box$ui(ns("timer_box"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    timer_box$server("timer_box")
  })
}
