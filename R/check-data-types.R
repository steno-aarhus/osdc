#' Check data types
#'
#' @param data A data frame to check.
#' @param register The name of the register to check against.
#' @param call The environment where the function is called, so that the error
#'   traceback gives a more meaningful location.
#'
#' @return Either TRUE if the verification passes, or an error.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' check_data_types(simulate_register("kontakter"), "kontakter")
#' }
check_data_types <- function(data, register, call = rlang::caller_env()) {
  # Get register variables and their expected data type(s).
  register_variables <- registers()[[register]]$variables

  for (colname in intersect(register_variables$name, names(data))) {
    # Get expected data type for current column.
    # If the column has multiple expected data types, this will be a list.
    expected_data_type <- register_variables$data_type[register_variables$name == colname]

    if (!(class(data[[colname]]) %in% unlist(expected_data_type))) {
      cli::cli_abort(
        c(
          "The column {.val {colname}} in the data {.val {register}} does not have the expected data type.",
          "i" = "Expected: {.val {register_variables$data_type[register_variables$name == colname]}}",
          "x" = "Found: {.val {class(data[[colname]])}}"
        ), call = call
      )
    }
  }
  return(invisible(TRUE))
}
