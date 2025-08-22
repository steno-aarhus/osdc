#' Check data types of the register variables
#'
#' @inheritParams get_register_abbrev
#'
#' @inherit check_required_variables return
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
    dplyr::fitler(!stringr::str_detect(.data$expected_data_type, .data$actual_data_type)

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
  invisible(TRUE)
}
