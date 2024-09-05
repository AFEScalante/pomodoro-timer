library(R6)

TimerManager <- R6Class("TimerManager",
  public = list(
    active = NULL,
    timer = NULL,
    minutes = 25,
    initialize = function() {
      self$active <- reactiveVal(FALSE)
      self$timer <- reactiveVal(self$minutes * 60)
    },
    start = function() {
      self$active(TRUE)
    },
    pause = function() {
      self$active(FALSE)
    },
    reset = function() {
      self$timer(self$minutes * 60)
      self$active(FALSE)
    },
    set_minutes = function(minutes) {
      self$minutes <- minutes
    }
  )
)
