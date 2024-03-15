#' Verify that the dataset has the required variables for the algorithm.
#'
#' @param data The dataset to check.
#' @param register The abbreviation of the register name. See list of
#'   abbreviations in [get_register_abbrev()].
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
  expected_variables <- required_variables |>
    dplyr::filter(.data$register_abbrev == register) |>
    dplyr::pull(.data$variable_name)
  actual_variables <- colnames(data)
  checkmate::check_names(
    x = actual_variables,
    must.include = expected_variables
  )
}
