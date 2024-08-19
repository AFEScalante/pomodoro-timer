library(shiny)

source("R/header.R")
source("R/task.R")

ui <- fluidPage(
  shinyjs::useShinyjs(),
  includeCSS("www/style.css"),
  div(
    class = "app",
    header_ui("header"),
    task_ui("task")
  )
)

server <- function(input, output, server) {
  header_server("header")
}

shinyApp(ui, server)
