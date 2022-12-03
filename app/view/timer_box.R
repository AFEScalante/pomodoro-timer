box::use(
  shiny[...],
  hms[as_hms],
  shinyjs[toggleClass, runjs],
  shinyWidgets[checkboxGroupButtons, sendSweetAlert],
  glue[glue],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = "timer-box red",
    div(
      class = "buttons-timer",
      actionButton(ns("pom"), label = "Pomodoro", class = "button-method selected"),
      actionButton(ns("short_break"), label = "Short Break", class = "button-method"),
      actionButton(ns("long_break"), label = "Long Break", class = "button-method")
    ),
    div(
      class = "time-value",
      textOutput(ns("time_val"))
    ),
    div(
      class = "execution-button",
      actionButton(ns("timer_control"), label = "Start", class = "btn-success btn-control")
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    timer <- reactiveVal(1500)
    active <- reactiveVal(FALSE)
    is_focus <- reactiveVal(TRUE)
    output$time_val <- renderText({
      timer() |>
        as_hms() |>
        as.character() |>
        substr(4, 8)
    })

    # Timer logic
    observe({
      invalidateLater(1000, session)
      isolate({
        if (active()) {
          timer(timer() - 1)
          if (timer() < 1) {
            active(FALSE)
            showModal(
              modalDialog(
                title = "Time completed!",
                ifelse(is_focus(), "Time to take a break", "Time to focus!")
              )
            )
          }
        }
      })
    })

    observeEvent(input$pom, {
      runjs("App.togglePomodoroButton();
             App.changeBackground('pom');")
      if(active()) {
        sendSweetAlert(title = "", text = "The timer still running, are you sure you want to switch?")
        updateActionButton(inputId = "timer_control", label = "Start")
        runjs("App.changeStartButton();")
      }
      is_focus(TRUE)
      active(FALSE)
      timer(1500)
    })

    observeEvent(input$short_break, {
      runjs("App.toggleShortButton();
            App.changeBackground('short');")
      if(active()) {
        sendSweetAlert(title = "", text = "The timer still running, are you sure you want to switch?")
        runjs("App.changeStartButton();")
        updateActionButton(inputId = "timer_control", label = "Start")
      }
      is_focus(FALSE)
      active(FALSE)
      timer(300)
    })

    observeEvent(input$long_break, {
      runjs("App.toggleLongButton();
            App.changeBackground('long');")
      if(active()) {
        sendSweetAlert(title = "", text = "The timer still running, are you sure you want to switch?")
        updateActionButton(inputId = "timer_control", label = "Start")
        runjs("App.changeStartButton();")
      }
      is_focus(FALSE)
      active(FALSE)
      timer(900)
    })

    observeEvent(input$timer_control, {
      ifelse(active(), active(FALSE), active(TRUE))
      updateActionButton(inputId = "timer_control", label = ifelse(active(), "Stop", "Start"))
      runjs("App.changeStartButton();")
    })
  })
}
