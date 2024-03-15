#' Verify that the dataset has the required variables for the algorithm.
#'
#' Use this function within an `if` condition inside a function to provide an
#' informative error message within the function used. This is done to make the
#' error message more informative to the location that the error actually
#' occurs, rather than within this function.
#'
#' @param data The dataset to check.
#' @inheritParams get_required_variables
#'
#' @return Either TRUE if the verification passes, or a character string if
#'   there is an error.
#' @keywords internal
#'
#' @examples
#' library(tibble)
#' library(dplyr)
#' # TODO: Replace with simulated data.
#' example_bef_data <- tibble(pnr = 1, koen = 1, foed_dato = 1)
#' verify_required_variables(example_bef_data, "bef")
verify_required_variables <- function(data, register) {
  checkmate::assert_choice(register, get_register_abbrev())

  expected_variables <- get_required_variables(register)

  actual_variables <- names(data)

  # TODO: Consider using/looking into rlang::try_fetch() to provide contextual error messages.
  checkmate::check_names(
    x = actual_variables,
    must.include = expected_variables
  )
}