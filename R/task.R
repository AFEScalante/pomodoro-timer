task_ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "task-container",
      span("I want to focus on "),
      div(
        class = "task-widgets",
        textInput(ns("task"), label = NULL, placeholder = "type your task...") |>
          tagAppendAttributes(class = "task-desc"),

        tags$img(
          src = "images/reset.svg",
          class = "resetbutton",
          onclick = set_input_value(ns("reset"))
        )
      )
    ),
    div(
      class = "iter-container",
      "Iteration: ", span(class = "iter-display", "0")
    )
  )
}

task_server <- function(id, timer) {
  moduleServer(id, function(input, output, session) {
    observeEvent(timer$values_loaded(), {
      # Make stored values visible in default mode.
      updateTextInput(session, inputId = "task", value = timer$task_description)
    })

    task_d <- reactive(input$task) |> debounce(millis = 1000)
    observeEvent(task_d(), {
      timer$set_task_description(task_d())
      session$sendCustomMessage("update_current_state", timer$get_values_to_store())
    }, ignoreInit = TRUE)

    observeEvent(timer$pomodoro_iter(), {
      update_iter_display(timer$pomodoro_iter())
      session$sendCustomMessage("update_current_state", timer$get_values_to_store())
    })

    observeEvent(input$reset, {
      updateTextInput(session, inputId = "task", value = "")
      # Select pomodoro mode
      runjs(set_pressed_button("timer-pomodoro", class = "menu-btn"))
      timer$set_mode("pomodoro")

      # Clear iteration
      timer$pomodoro_iter(0)

      hide_prize()
    })
  })
}