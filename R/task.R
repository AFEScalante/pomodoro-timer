task_ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "task-container",
      span("I want to focus on "),
      textInput(ns("task"), label = NULL, placeholder = "type your task...") |> 
        tagAppendAttributes(class = "task-desc"),
      actionButton(ns("reset"), label = tags$img(src = "images/reset.svg", height = "14px"))
    ),
    div(
      class = "iter-container",
      "Iteration: ", span(class = "iter-display", "0")
    )
  )
}

task_server <- function(id, timer) {
  moduleServer(id, function(input, output, session) {

    observeEvent(input$reset, {
      updateTextInput(session, inputId = "task", value = "")
      # Select pomodoro mode
      set_pressed_button("timer-pomodoro", class = "menu-btn")
      timer$set_mode("pomodoro")

      # Clear iteration
      timer$pomodoro_iter(0)
      update_iter_display(0)

      hide_prize()
    })
  })
}