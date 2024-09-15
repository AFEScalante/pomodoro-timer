header_ui <- function(id) {
  ns <- NS(id)

  tags$header(
    class = "header",
    a(class = "pomodoro-timer", "Pomodoro Timer"),
    tags$img(
      src = "images/editbutton.svg",
      class = "editbutton",
      onclick = set_input_value(ns("edit_time"))
    )
  )
}

header_server <- function(id, timer) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observeEvent(input$edit_time, {
      showModal(
        modalDialog(
          title = NULL,
          div(class = "modal-background",
            div(class = "modal-content",
              div(
                class = "clocks",
                clock_input(ns("pomodoro_duration"), "pomodoro",
                 value = timer$pomodoro_time, color = timer$mode_colors$pomodoro),
                clock_input(ns("short_break_duration"), "short break",
                 value = timer$short_break_time, color = timer$mode_colors$short_break),
                clock_input(ns("long_break_duration"), "long break",
                 value = timer$long_break_time, color = timer$mode_colors$long_break)
              ),
              tags$button(onclick = set_input_value(ns("close_modal")), "X", class = "close-btn")
            )
          ),
          easyClose = TRUE,
          fade = FALSE,
          footer = NULL
        )
      )
    })

    observeEvent(
      c(
        input$pomodoro_duration,
        input$short_break_duration,
        input$long_break_duration
      ), {
        timer$pomodoro_time <- input$pomodoro_duration
        timer$short_break_time <- input$short_break_duration
        timer$long_break_time <- input$long_break_duration

        # Send values to JS for localStorage
        session$sendCustomMessage("update_current_state", timer$get_values_to_store())

        # Changing durations will stop and reset current timer (including progress).
        timer$set_mode(timer$current_mode)
        reset_claim_button()
      }
    )

    observeEvent(input$close_modal, removeModal())
  })
}