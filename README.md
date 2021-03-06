
<!-- README.md is generated from README.Rmd. Please edit that file -->

# renvsc

<!-- badges: start -->

[![R-CMD-check](https://github.com/asiripanich/renvsc/workflows/R-CMD-check/badge.svg)](https://github.com/asiripanich/renvsc/actions)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of renvsc is to enable using the renv package in VSCode without
breaking the nice features of the vscode-R extension.

`renvsc::init()` adds some extra steps to `renv::init()` to maintain
vscode-R’s sessionWatcher and ‘R: Launch RStudio Addin’ features after
an \[renv\] environment gets activated.

-   Step 1: Create `dependencies.R` at the path that is determined by
    `getwd()`, if not specifically provided, and add
    `library(languageserver); library(jsonlite); library(rlang)` to the
    file.
-   Step2: Add `library(rstudioapi)` to `dependencies.R`, and then add
    `options(vsc.rstudioapi = TRUE)` to `.Rprofile` created by
    `renv::init()`.

## Installation

``` r
remotes::install_github("asiripanich/renvsc")
```
