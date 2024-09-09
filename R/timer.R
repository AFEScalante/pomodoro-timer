source("R/timerState.R")

timer_ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(class = "timer-container",
      div(
        class = "timer-buttons",
        tags$button("pomodoro", class = "timer-btn tomato-bg"),
        tags$button("short break", class = "timer-btn green-bg"),
        tags$button("long break", class = "timer-btn blue-bg")
      ),
      div(class = "timer-display", textOutput(ns("time_display"))),
      div(class = "timer-controls",
      actionButton(ns("play"), icon("play"), class = "timer-btn play-btn"),
      actionButton(ns("pause"), icon("pause"), class = "timer-btn pause-btn"),
      actionButton(ns("stop"), icon("stop"), class = "timer-btn stop-btn")
      )
    )
  )
}

timer_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    timer <- TimerState$new(20)

    # Render time display
    output$time_display <- renderText(timer$time_string())

    # Timer tick
    observe({
      invalidateLater(1000, session)
      timer$tick()
    })

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
      timer$reset()
      set_pressed_button(ns("stop"))
    })

    # Update claim button
    observe({
      progress <- timer$progress()
      runjs(sprintf("
        const claimBtn = document.querySelector('.claim-btn');
        if (claimBtn) {
          claimBtn.style.setProperty('--progress', '%f');
          claimBtn.disabled = %s;
        }
      ", progress, ifelse(progress < 1, "true", "false")))
    })
  })
}
