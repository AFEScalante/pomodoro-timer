library(R6)

TimerState <- R6Class(
  "TimerState",
  public = list(
    initial_time = NULL,
    current_time = NULL,
    is_running = FALSE,
    time_string = NULL,
    progress = NULL,

    initialize = function(initial_time = 25 * 60) {
      self$initial_time <- initial_time
      self$current_time <- initial_time
      self$time_string <- reactiveVal(self$format_time(initial_time))
      self$progress <- reactiveVal(0)
    },

    reset = function() {
      self$current_time <- self$initial_time
      self$is_running <- FALSE
      self$update_reactive_fields()
    },

    tick = function() {
      if (self$is_running && self$current_time > 0) {
        self$current_time <- self$current_time - 1
        self$update_reactive_fields()
      }
    },

    toggle_running = function() {
      self$is_running <- !self$is_running
    },

    update_reactive_fields = function() {
      self$time_string(self$format_time(self$current_time))
      self$progress(self$calculate_progress())
    },

    format_time = function(time) {
      mins <- floor(time / 60)
      secs <- time %% 60
      sprintf("%02d:%02d", mins, secs)
    },

    calculate_progress = function() {
      1 - (self$current_time / self$initial_time)
    }
  )
)
