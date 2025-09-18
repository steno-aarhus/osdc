#' Determine if majority of diagnoses are type 1 diabetes
#'
#' Uses the hospital contacts from LPR2 and LPR3 to include all
#' dates of diabetes diagnoses to use for inclusion, as well as
#' additional information needed to classify diabetes type.
#' Diabetes diagnoses from both ICD-8 and ICD-10 are included.
#'
#' @param lpr2 The output from [prepare_lpr2()].
#' @param lpr3 The output from [prepare_lpr3()].
#'
#' @return The same type as the input data, default as a [tibble::tibble()],
#'  with less rows after filtering.
#'
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(c("lpr_diag", "lpr_adm", "diagnoser", "kontakter"))
#' include_diabetes_diagnoses(
#'   lpr2 = prepare_lpr2(register_data$lpr_adm, register_data$lpr_diag),
#'   lpr3 = prepare_lpr3(register_data$kontakter, register_data$diagnoser)
#' )
#' }
include_diabetes_diagnoses <- function(lpr2, lpr3) {
  # Combine and process the two inputs
  lpr2 |>
    dplyr::bind_rows(lpr3) |>
    dplyr::filter(.data$is_diabetes_code)
}
