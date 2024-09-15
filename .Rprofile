source("renv/activate.R")

run_app <- function() {
  source("app.R")
  shiny::runApp(appDir = '.')
}

build_sass <- function() {
  sass::sass(
    input = sass::sass_file("www/styles/style.scss"),
    output = "www/styles/index.css",
    options = sass::sass_options(output_style = "compressed")
  )
}
