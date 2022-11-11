box::use(
  shiny[...],
  bslib[...],
)

box::use(
  app/view/header,
  app/view/timer,
  app/view/footer,
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    theme = bs_theme(bootswatch = "simplex"),
    div(
      class = "main-container",
      header$ui(ns("app-header")),
      timer$ui(ns("timer")),
      footer$ui(ns("footer"))
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$message <- renderText("Hello!")
  })
}
