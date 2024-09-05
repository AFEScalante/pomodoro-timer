library(shiny)

source("R/timer_manager.R")

source("R/header.R")
source("R/timer.R")
source("R/task.R")
source("R/prize.R")

timer_manager <- TimerManager$new()

ui <- fluidPage(
  shinyjs::useShinyjs(),
  tags$head(
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

server <- function(input, output, server) {
  header_server("header")
  timer_server("timer")
  prize_server("prize")
}

shiny::shinyApp(ui, server)