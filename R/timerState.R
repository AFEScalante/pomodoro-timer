library(R6)

TimerState <- R6Class(
  "TimerState",
  public = list(
    initial_time = NULL,
    current_time = NULL,
    pomodoro_time = 5,
    short_break_time = 3,
    long_break_time = 10,
    is_running = FALSE,
    pomodoro_active = NULL,
    time_string = NULL,
    progress = NULL,

    initialize = function() {
      self$initial_time <- self$pomodoro_time
      self$current_time <- self$pomodoro_time
      self$time_string <- reactiveVal(self$format_time(self$pomodoro_time))
      self$progress <- reactiveVal(0)
      self$pomodoro_active <- reactiveVal(TRUE)
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

    set_mode = function(mode) {
      time <- switch(
        mode,
        "pomodoro" = self$pomodoro_time,
        "short_break" = self$short_break_time,
        "long_break" = self$long_break_time,
        stop("Invalid mode")
      )

      self$pomodoro_active(mode == "pomodoro")
      self$set_time(time)
      self$reset()
    },

    set_time = function(time) {
      self$initial_time <- time
      self$current_time <- time
    },

    calculate_progress = function() {
      1 - (self$current_time / self$initial_time)
    }
  )
)
