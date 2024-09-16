source("R/timerState.R")

timer_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "timer-buttons",
      neo_button(input_id = ns("pomodoro"), content = "pomodoro", class = "menu-btn tomato-bg pressed"),
      neo_button(input_id = ns("short_break"), content = "short break", class = "menu-btn green-bg"),
      neo_button(input_id = ns("long_break"), content = "long break", class = "menu-btn blue-bg")
    ),
    div(class = "timer-container",
      div(class = "timer-display", textOutput(ns("time_display"))),
    ),
    div(class = "timer-controls",
      neo_button(input_id = ns("play"), content = icon("play"), class = "timer-btn play-btn"),
      neo_button(input_id = ns("pause"), content = icon("pause"), class = "timer-btn pause-btn"),
      neo_button(input_id = ns("stop"), content = icon("stop"), class = "timer-btn stop-btn")
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
      timer$set_mode("pomodoro")
    })

    observeEvent(input$short_break, {
      timer$set_mode("short_break")
    })

    observeEvent(input$long_break, {
      timer$set_mode("long_break")
    })

    # This is triggered whenever a cycle conclude
    observeEvent(timer$timer_ended(), {
      runjs(set_pressed_button(ns(timer$next_timer), class = "menu-btn"))
      timer$set_mode(timer$next_timer)
    }, ignoreInit = TRUE)

    # Control handlers
    observeEvent(input$play, {
      if (!timer$is_running) {
        timer$toggle_running()
      }
    })

    observeEvent(input$pause, {
      if (timer$is_running) {
        timer$toggle_running()
      }
    })

    observeEvent(input$stop, {
      reset_claim_button()
      timer$reset()
    })

    observe({
      progress <- timer$progress()
      if (timer$is_running) {
        change_window_title(
          session,
          glue("{MODE_TITLE[[timer$current_mode]]}: {timer$time_string()}"),
          inactive_only = FALSE
        )
        if (timer$current_mode == "pomodoro") update_claim_progress(progress)
        if (progress == 1) timer$handle_pomodoro_cycle()
      }
    })
  })
}
