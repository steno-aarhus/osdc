#' Include ICD-8 and ICD-10 codes of diabetes from hospital contacts for inclusion and type-specification.
#'
#' This function calls `join_lpr2()` and `join_lpr3()` and processes their output for inclusion, as well as additional information needed to classify diabetes type.
#'
#' @param lpr_diag The diagnosis table from LPR2
#' @param lpr_adm The admission table from LPR2
#' @param diagnoser The diagnosis table from LPR3
#' @param kontakter The contacts table from LPR3
#'
#' @return An object of the same input type, default as a [tibble::tibble()],
#'   with six columns and up to two rows per unique `pnr` value):
#'  -   `pnr`: identifier variable
#'  -   `dates`: dates of the first and second hospital diabetes diagnosis
#'  -   `n_t1d_endocrinology`: number of type 1 diabetes-specific primary diagnosis codes from endocrinological departments
#'  -   `n_t2d_endocrinology`: number of type 2 diabetes-specific primary diagnosis codes from endocrinological departments
#'  -   `n_t1d_medical`: number of type 1 diabetes-specific primary diagnosis codes from medical departments
#'  -   `n_t2d_medical`: number of type 2 diabetes-specific primary diagnosis codes from medical departments
#' This output is passed to the `join_inclusions()` function, where the `dates` variable is used for the final step of the inclusion process.
#' The variables of counts of diabetes type-specific primary diagnoses (the four columns prefixed `n_` above) are carried over for the subsequent classification of diabetes type, initially as inputs to the `get_t1d_primary_diagnosis()` and `get_majority_of_t1d_diagnoses()` functions..
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' include_diabetes_diagnoses(lpr_diag, lpr_adm, diagnoser, kontakter)
#' }
include_diabetes_diagnoses <- function(lpr2_diag, lpr2_adm, lpr3_diagnoser, lpr3_kontakter) {
  verify_required_variables(register_data$lpr_diag, "lpr2_diag")
  verify_required_variables(register_data$lpr_adm, "lpr2_adm")
  verify_required_variables(register_data$diagnoser, "lpr3_diagnoser")
  verify_required_variables(register_data$kontakter, "lpr3_kontakter")
  lpr2_criteria <- get_algorithm_logic("lpr2_diabetes") |>
    # To convert the string into an R expression.
    rlang::parse_expr()
  lpr3_criteria <- get_algorithm_logic("lpr3_diabetes") |>
    # To convert the string into an R expression.
    rlang::parse_expr()

  data |>
    column_names_to_lower() |>
    # Use !! to inject the expression into filter.
    dplyr::filter(!!criteria) |>
    # Keep only the columns we need.
    dplyr::mutate()
}
