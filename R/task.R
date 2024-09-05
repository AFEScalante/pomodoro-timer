task_ui <- function(id) {
  ns <- NS(id)

  div(
    class = "task-container",
    span("I want to focus on "),
    textInput(ns("task"), label = NULL, placeholder = "type your task here") |> 
      tagAppendAttributes(class = "task-desc"),
    span("for "),
    numericInput(ns("iterations"), label = NULL, value = 1, min = 1, max = 99) |> 
      tagAppendAttributes(class = "task-iters"),
    span(" iterations")
  )
}

task_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}