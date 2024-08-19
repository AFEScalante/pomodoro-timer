task_ui <- function(id) {
  ns <- NS(id)

  div(
    class = "task-container",
    span("I want to focus on "),
    selectizeInput(ns("task"), choices = "", label = NULL, options = list(create = TRUE, placeholder = "type your task here")),
    span("for "),
    numericInput(ns("iterations"), label = NULL, value = 1, min = 1, max = 99),
    span(" iterations")
  )
}

task_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}