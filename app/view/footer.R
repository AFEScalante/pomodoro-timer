box::use(
  shiny[...],
  fontawesome[...]
)

#' @export
ui <- function(id) {
  div(
    class = "footer",
    "Made with ", fa("heart"), " by ", fa("r-project")
  )
}
