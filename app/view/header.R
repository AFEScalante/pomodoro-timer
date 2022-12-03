box::use(
  shiny[...]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    h3("Pomodoro Timer"),
    hr(style = "width: 30em;")
  )
}
