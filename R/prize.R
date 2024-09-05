prize_ui <- function(id) {
  ns <- NS(id)

  div(
    class = "prize",
    tags$button("CLAIM YOUR REWARD!", class = "claim-btn", onclick = "console.log('Reward claimed')")
  )
}

prize_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  })
}