#' Include ICD-8 and ICD-10 Codes for Diabetes Diagnosis and Type-Specific Classification
#'
#' This function processes hospital contact data by combining outputs from `join_lpr2()` and `join_lpr3()` to identify diabetes-related diagnoses, evaluate inclusion criteria, and compute variables for type-specific classification.
#'
#' @param lpr_diag The diagnosis table from LPR2
#' @param lpr_adm The admission table from LPR2
#' @param diagnoser The diagnosis table from LPR3
#' @param kontakter The contacts table from LPR3
#'
#' @return A tibble with the following columns:
#' - `pnr`: Identifier variable (unique to individuals).
#' - `date`: Dates of the first and second hospital diabetes diagnoses.
#' - `any_t1d_primary_diagnosis`: Logical value indicating whether an individual has at least one type 1 diabetes-specific primary diagnosis code from either an endocrinological or other medical department.
#' - `majority_t1d_primary_diagnoses`: Logical value indicating whether an individual has a majority of type 1 diabetes-specific primary diagnoses among all type-specific primary diagnoses recorded in endocrinological departments (or among diagnoses from other medical departments if no endocrinological contacts are recorded).
#'
#' The output is passed to `join_inclusions()`, where the `date` variable is used to define the inclusion date.
#' The variables `any_t1d_primary_diagnosis` and `majority_t1d_primary_diagnoses` are subsequently passed to `get_diabetes_type()` for final classification of diabetes type.
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' include_diabetes_diagnoses(lpr_diag, lpr_adm, diagnoser, kontakter)
#' }
include_diabetes_diagnoses <- function(lpr_diag, lpr_adm, diagnoser, kontakter) {
  verify_required_variables(register_data$lpr_diag, "lpr_diag")
  verify_required_variables(register_data$lpr_adm, "lpr_adm")
  verify_required_variables(register_data$diagnoser, "diagnoser")
  verify_required_variables(register_data$kontakter, "kontakter")

  # Filter and join LPR2 data
  lpr2_criteria <- get_algorithm_logic("lpr2_diabetes") |>
    # To convert the string into an R expression.
    rlang::parse_expr()

  # Filter to diabetes diagnoses using expression filter
  lpr2_diabetes_diagnoses <- lpr_diag |>
    column_names_to_lower() |>
    dplyr::filter(!!lpr2_criteria)

  lpr2_diabetes <- join_lpr2(lpr_adm = lpr_adm, lpr_diag = lpr2_diabetes_diagnoses)

  # Define variables
  lpr2_diabetes <- lpr2_diabetes |> dplyr::mutate(
    pnr = pnr,
    date = d_inddto,
    is_primary = c_diagtype == 'A',
    is_t1d = grepl('^249|^DE10', c_diag),
    is_t2d = grepl('^250|^DE11', c_diag),
    department = dplyr::case_when(
      c_spec %in% c('8', '08', '008') ~ 'endocrinology',
      c_spec <= 30 ~ 'other medical',
      .default = 'non-medical'
    ),
    .keep = "none"
  )

  # Filter and join LPR3 data:
  lpr3_criteria <- get_algorithm_logic("lpr3_diabetes") |>
    rlang::parse_expr()

  # Filter to diabetes diagnoses using expression filter.
  lpr3_diabetes_diagnoses <- diagnoser |>
    column_names_to_lower() |>
    dplyr::filter(!!lpr3_criteria)

  lpr3_diabetes <- join_lpr3(kontakter = kontakter, diagnoser = lpr3_diabetes_diagnoses)

  # Define variables
  hovedspeciale_other_medical_pattern <- '[Mm]edicin|[Gg]eriatri|[Hh]epatologi|[Hh]æmatologi|[Ii]nfektion|[Kk]ardiologi|[Nn]efrologi|[Rr]eumatologi|[Dd]ermato|[Nn]eurologi|[Oo]nkologi|[Oo]ftalmologi|[Nn]eurofysiologi'

  lpr3_diabetes <- lpr3_diabetes |> dplyr::mutate(
    pnr = cpr,
    date = dato_start,
    is_primary = diagnosetype == 'A',
    is_t1d = grepl('^DE10', diagnosekode),
    is_t2d = grepl('^DE11', diagnosekode),
    department = dplyr::case_when(
      stringr::str_detect(hovedspeciale_ans, '[Ee]ndokrinologi') ~ 'endocrinology',
      stringr::str_detect(hovedspeciale_ans, hovedspeciale_other_medical_pattern) ~ 'other medical',
      .default = 'non-medical'
    ),
    .keep = "none"
  )

  # Combine lpr2 and lpr 3 and compute necessary variables by pnr before slicing to inclusion dates

  lpr_diabetes <- rbind(lpr2_diabetes, lpr3_diabetes) |>
    dplyr::group_by(.data$pnr) |>
    dplyr::mutate(
      n_t1d_endocrinology = sum(
        (is_t1d == TRUE) &
          (is_primary == TRUE) & (department == 'endocrinology'),
        na.rm = TRUE
      ),
      n_t2d_endocrinology = sum(
        (is_t2d == TRUE) &
          (is_primary == TRUE) & (department == 'endocrinology'),
        na.rm = TRUE
      ),
      n_t1d_medical = sum(
        (is_t1d == TRUE) &
          (is_primary == TRUE) & (department == 'other medical'),
        na.rm = TRUE
      ),
      n_t2d_medical = sum(
        (is_t2d == TRUE) &
          (is_primary == TRUE) & (department == 'other medical'),
        na.rm = TRUE
      )
    ) |>
    # Keep earliest two dates.
    dplyr::filter(dplyr::row_number(date) %in% 1:2) |>
    dplyr::mutate(
      pnr,
      date,
      any_t1d_primary_diagnosis = sum(n_t1d_endocrinology, n_t1d_medical, na.rm = TRUE) >= 1,
      majority_t1d_primary_diagnoses = get_majority_of_t1d_diagnoses(
        n_t1d_endocrinology,
        n_t2d_endocrinology,
        n_t1d_medical,
        n_t2d_medical
      ),
      .keep = "none"
    ) |>
    dplyr::arrange(.data$pnr)

  return(lpr_diabetes)

}
