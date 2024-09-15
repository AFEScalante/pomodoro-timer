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
    time_string = NULL,
    progress = NULL,
    current_mode = "pomodoro",
    next_timer = NULL,
    timer_ended = NULL,
    task_description  = NULL,
    mode_colors = list(
      pomodoro = "#ff5052",
      short_break = "#90ee90",
      long_break = "#70cdde"
    ),

    initialize = function() {
      self$initial_time <- self$pomodoro_time
      self$current_time <- self$pomodoro_time
      self$time_string <- reactiveVal(self$format_time(self$pomodoro_time))
      self$progress <- reactiveVal(0)
      self$pomodoro_iter <- reactiveVal(0)
      self$timer_ended <- reactiveVal(0)
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

      mode_times <- list(
        pomodoro = self$pomodoro_time,
        short_break = self$short_break_time,
        long_break = self$long_break_time
      )

      mode_time <- mode_times[[mode]]
      mode_color <- self$mode_colors[[mode]]

      runjs(glue(
        "const timerDiv = document.querySelector('.timer-container');
        timerDiv.style.backgroundColor = '{mode_color}';
        $('.timer-btn').removeClass('pressed');"
      ))

      self$current_mode <- mode
      self$set_time(mode_time)
      self$reset()
    },

    handle_pomodoro_cycle = function() {
      if (self$current_mode == "pomodoro") {
        self$increment_pomodoro()

        break_type <- self$determine_break_type()
        self$next_timer <- break_type
      } else if (grepl("break", self$current_mode)) {
        self$next_timer <- "pomodoro"
      }

      self$timer_ended(self$timer_ended() + 1)
      self$is_running <- FALSE
    },

    increment_pomodoro = function() {
      self$pomodoro_iter(self$pomodoro_iter() + 1)
      enable_claim_button()
      update_iter_display(self$pomodoro_iter())
    },

    determine_break_type = function() {
      ifelse(self$pomodoro_iter() %% 4 == 0, "long_break", "short_break")
    },

    set_time = function(time) {
      self$initial_time <- time
      self$current_time <- time
    },

    set_task_description = function(value) {
      if (is.null(value)) return()
      self$task_description <- value
    },

    calculate_progress = function() {
      1 - (self$current_time / self$initial_time)
    },

    update_task_description = function(session) {
      updateTextInput(session, inputId = "task-task", value = self$task_description)
    },

    load_values = function(stored_values) {
      self$pomodoro_time <- stored_values$pomodoro_time
      self$short_break_time <- stored_values$short_break_time
      self$long_break_time <- stored_values$long_break_time
      self$task_description <- stored_values$task_description
      self$pomodoro_iter(stored_values$pomodoro_iter)
    },

    get_values_to_store = function() {
      list(
        pomodoro_time = self$pomodoro_time,
        short_break_time = self$short_break_time,
        long_break_time = self$long_break_time,
        task_description = self$task_description,
        pomodoro_iter = self$pomodoro_iter()
      )
    }
  )
)
