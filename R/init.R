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
#' @export
#' 
#' @examples
#' 
#' if (FALSE) init()
init <- function(project = NULL, ..., profile = NULL, settings = NULL,
                 bare = FALSE, force = FALSE, restart = interactive()) {

  if (is.null(project)) {
    project <- getwd()
  }

  add_radian_deps(project = project)
  add_rstudioapis(project = project)

  renv::init(
    project = project, ..., profile = profile, settings = settings,
    bare = bare, force = force, restart = restart
  )
}

add_radian_deps <- function(project) {
  deps <- c("languageserver", "jsonlite", "rlang")
  for (dep in deps) {
    cat("library(", dep, ") #added by `renvsc`\n",
      file = fs::path(project, "dependencies.R"),
      append = TRUE,
      sep = ""
    )
  }
}

add_rstudioapis <- function(project) {
  cat("library(rstudioapi) #added by `renvsc`\n",
    file = fs::path(project, "dependencies.R"),
    append = TRUE
  )
  cat("options(vsc.rstudioapi = TRUE) #added by `renvsc`\n",
    file = fs::path(project, ".Rprofile"),
    append = TRUE
  )
}
