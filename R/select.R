#' Select the required variables from the register
#'
#' This function selects only the required variables, convert to lower case,
#' and then check that the data types are as expected.
#'
#' @param data The register to select columns from.
#' @inheritParams get_required_variables
#'
#' @return Outputs the register with only the required variables, and
#'   with column names in lower case.
#' @keywords internal
select_required_variables <- function(
  data,
  register
) {
  checkmate::assert_choice(register, get_register_abbrev())
  expected_variables <- get_required_variables(register)

  data |>
    column_names_to_lower() |>
    dplyr::select(tidyselect::all_of(expected_variables))
}

#' Convert column names to lower case
#'
#' @param data A data frame type object.
#'
#' @return The same object type given.
#' @keywords internal
column_names_to_lower <- function(data) {
  # Needs to be a named vector for renaming.
  lower_column_names <- colnames(data) |>
    # This sets the names "attribute" of the vector.
    rlang::set_names(tolower(colnames(data)))
  data |>
    # Inject the lowercase names into rename.
    dplyr::rename(!!!lower_column_names)
}
