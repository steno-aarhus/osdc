#' Verify that the dataset has the required variables for the algorithm.
#'
#' Use this function inside another function within an `if` condition to provide an
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
#' # TODO: Replace with simulated data.
#' example_bef_data <- tibble::tibble(pnr = 1, koen = 1, foed_dato = 1)
#' osdc:::verify_required_variables(example_bef_data, "bef")
verify_required_variables <- function(data, register) {
  checkmate::assert_choice(register, get_register_abbrev())

  # TODO: Consider using/looking into rlang::try_fetch() to provide contextual error messages.
  expected_variables <- get_required_variables(register)

  actual_variables <- colnames(data)

  checkmate::check_names(
    x = actual_variables,
    must.include = expected_variables
  )
}
