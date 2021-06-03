#' [renv::init] with extra steps to maintain vscode-R features
#'
#' @description
#'
#' This function is a wrapper of [renv::init] which adds some extra steps
#' to maintain vscode-R's sessionWatcher and 'R: Launch RStudio Addin'
#' features after an [renv] environment gets activated.
#'
#' Step 1: Create `dependencies.R` at the path that is determined by
#' [getwd()], if not specifically provided, and add `library(languageserver); library(jsonlite);
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

  pkgs <- c("rstudioapi", "languageserver", "jsonlite", "rlang", "httpgd")
  r_options <-
    c(
      "options(vsc.rstudioapi = TRUE)",
      "if (interactive() && Sys.getenv('TERM_PROGRAM') == 'vscode') {
  if ('httpgd' %in% .packages(all.available = TRUE)) {
    options(vsc.plot = FALSE)
    options(device = function(...) {
      httpgd::hgd(silent = TRUE)
      .vsc.browser(httpgd::hgd_url(), viewer = 'Beside')
    })
  }
}"
    )

  add_deps(pkgs, project = project)
  add_rprofile(r_options, project = project)

  renv::init(
    project = project, ..., profile = profile, settings = settings,
    bare = bare, force = force, restart = restart
  )
}

add_deps <- function(pkgs, project) {
  for (pkg in pkgs) {
    cat("library(", pkg, ") #added by `renvsc`\n",
      file = fs::path(project, "dependencies.R"),
      append = TRUE,
      sep = ""
    )
  }
}

add_rprofile <- function(r_options, project) {
  for (r_option in r_options) {
    r_option <- paste(r_option, "#added by `renvsc`\n")
    cat(r_option,
      file = fs::path(project, ".Rprofile"),
      append = TRUE
    )
  }
}
