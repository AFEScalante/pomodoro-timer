library(shiny)

source("R/header.R")
source("R/task.R")

ui <- fluidPage(
  shinyjs::useShinyjs(),
  tags$head(
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Lexend Mega:wght@700&display=swap"),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Public Sans:wght@400;700;800&display=swap"),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Archivo:wght@700&display=swap"),
    tags$link(rel = "stylesheet", type = "text/css", href = "index.css")
  ),
  div(
    class = "app",
    header_ui("header"),
    task_ui("task")
  )
)

server <- function(input, output, server) {
  header_server("header")
}

shiny::shinyApp(ui, server)