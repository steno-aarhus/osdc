#' Prepare and join the two LPR2 registers to extract diabetes and pregnancy diagnoses.
#'
#' The output is used as inputs to [keep_diabetes_diagnoses()] and to
#' [keep_pregnancy_dates()].
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
#' @keywords internal
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

  lpr_diag |>
    dplyr::filter(!!logic$lpr2_is_needed_code) |>
    dplyr::inner_join(
      lpr_adm,
      by = dplyr::join_by("recnum")
    ) |>
    dplyr::mutate(
      # Algorithm needs c_spec to be an integer to work correctly.
      c_spec = as.integer(.data$c_spec),
      date = !!as_sql_datetime("d_inddto"),
      date = as.Date(.data$date),
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

#' Prepare and join the two LPR3 registers to extract diabetes and pregnancy diagnoses.
#'
#' @inherit prepare_lpr2 description
#' @param diagnoser The LPR3 register containing diabetes diagnoses.
#' @param kontakter The LPR3 register containing hospital administrative data.
#' @param lpr_a_diagnose Optional. The LPR_A register containing diagnoses.
#' Necessary if using LPR_A data (roughly from 2023 onward).
#' @param lpr_a_kontakt Optional. The LPR_A register containing hospital
#' administrative data. Necessary if using LPR_A data (roughly from 2023 onward).
#'
#' @inherit prepare_lpr2 return
#'
#' @keywords internal
#' @inherit algorithm seealso
prepare_lpr3 <- prepare_lpr3 <- function(
  kontakter,
  diagnoser,
  lpr_a_kontakt = NULL,
  lpr_a_diagnose = NULL
) {
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

  # Consider LPR_A data only if it is specified in the input:
  if (!is.null(lpr_a_kontakt) && !is.null(lpr_a_diagnose)) {
    adapted <- adapt_lpr_a_to_lpr3(lpr_a_kontakt, lpr_a_diagnose)

    # Add LPR_A admin data
    kontakter <- kontakter |>
      dplyr::union_all(adapted$kontakter)

    # Add LPR_A diagnoses
    diagnoser <- diagnoser |>
      dplyr::union_all(adapted$diagnoser)
  }

  diagnoser |>
    # Only keep relevant diagnoses
    dplyr::filter(!!logic$lpr3_is_needed_code) |>
    # Inner join to only keep contacts that are in both diagnoser and kontakter
    dplyr::inner_join(
      kontakter,
      by = dplyr::join_by("dw_ek_kontakt")
    ) |>
    dplyr::mutate(
      # Algorithm needs "hovedspeciale_ans" values to be lowercase
      hovedspeciale_ans = tolower(.data$hovedspeciale_ans),
      date = !!as_sql_datetime("dato_start"),
      date = as.Date(.data$date),
      is_primary_diagnosis = !!logic$lpr3_is_primary_diagnosis,
      is_t1d_code = !!logic$lpr3_is_t1d_code,
      is_t2d_code = !!logic$lpr3_is_t2d_code,
      is_diabetes_code = !!logic$lpr3_is_diabetes_code,
      is_pregnancy_code = !!logic$lpr3_is_pregnancy_code,
      is_endocrinology_dept = !!logic$lpr3_is_endocrinology_dept,
      is_medical_dept = !!logic$lpr3_is_medical_dept,
    ) |>
    dplyr::select(
      # Rename cpr to pnr for consistency with the old lpr2-formatted data
      "pnr" = "cpr",
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
