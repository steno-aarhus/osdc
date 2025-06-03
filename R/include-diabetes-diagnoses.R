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
#' lpr_diag <- simulate_registers("lpr_diag", 1000)[[1]]
#' lpr_adm <- simulate_registers("lpr_adm", 1000)[[1]]
#' diagnoser <- simulate_registers("diagnoser", 1000)[[1]]
#' kontakter <- simulate_registers("kontakter", 1000)[[1]]
#' include_diabetes_diagnoses(lpr_diag, lpr_adm, diagnoser, kontakter)
#' }
include_diabetes_diagnoses <- function(lpr_diag, lpr_adm, diagnoser, kontakter) {
  verify_required_variables(lpr_diag, "lpr_diag")
  verify_required_variables(lpr_adm, "lpr_adm")
  verify_required_variables(diagnoser, "diagnoser")
  verify_required_variables(kontakter, "kontakter")

  # Filter and join LPR2 data

  # Extract necessary algorithm logic:
  lpr2_criteria <- get_algorithm_logic("lpr2_any_diabetes") |>
    rlang::parse_expr()

  lpr2_t1d_logic <- get_algorithm_logic("lpr2_t1d") |>
    rlang::parse_expr()

  lpr2_t2d_logic <- get_algorithm_logic("lpr2_t2d") |>
    rlang::parse_expr()

  # Filter to diabetes diagnoses
  lpr2_diabetes_diagnoses <- lpr_diag |>
    column_names_to_lower() |>
    dplyr::filter(!!lpr2_criteria)

  lpr2_diabetes_joined <- join_lpr2(lpr_adm = lpr_adm, lpr_diag = lpr2_diabetes_diagnoses)

  lpr2_department_logic <- get_algorithm_logic("lpr2_is_endocrinology_department") |>
    rlang::parse_expr()


  # Define variables
  lpr2_diabetes_processed <- lpr2_diabetes_joined |> dplyr::mutate(
    pnr = pnr,
    date = d_inddto,
    is_primary = c_diagtype == 'A',
    is_t1d = !!lpr2_t1d_logic,
    is_t2d = !!lpr2_t2d_logic,
    is_endo_department = !!lpr2_department_logic,
    .keep = "none"
  )

  # Filter and join LPR3 data:
  lpr3_criteria <- get_algorithm_logic("lpr3_any_diabetes") |>
    rlang::parse_expr()

  lpr3_t1d_logic <- get_algorithm_logic("lpr3_t1d") |>
    rlang::parse_expr()

  lpr3_t2d_logic <- get_algorithm_logic("lpr3_t2d") |>
    rlang::parse_expr()

  lpr3_department_logic <- get_algorithm_logic("lpr3_is_endocrinology_department") |>
    rlang::parse_expr()

  # Filter to diabetes diagnoses using expression filter.
  lpr3_diabetes_diagnoses <- diagnoser |>
    column_names_to_lower() |>
    dplyr::filter(!!lpr3_criteria)

  lpr3_diabetes_joined <- join_lpr3(kontakter = kontakter, diagnoser = lpr3_diabetes_diagnoses)

  # Define LPR3 variables:

  lpr3_diabetes_processed <- lpr3_diabetes_joined |> dplyr::mutate(
    pnr = pnr,
    date = dato_start,
    is_primary = diagnosetype == 'A',
    is_t1d = !!lpr3_t1d_logic,
    is_t2d = !!lpr3_t2d_logic,
    # TODO: Move this logic into algorithm.R under lpr3_is_endocrinology_department
    is_endo_department = !!lpr3_department_logic,
    .keep = "none"
  )

  # Combine lpr2 and lpr 3 and compute necessary variables by pnr before slicing to inclusion dates

  lpr_diabetes_completed <- rbind(lpr2_diabetes_processed, lpr3_diabetes_processed) |>
    count_primary_diagnoses_by_department() |>
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

  return(lpr_diabetes_completed)

}
