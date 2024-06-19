#' Join together the LPR2 (`lpr_diag` and `lpr_adm`) registers.
#'
#' @param lpr_diag The diagnosis register.
#' @param lpr_adm The admission register.
#'
#' @return The same class as the input, defaults to a [tibble::tibble()].
#' @keywords internal
#'
#' @examples
#' register_data$lpr_diag |>
#'   join_lpr2(register_data$lpr_adm)
join_lpr2 <- function(lpr_diag, lpr_adm) {
  verify_required_variables(lpr_diag, "lpr_diag")
  verify_required_variables(lpr_adm, "lpr_adm")
  dplyr::full_join(
    column_names_to_lower(lpr_adm),
    column_names_to_lower(lpr_diag),
    by = "recnum"
  )
}

#' Join together the LPR3 (`diagnoser` and `kontakter`) registers.
#'
#' @param diagnoser The diagnosis register.
#' @param kontakter The contacts register.
#'
#' @return The same class as the input, defaults to a [tibble::tibble()].
#' @keywords internal
#'
#' @examples
#' register_data$diagnoser |>
#'   join_lpr3(register_data$kontakter)
join_lpr3 <- function(diagnoser, kontakter) {
  verify_required_variables(diagnoser, "diagnoser")
  verify_required_variables(kontakter, "kontakter")
  dplyr::full_join(
    column_names_to_lower(kontakter),
    column_names_to_lower(diagnoser),
    by = "dw_ek_kontakt"
  )
}
