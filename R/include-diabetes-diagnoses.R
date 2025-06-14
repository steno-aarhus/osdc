#' Include ICD-8 and ICD-10 Codes for Diabetes Diagnosis and Type-Specific Classification
#'
#' Include diabetes diagnoses from LPR2 and LPR3.
#'
#' Uses the hospital contacts from LPR2 and LPR3 to include all dates of diabetes
#' diagnoses to use for inclusion, as well as additional information needed to classify diabetes
#' type. Diabetes diagnoses from both ICD-8 and ICD-10 are included.
#'
#' The output is used as inputs to `join_inclusions()`.
#' This output is passed to the `join_inclusions()` function, where the
#' `dates` variable is used for the final step of the inclusion process.
#' The variables of counts of diabetes type-specific primary diagnoses (the
#' four columns prefixed `n_`) are carried over for the subsequent
#' classification of diabetes type, initially as inputs to the
#' `get_t1d_primary_diagnosis()` and `get_majority_of_t1d_diagnoses()`
#' functions.
#'
#' @param lpr2 The output from `join_lpr2()`.
#' @param lpr3 The output from `join_lpr3()`.
#'
#' @return The same type as the input data, default as a [tibble::tibble()],
#'  with the following columns and up to two rows per individual:
#'
#'  -   `pnr`: The personal identification variable.
#'  -   `dates`: The dates of the first and second hospital diabetes diagnosis.
#'  -   `n_t1d_endocrinology`: The number of type 1 diabetes-specific primary
#'      diagnosis codes from endocrinology departments.
#'  -   `n_t2d_endocrinology`: The number of type 2 diabetes-specific primary
#'      diagnosis codes from endocrinology departments.
#'  -   `n_t1d_medical`: The number of type 1 diabetes-specific primary
#'      diagnosis codes from medical departments.
#'  -  `n_t2d_medical`: The number of type 2 diabetes-specific primary
#'      diagnosis codes from medical departments.
#'  -  `has_lpr_diabetes_diagnosis`: A logical variable that acts as a helper
#'      indicator for use in later functions.
#'
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' register_data <- simulate_registers(c("lpr_diag", "lpr_adm", "diagnoser", "kontakter"))
#' include_diabetes_diagnoses(
#'   lpr2 = prepare_lpr2(register_data$lpr_diag, register_data$lpr_adm),
#'   lpr3 = prepare_lpr3(register_data$diagnoser, register_data$kontakter)
#' )
include_diabetes_diagnoses <- function(lpr2, lpr3) {
  # Combine and process the two inputs
  lpr2 |>
    dplyr::full_join(lpr3, by = dplyr::join_by(.data$pnr, .data$date)) |>
    count_primary_diagnoses_by_department() |>
    dplyr::mutate(
      date = lubridate::ymd(date)) |>
    dplyr::group_by(.data$pnr) |>
    # Keep earliest two dates per individual.
    dplyr::filter(dplyr::row_number(.data$date) %in% 1:2) |>
    dplyr::ungroup() |>
    dplyr::select(
      pnr,
      dates = date,
      n_t1d_endocrinology,
      n_t2d_endocrinology,
      n_t1d_medical,
      n_t2d_medical
    ) |>
    # Create an indicator variable for later use.
    dplyr::mutate(has_lpr_diabetes_diagnosis = TRUE)

}
