#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom lifecycle deprecated
#' @importFrom dplyr na_if
#' @importFrom lubridate weeks
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

#' Data frame of the logic for the OSDC algorithm
#'
#' This data frame contains the logic details of the algorithm for specific
#' inclusion and exclusion criteria.
#'
#' @format
#' Is a [tibble::tibble()] with two columns:
#'
#' \describe{
#'  \item{register}{Optional. The register used for this criteria.}
#'  \item{name}{The inclusion or exclusion criteria name.}
#'  \item{title}{The title to use when displaying the algorithmic logic in tables.}
#'  \item{logic}{The logic for the criteria.}
#'  \item{comments}{Some additional comments on the criteria.}
#' }
#' @seealso See the `vignette("algorithm")` and [algorithm] for the logic used
#'   to filter these patients.
"algorithm"
