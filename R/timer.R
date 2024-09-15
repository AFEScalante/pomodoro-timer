source("R/timerState.R")

timer_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "timer-buttons",
      tags$button(
        id = ns("pomodoro"),
        onclick = set_input_value(ns("pomodoro")),
        "pomodoro",
        class = "menu-btn tomato-bg pressed"
      ),
      tags$button(
        id = ns("short_break"),
        onclick = set_input_value(ns("short_break")),
        "short break",
        class = "menu-btn green-bg"
      ),
      tags$button(
        id = ns("long_break"),
        onclick = set_input_value(ns("long_break")),
        "long break",
        class = "menu-btn blue-bg"
      )
    ),
    div(class = "timer-container",
      div(class = "timer-display", textOutput(ns("time_display"))),
    ),
    div(class = "timer-controls",
    tags$button(id = ns("play"), icon("play"), class = "timer-btn play-btn", onclick = set_input_value(ns("play"))),
    tags$button(id = ns("pause"), icon("pause"), class = "timer-btn pause-btn", onclick = set_input_value(ns("pause"))),
    tags$button(id = ns("stop"), icon("stop"), class = "timer-btn stop-btn", onclick = set_input_value(ns("stop")))
    )
  )
}

timer_server <- function(id, timer) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Render time display
    output$time_display <- renderText(timer$time_string())

    # Timer tick
    observe({
      invalidateLater(1000, session)
      timer$tick()
    })

    # Pomodoro controls
    observeEvent(input$pomodoro, {
      set_pressed_button(ns("pomodoro"), class = "menu-btn")
      timer$set_mode("pomodoro")
    })

    observeEvent(input$short_break, {
      set_pressed_button(ns("short_break"), class = "menu-btn")
      timer$set_mode("short_break")
    })

    observeEvent(input$long_break, {
      set_pressed_button(ns("long_break"), class = "menu-btn")
      timer$set_mode("long_break")
    })

    # This is triggered whenever a cycle conclude
    observeEvent(timer$timer_ended(), {
      set_pressed_button(ns(timer$next_timer), class = "menu-btn")
      timer$set_mode(timer$next_timer)
    }, ignoreInit = TRUE)

    # Control handlers
    observeEvent(input$play, {
      if (!timer$is_running) {
        timer$toggle_running()
        set_pressed_button(ns("play"))
      }
    })

    observeEvent(input$pause, {
      if (timer$is_running) {
        timer$toggle_running()
        set_pressed_button(ns("pause"))
      }
    })

    observeEvent(input$stop, {
      set_pressed_button(ns("stop"))
      reset_claim_button()
      timer$reset()
    })

    observe({
      progress <- timer$progress()
      if (timer$is_running) {
        if (timer$current_mode == "pomodoro") update_claim_progress(progress)
        if (progress == 1) {
          timer$handle_pomodoro_cycle()
          session$sendCustomMessage("update_current_state", timer$get_values_to_store())
        }
      }
    })
  })
}
