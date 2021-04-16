test_that("init works", {
  pkg_dir <- fs::path(tempdir(), "pkg")
  usethis::create_package(pkg_dir)
  init(project = pkg_dir)
  files <- list.files(pkg_dir, all.files = TRUE)
  expect_true(all(c("renv", "renv.lock", "dependencies.R", ".Rprofile") %in% files))
})
