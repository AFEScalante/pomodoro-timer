task_ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "task-container",
      span("I want to focus on "),
      textInput(ns("task"), label = NULL, placeholder = "type your task here") |> 
        tagAppendAttributes(class = "task-desc")
    ),
    div(
      class = "iter-container",
      "Iteration: ", span(class = "iter-display", "0")
    )
  )
}

task_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  })
}