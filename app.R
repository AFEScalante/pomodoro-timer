library(shiny)
library(httr)
library(glue)
library(shinyjs)
library(sass)
library(rsconnect)
library(stringi)
library(shinytitle)

# Load Shiny modules
source("R/header.R")
source("R/timer.R")
source("R/task.R")
source("R/prize.R")

source("R/utils.R")

ui <- fluidPage(
  title = "Pomodoro Timer",
  use_shiny_title(),
  useShinyjs(),
  tags$head(
    tags$script(src = "clockInput.js"),
    tags$script(src = "storage.js"),
    tags$link(rel = "apple-touch-icon", sizes = "180x180", href = "/favicon/apple-touch-icon.png"),
    tags$link(rel = "icon", type = "image/png", sizes = "32x32", href = "/favicon/favicon-32x32.png"),
    tags$link(rel = "icon", type = "image/png", sizes = "16x16", href = "/favicon/favicon-16x16.png"),
    tags$link(rel = "manifest", href = "/favicon/site.webmanifest"),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Lexend Mega:wght@700&display=swap"),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Lexend Mega:wght@700&display=swap"),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Public Sans:wght@400;700;800&display=swap"),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Archivo:wght@700&display=swap"),
    tags$link(rel = "stylesheet", type = "text/css", href = paste0("styles/index.css?v=", Sys.time()))
  ),
  div(
    class = "app",
    header_ui("header"),
    task_ui("task"),
    timer_ui("timer"),
    prize_ui("prize")
  )
)

server <- function(input, output, session) {
  timer <- TimerState$new()

  # Load the values from localStorage (triggered when session starts, see /storage.js)
  observeEvent(input$stored_values, {
    timer$load_values(input$stored_values)

    # Make stored values visible in default mode.
    timer$set_mode("pomodoro")
  }, ignoreNULL = TRUE)

  header_server("header", timer)
  task_server("task", timer)
  timer_server("timer", timer)
  prize_server("prize", timer)
}

shiny::shinyApp(ui, server)
