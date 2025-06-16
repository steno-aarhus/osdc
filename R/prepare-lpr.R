#' Prepare and join the two LPR2 registers to extract diabetes and pregnancy diagnoses.
#'
#' The output is used as inputs to `include_diabetes_diagnoses()` and to
#' `get_pregnancy_dates()` (see exclusion events).
#'
#' @param lpr_diag The LPR2 register containing diabetes diagnoses.
#' @param lpr_adm The LPR2 register containing hospital admissions.
#'
#' @return The same type as the input data, default as a [tibble::tibble()],
#'  with the following columns:
#'
#'  -   `pnr`: The personal identification variable.
#'  -   `date`: The date of all the recorded diagnosis (renamed from
#'      `d_inddto`).
#'  -   `is_primary_dx`: Whether the diagnosis was a primary diagnosis.
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
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(c("lpr_diag", "lpr_adm"), 100000)
#' lpr2 <- prepare_lpr2(
#'   lpr_diag = register_data$lpr_diag,
#'   lpr_adm = register_data$lpr_adm
#' )
#' }
prepare_lpr2 <- function(lpr_adm, lpr_diag) {
  logic <- c(
    "lpr2_is_needed_code",
    "lpr2_is_pregnancy_code",
    "lpr2_is_t1d_code",
    "lpr2_is_t2d_code",
    "lpr2_is_diabetes_code",
    "lpr2_is_endocrinology_dept",
    "lpr2_is_medical_dept"
  ) |>
    rlang::set_names() |>
    purrr::map(get_algorithm_logic) |>
    # To convert the string into an R expression
    purrr::map(rlang::parse_expr)

  lpr_diag |>
    column_names_to_lower() |>
    dplyr::filter(!!logic$lpr2_is_needed_code) |>
    dplyr::inner_join(
      column_names_to_lower(lpr_adm),
      by = dplyr::join_by("recnum")
    ) |>
    dplyr::mutate(
      # Algorithm needs c_spec to be an integer to work correctly.
      c_spec = as.integer(.data$c_spec),
      date = lubridate::as_date(.data$d_inddto),
      is_primary_dx = .data$c_diagtype == "A",
      is_diabetes_code = !!logic$lpr2_is_diabetes_code,
      is_t1d_code = !!logic$lpr2_is_t1d_code,
      is_t2d_code = !!logic$lpr2_is_t2d_code,
      is_pregnancy_code = !!logic$lpr2_is_pregnancy_code,
      is_endocrinology_department = !!logic$lpr2_is_endocrinology_dept,
      is_medical_department = !!logic$lpr2_is_medical_dept
    ) |>
    dplyr::select(
      "pnr",
      "date",
      "is_primary_dx",
      "is_diabetes_code",
      "is_t1d_code",
      "is_t2d_code",
      "is_endocrinology_department",
      "is_medical_department",
      "is_pregnancy_code"
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
  kontakter <- kontakter |>
    dplyr::rename("pnr" = "cpr")

  dplyr::inner_join(
    column_names_to_lower(kontakter),
    column_names_to_lower(diagnoser),
    by = "dw_ek_kontakt"
  )
}
