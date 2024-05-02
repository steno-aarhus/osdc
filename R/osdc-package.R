#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom lifecycle deprecated
## usethis namespace: end
NULL

# Allows for using tidyverse functionality without triggering CRAN NOTES,
# since CRAN doesn't know that packages like dplyr use NSE.
# For more details, see https://rlang.r-lib.org/reference/dot-data.html#where-does-data-live
utils::globalVariables(".data")

#' Simulation of register data needed for OSDC algorithm
#'
#' Details of how this data was simulated is found in the `data-raw/` folder on
#' the GitHub repository: <https://github.com/steno-aarhus/osdc>
#'
#' @format
#' Is a list with several registers.
"register_data"
