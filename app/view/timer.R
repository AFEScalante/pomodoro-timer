box::use(
  shiny[...],
)

box::use(
  app/components/time_buttons,
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = "timer-box",
    time_buttons$ui(ns("time_buttons"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}
