#' Select the required variables from the register
#'
#' This function selects only the required variables, convert to lower case,
#' and then check that the data types are as expected.
#'
#' @param data The register to select columns from.
#' @param call The environment where the function is called, so that the error
#'   traceback gives a more meaningful location.
#' @inheritParams get_required_variables
#'
#' @return Outputs the register with only the required variables, and
#'   with column names in lower case.
#' @keywords internal
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

#' Check data types of the register variables
#'
#' @inheritParams get_register_abbrev
#'
#' @inherit select_required_variables return
#' @keywords internal
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
  data_for_types <- data |>
    utils::head() |>
    dplyr::collect()

  actual <- tibble::tibble(
    name = colnames(data_for_types),
    actual_data_type = purrr::map_chr(data_for_types, class)
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
