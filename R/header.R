header_ui <- function(id) {
  ns <- NS(id)

  div(
    class = "header",
    span("Pomodoro Timer"),
    actionButton(inputId = ns("edit"), icon = icon("pencil"), label = "")
  )
}

header_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$edit, {
      print("Editing...")
    })
  })
}