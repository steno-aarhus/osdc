#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom lifecycle deprecated
## usethis namespace: end
NULL

# Allows for using tidyverse functionality without triggering CRAN NOTES,
# since CRAN doesn't know that packages like dplyr use NSE.
# For more details, see https://rlang.r-lib.org/reference/dot-data.html#where-does-data-live-
utils::globalVariables(".data")
