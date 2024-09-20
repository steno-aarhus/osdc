#' Join together the LPR3 (`diagnoser` and `kontakter`) registers.
#'
#' @param diagnoser The diagnosis register.
#' @param kontakter The contacts register.
#'
#' @return The same class as the input, defaults to a [tibble::tibble()].
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' register_data$kontakter |>
#'   join_lpr3(register_data$diagnoser)
#' }
join_lpr3 <- function(kontakter, diagnoser) {
  verify_required_variables(kontakter, "kontakter")
  verify_required_variables(diagnoser, "diagnoser")

  dplyr::inner_join(
    column_names_to_lower(kontakter),
    column_names_to_lower(diagnoser),
    by = "dw_ek_kontakt"
  )
}
