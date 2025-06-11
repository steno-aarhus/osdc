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
  dplyr::inner_join(
    column_names_to_lower(lpr_adm),
    column_names_to_lower(lpr_diag),
    by = "recnum"
  )
}


#' Prepare and join the two LPR3 registers to extract diabetes and pregnancy diagnoses.
#'
#' The output is used as inputs to `include_diabetes_diagnoses()` and to
#' `get_pregnancy_dates()` (see exclusion events).
#'
#' @param diagnoser The LPR3 register containing diabetes diagnoses.
#' @param kontakter The LPR3 register containing hospital contacts/admissions.
#'
#' @return The same type as the input data, default as a [tibble::tibble()],
#'  with the following columns:
#'
#'  -   `pnr`: The personal identification variable.
#'  -   `date`: The date of all the recorded diagnosis (renamed from
#'        `d_inddto`).
#'  -   `is_primary_diagnosis`: Whether the diagnosis was a primary
#'        diagnosis.
#'  -   `has_t1d`: Whether the diagnosis was T1D-specific
#'  -   `has_t2d`: Whether the diagnosis was T2D-specific.
#'  -   `has_diabetes`: Whether the diagnosis was any type of diabetes.
#'  -   `has_pregnancy_event`: Whether the person has an event related to
#'        pregnancy like giving birth or having a miscarriage at the given date.
#'  -   `is_endocrinology_department`: `TRUE` if the diagnosis was made made by
#'        an endocrinology department.
#'  -   `is_medical_department`: `TRUE` if the diagnosis was made by a medical
#'        department excluding endocrinology).
#'  -   `is_primary_diagnosis`: `TRUE` the diagnosis was a primary diagnosis.
#'
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(c("diagnoser", "kontakter"), 100000)
#' prepare_lpr3(register_data$diagnoser, register_data$kontakter)
#' }
prepare_lpr3 <- function(diagnoser, kontakter) {
  logic <- c(
    "lpr3_needed_codes",
    "lpr3_has_pregnancy_event",
    "lpr3_has_t1d",
    "lpr3_has_t2d",
    "lpr3_has_diabetes",
    "lpr3_is_endocrinology_department",
    "lpr3_is_medical_department",
    "lpr3_is_primary_diagnosis"
  ) |>
    rlang::set_names() |>
    purrr::map(get_algorithm_logic) |>
    # To convert the string into an R expression
    purrr::map(rlang::parse_expr)

  diagnoser |>
    column_names_to_lower() |>
    # Only keep relevant diagnoses
    dplyr::filter(!!logic$lpr3_needed_codes) |>
    # Inner join to only keep contacts that are in both diagnoser and kontakter
    dplyr::inner_join(
      column_names_to_lower(kontakter),
      by = dplyr::join_by("dw_ek_kontakt")
    ) |>
    dplyr::mutate(
      # Algorithm needs "hovedspeciale_ans" values to be lowercase
      hovedspeciale_ans = tolower(.data$hovedspeciale_ans),
      date = lubridate::as_date(.data$dato_start),
      has_t1d = !!logic$lpr3_has_t1d,
      has_t2d = !!logic$lpr3_has_t2d,
      has_diabetes = !!logic$lpr3_has_diabetes,
      has_pregnancy_event = !!logic$lpr3_has_pregnancy_event,
      is_endocrinology_department = !!logic$lpr3_is_endocrinology_department,
      is_medical_department = !!logic$lpr3_is_medical_department,
      is_primary_diagnosis = !!logic$lpr3_is_primary_diagnosis,
    ) |>
    dplyr::select(
      # Rename pnr to cpr for consistency with o
      "pnr" = "cpr",
      "date",
      "has_t1d",
      "has_t2d",
      "has_pregnancy_event",
      "is_endocrinology_department",
      "is_medical_department",
      "is_primary_diagnosis"
    )
}
