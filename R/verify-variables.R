#' Verify that the dataset has the required variables for the algorithm.
#'
#' Use this function inside another function within an `if` condition to provide an
#' informative error message within the function used. This is done to make the
#' error message more informative to the location that the error actually
#' occurs, rather than within this function.
#'
#' @param data The dataset to check.
#' @param call The environment where the function is called, so that the error
#'   traceback gives a more meaningful location.
#' @inheritParams get_required_variables
#'
#' @return Either TRUE if the verification passes, or an error.
#' @keywords internal
#'
#' @examples
#' # TODO: Replace with simulated data.
#' verify_required_variables(register_data$bef, "bef")
#' verify_required_variables(register_data$bef, "lpr_adm")
verify_required_variables <- function(data, register, call = rlang::caller_env()) {
  checkmate::assert_choice(register, get_register_abbrev())
  expected_variables <- sort(get_required_variables(register))
  actual_variables <- sort(colnames(data))

  if (!checkmate::test_names(
    x = actual_variables,
    must.include = expected_variables
  )) {
    cli::cli_abort(
      c(
        "This function needs specific variables from the {.val {register}} register.",
        "i" = "Variables required: {.val {expected_variables}}",
        "x" = "Variables found: {.val {actual_variables}}"
      ),
      call = call
    )
  }
  return(invisible(TRUE))
}
