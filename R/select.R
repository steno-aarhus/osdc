#' Check that the dataset has the required variables for the algorithm.
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
#' \dontrun{
#' # TODO: Replace with simulated data.
#' select_required_variables(simulate_registers("bef")[[1]], "bef")
#' select_required_variables(simulate_registers("lpr_adm")[[1]], "lpr_adm")
#' }
select_required_variables <- function(
  data,
  register,
  call = rlang::caller_env()
) {
  checkmate::assert_choice(register, get_register_abbrev())
  expected_variables <- get_required_variables(register)

  data <- data |>
    column_names_to_lower() |>
    dplyr::select(tidyselect::all_of(expected_variables))

  check_data_types(data, register, call = call)
}

#' Convert column names to lower case.
#'
#' @param data An data frame type object.
#'
#' @return The same object type given.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' tibble::tibble(A = 1:3, B = 4:6) |>
#'   osdc:::column_names_to_lower()
#' }
column_names_to_lower <- function(data) {
  data |>
    dplyr::rename_with(tolower)
}

#' Check data types of the register variables
#'
#' @inheritParams get_register_abbrev
#'
#' @inherit select_required_variables return
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' check_data_types(simulate_registers("kontakter")[[1]], "kontakter")
#' }
check_data_types <- function(data, register, call = rlang::caller_env()) {
  checkmate::assert_choice(register, get_register_abbrev())

  # Get register variables and their expected data type(s).
  expected <- registers()[[register]]$variables |>
    # If data_type is a list, collapse it into a single string.
    dplyr::mutate(
      expected_data_type = purrr::map_chr(.data$data_type, \(x) {
        paste(x, collapse = " or ")
      })
    ) |>
    dplyr::select("name", "expected_data_type")

  # Get actual variables and their data types.
  actual <- tibble::tibble(
    name = colnames(data),
    actual_data_type = purrr::map_chr(data, class)
  )

  # Get mismatched data types.
  mismatched <- actual |>
    #  Remove columns in data we don't have expectations to.
    dplyr::inner_join(expected, by = "name") |>
    dplyr::filter(
      !stringr::str_detect(.data$expected_data_type, .data$actual_data_type)
    )

  if (nrow(mismatched) > 0) {
    expected_str <- paste0(
      mismatched$name,
      " = ",
      mismatched$expected_data_type
    )
    actual_str <- paste0(
      mismatched$name,
      " = ",
      mismatched$actual_data_type
    )
    cli::cli_abort(
      c(
        "The register {.val {register}} has unexpected data types that need to be changed.",
        "i" = "Expected: {.val {expected_str}}.",
        "x" = "Found: {.val {actual_str}}."
      ),
      call = call
    )
  }
  data
}
