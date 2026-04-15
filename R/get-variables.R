#' Get a list of the registers' abbreviations.
#'
#' @return A character string.
#' @noRd
get_register_abbrev <- function() {
  names(registers())
}

#' Get a list of required variables from a specific register.
#'
#' @param register The abbreviation of the register name.
#'
#' @return A character vector of variable names.
#' @noRd
get_required_variables <- function(register) {
  if (!checkmate::test_scalar(register)) {
    cli::cli_abort("You are giving too many registers, please give only one.")
  }
  checkmate::assert_choice(register, get_register_abbrev())
  register <- rlang::arg_match(register, get_register_abbrev())
  registers()[[register]]$variables |>
    dplyr::pull(.data$name)
}
