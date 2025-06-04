#' Join together the LPR2 (`lpr_diag` and `lpr_adm`) registers.
#'
#' @param lpr_diag The diagnosis register.
#' @param lpr_adm The admission register.
#'
#' @return The same class as the input, defaults to a [tibble::tibble()].
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(c("lpr_adm", "lpr_diag"))
#' join_lpr2(register_data$lpr_adm, register_data$lpr_diag)
#' }
join_lpr2 <- function(lpr_adm, lpr_diag) {
  # These verify that the argument is also used in the right
  # order.
  verify_required_variables(lpr_adm, "lpr_adm")
  verify_required_variables(lpr_diag, "lpr_diag")

  dplyr::inner_join(
    column_names_to_lower(lpr_adm),
    column_names_to_lower(lpr_diag),
    by = "recnum"
  )
}

#' Join together the LPR3 (`diagnoser` and `kontakter`) registers.
#'
#' To prepare the LPR3 data for the inclusion process, this function also
#' renames the `cpr` variable to `pnr` to match the other registers.
#'
#' @param diagnoser The diagnosis register.
#' @param kontakter The contacts register.
#'
#' @return The same class as the input, defaults to a [tibble::tibble()].
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' kontakter <- simulate_registers("kontakter", 100)[[1]]
#' diagnoser <- simulate_registers("diagnoser", 100)[[1]]
#' join_lpr3(
#'   kontakter = kontakter,
#'   diagnoser = diagnoser
#' )
#' }
join_lpr3 <- function(kontakter, diagnoser) {
  # These verify that the argument is also used in the right
  # order.
  verify_required_variables(kontakter, "kontakter")
  verify_required_variables(diagnoser, "diagnoser")

  kontakter <- kontakter |>
    dplyr::rename("pnr" = "cpr")

  dplyr::inner_join(
    column_names_to_lower(kontakter),
    column_names_to_lower(diagnoser),
    by = "dw_ek_kontakt"
  )
}
