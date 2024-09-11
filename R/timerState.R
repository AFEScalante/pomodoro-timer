library(R6)

TimerState <- R6Class(
  "TimerState",
  public = list(
    initial_time = NULL,
    current_time = NULL,
    pomodoro_time = 3,
    short_break_time = 3,
    long_break_time = 3,
    is_running = FALSE,
    pomodoro_iter = NULL,
    trigger_mode = NULL,
    time_string = NULL,
    progress = NULL,
    current_mode = "pomodoro",

    initialize = function() {
      self$initial_time <- self$pomodoro_time
      self$current_time <- self$pomodoro_time
      self$time_string <- reactiveVal(self$format_time(self$pomodoro_time))
      self$progress <- reactiveVal(0)
      self$pomodoro_iter <- reactiveVal(0)
      self$trigger_mode <- reactiveVal("")
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
      valid_modes <- c("pomodoro", "short_break", "long_break")
      if (!mode %in% valid_modes) {
        stop("Invalid mode")
      }
      
      mode_settings <- list(
        pomodoro = list(time = self$pomodoro_time, color = "#ff5052"),
        short_break = list(time = self$short_break_time, color = "#90ee90"),
        long_break = list(time = self$long_break_time, color = "#70cdde")
      )
      
      time <- mode_settings[[mode]]$time
      color_mode <- mode_settings[[mode]]$color
      
      runjs(glue(
        "const timerDiv = document.querySelector('.timer-container');
        timerDiv.style.backgroundColor = '{color_mode}';
        $('.timer-btn').removeClass('pressed');"
      ))

      self$current_mode <- mode
      self$set_time(time)
      self$reset()
    },

    handle_pomodoro_cycle = function() {
      if (self$current_mode == "pomodoro") {
        self$increment_pomodoro()
    
        break_type <- self$determine_break_type()
        self$trigger_mode(break_type)
      } else if (grepl("break", self$current_mode)) {
        self$trigger_mode("pomodoro")
      }
    
      self$is_running <- FALSE
    },

    increment_pomodoro = function() {
      self$pomodoro_iter(self$pomodoro_iter() + 1)
      enable_claim_button()
    },
    
    determine_break_type = function() {
      ifelse(self$pomodoro_iter() %% 4 == 0, "long_break", "short_break")
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
