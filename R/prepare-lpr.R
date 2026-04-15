#' Prepare and join the two LPR2 registers to extract diabetes and pregnancy diagnoses.
#'
#' @param lpr_diag The LPR2 register containing diabetes diagnoses.
#' @param lpr_adm The LPR2 register containing hospital admissions.
#'
#' @return The same type as the input data, as a [duckplyr::duckdb_tibble()],
#'  with the following columns:
#'
#'  -   `pnr`: The personal identification variable.
#'  -   `date`: The date of all the recorded diagnosis (renamed from
#'      `d_inddto` or `dato_start`).
#'  -   `is_primary_diagnosis`: Whether the diagnosis was a primary diagnosis.
#'  -   `is_diabetes_code`: Whether the diagnosis was any type of diabetes.
#'  -   `is_t1d_code`: Whether the diagnosis was T1D-specific.
#'  -   `is_t2d_code`: Whether the diagnosis was T2D-specific.
#'  -   `is_pregnancy_code`: Whether the person has an event related to
#'       pregnancy like giving birth or having a miscarriage at the given date.
#'  -   `is_endocrinology_dept`: Whether the diagnosis was made by an
#'      endocrinology medical department.
#'  -   `is_medical_dept`: Whether the diagnosis was made by a
#'      non-endocrinology medical department.
#'
#' @export
#' @inherit algorithm seealso
prepare_lpr2 <- function(lpr_adm, lpr_diag) {
  logic <- c(
    "lpr2_is_needed_code",
    "lpr2_is_pregnancy_code",
    "lpr2_is_t1d_code",
    "lpr2_is_t2d_code",
    "lpr2_is_diabetes_code",
    "lpr2_is_endocrinology_dept",
    "lpr2_is_medical_dept",
    "lpr2_is_primary_diagnosis"
  ) |>
    logic_as_expression()

  # Select required variables and check required data types.
  select_required_variables(lpr_diag, "lpr_diag") |>
    # Only keep relevant diagnoses.
    dplyr::filter(!!logic$lpr2_is_needed_code) |>
    # Inner join to only keep contacts that are in both registers.
    dplyr::inner_join(
      select_required_variables(lpr_adm, "lpr_adm"),
      by = dplyr::join_by("recnum")
    ) |>
    dplyr::mutate(
      # Algorithm needs c_spec to be an integer.
      c_spec = as.integer(.data$c_spec),
      date = .data$d_inddto,
      is_primary_diagnosis = !!logic$lpr2_is_primary_diagnosis,
      is_diabetes_code = !!logic$lpr2_is_diabetes_code,
      is_t1d_code = !!logic$lpr2_is_t1d_code,
      is_t2d_code = !!logic$lpr2_is_t2d_code,
      is_pregnancy_code = !!logic$lpr2_is_pregnancy_code,
      is_endocrinology_dept = !!logic$lpr2_is_endocrinology_dept,
      is_medical_dept = !!logic$lpr2_is_medical_dept
    ) |>
    dplyr::select(
      "pnr",
      "date",
      "is_primary_diagnosis",
      "is_diabetes_code",
      "is_t1d_code",
      "is_t2d_code",
      "is_endocrinology_dept",
      "is_medical_dept",
      "is_pregnancy_code"
    )
}

#' Prepare and join the two LPR3F registers to extract diabetes and pregnancy diagnoses.
#'
#' @param lpr3f_diagnoser The LPR3F register containing diabetes diagnoses.
#' @param lpr3f_kontakter The LPR3F register containing hospital contacts/admissions.
#'
#' @inherit prepare_lpr2 return
#'
#' @export
#' @inherit algorithm seealso
prepare_lpr3f <- function(lpr3f_kontakter, lpr3f_diagnoser) {
  logic <- c(
    "lpr3_is_needed_code",
    "lpr3_is_pregnancy_code",
    "lpr3_is_t1d_code",
    "lpr3_is_t2d_code",
    "lpr3_is_diabetes_code",
    "lpr3_is_endocrinology_dept",
    "lpr3_is_medical_dept",
    "lpr3_is_primary_diagnosis"
  ) |>
    logic_as_expression()

  # Select required variables and check required data types.
  select_required_variables(lpr3f_diagnoser, "lpr3f_diagnoser") |>
    # Only keep relevant diagnoses.
    dplyr::filter(!!logic$lpr3_is_needed_code) |>
    # Inner join to only keep contacts that are in both registers.
    dplyr::inner_join(
      select_required_variables(lpr3f_kontakter, "lpr3f_kontakter"),
      by = dplyr::join_by("dw_ek_kontakt")
    ) |>
    dplyr::mutate(
      # Algorithm needs "hovedspeciale_ans" values to be lowercase.
      hovedspeciale_ans = tolower(.data$hovedspeciale_ans),
      date = .data$dato_start,
      is_primary_diagnosis = !!logic$lpr3_is_primary_diagnosis,
      is_t1d_code = !!logic$lpr3_is_t1d_code,
      is_t2d_code = !!logic$lpr3_is_t2d_code,
      is_diabetes_code = !!logic$lpr3_is_diabetes_code,
      is_pregnancy_code = !!logic$lpr3_is_pregnancy_code,
      is_endocrinology_dept = !!logic$lpr3_is_endocrinology_dept,
      is_medical_dept = !!logic$lpr3_is_medical_dept,
    ) |>
    dplyr::select(
      "pnr",
      "date",
      "is_primary_diagnosis",
      "is_diabetes_code",
      "is_t1d_code",
      "is_t2d_code",
      "is_endocrinology_dept",
      "is_medical_dept",
      "is_pregnancy_code",
    )
}
