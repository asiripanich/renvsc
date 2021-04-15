#' [renv::init] with extra steps to maintain vscode-R features
#'
#' @description
#'
#' This function is a wrapper of [renv::init] which adds some extra steps
#' to maintain vscode-R's sessionWatcher and 'R: Launch RStudio Addin'
#' features after an [renv] environment gets activated.
#'
#' Step 1: Create `dependencies.R` at the path that is determined by
#' [here::here] and add `library(languageserver); library(jsonlite);
#' library(rlang)` to the file.
#'
#' Step2: Add `library(rstudioapi)` to `dependencies.R`, and then add
#' `options(vsc.rstudioapi = TRUE)` to `.Rprofile` created by [renv::init].
#'
#' @inheritParams renv::init
#' @importFrom renv init
#' @export
init <- function(project = NULL, ..., profile = NULL, settings = NULL,
                 bare = FALSE, force = FALSE, restart = interactive()) {
  add_radian_deps()
  add_rstudioapis()

  renv::init(
    project = NULL, ..., profile = NULL, settings = NULL,
    bare = FALSE, force = FALSE, restart = interactive()
  )
}

add_radian_deps <- function() {
  deps <- c("languageserver", "jsonlite", "rlang")
  for (dep in deps) {
    cat("library(", dep, ") #added by `renvsc`\n",
      file = here::here("dependencies.R"),
      append = TRUE,
      sep = ""
    )
  }
}

add_rstudioapis <- function() {
  cat("library(rstudioapi) #added by `renvsc`\n",
    file = here::here("dependencies.R"),
    append = TRUE
  )
  cat("options(vsc.rstudioapi = TRUE) #added by `renvsc`\n",
    file = here::here(".Rprofile"),
    append = TRUE
  )
}
