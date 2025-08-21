#' Check data types of the register variables
#'
#' @inheritParams get_register_abbrev
#'
#' @inherit check_required_variables return
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' check_data_types(simulate_register("kontakter"), "kontakter")
#' }
check_data_types <- function(data, register, call = rlang::caller_env()) {
   checkmate::assert_choice(register, get_register_abbrev())
   
  # Get register variables and their expected data type(s).
  register_variables <- registers()[[register]]$variables

  for (colname in intersect(register_variables$name, names(data))) {
    # Get expected data type for current column.
    # If the column has multiple expected data types, this will be a list.
    expected_data_type <- register_variables$data_type[
      register_variables$name == colname
    ]

    if (!(class(data[[colname]]) %in% unlist(expected_data_type))) {
      cli::cli_abort(
        c(
          "The column {.val {colname}} in the data {.val {register}} does not have the expected data type.",
          "i" = "Expected: {.val {register_variables$data_type[register_variables$name == colname]}}",
          "x" = "Found: {.val {class(data[[colname]])}}"
        ),
        call = call
      )
    }
  }
  return(invisible(TRUE))
}
