#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom fabricatr draw_binary draw_categorical
#' @importFrom lifecycle deprecated
#' @importFrom dplyr na_if
#' @importFrom dplyr if_else
#' @importFrom lubridate weeks
#' @importFrom lubridate years
#' @importFrom lubridate days
## usethis namespace: end
NULL

# Allows for using tidyverse functionality without triggering CRAN NOTES,
# since CRAN doesn't know that packages like dplyr use NSE.
# For more details, see https://rlang.r-lib.org/reference/dot-data.html#where-does-data-live
utils::globalVariables(".data")
