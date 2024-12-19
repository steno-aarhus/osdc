#' Get a list of the registers' abbreviations.
#'
#' @return A character string.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' get_register_abbrev()
#' }
get_register_abbrev <- function() {
  unique(variable_description$register_abbrev)
}

#' Get a list of required variables from a specific register.
#'
#' @param register The abbreviation of the register name. See list of
#'   abbreviations in [get_register_abbrev()].
#'
#' @return A character vector of variable names.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' get_required_variables("bef")
#' }
get_required_variables <- function(register) {
  if (!checkmate::test_scalar(register)) {
    cli::cli_abort("You are giving too many registers, please give only one.")
  }
  checkmate::assert_choice(register, get_register_abbrev())
  register <- rlang::arg_match(register, get_register_abbrev())
  variable_description |>
    dplyr::filter(.data$register_abbrev == register) |>
    dplyr::pull(.data$variable_name)
}
