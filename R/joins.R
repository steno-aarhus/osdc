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
join_lpr2 <- function(lpr_adm, lpr_diag) {
  verify_required_variables(lpr_adm, "lpr_adm")
  verify_required_variables(lpr_diag, "lpr_diag")
  dplyr::inner_join(column_names_to_lower(lpr_adm),
                    column_names_to_lower(lpr_diag),
                    by = "recnum")
}

