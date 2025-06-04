#' Include ICD-8 and ICD-10 Codes for Diabetes Diagnosis and Type-Specific Classification
#'
#' This function processes hospital contact data by combining outputs from `join_lpr2()` and `join_lpr3()` to identify diabetes-related diagnoses, evaluate inclusion criteria, and compute variables for type-specific classification.
#'
#' @param lpr_2 Diagnoses data from the joined diag and adm tables from LPR2 (output from `join_lpr2`)
#' @param lpr_3 Diagnoses data from the joined diagnoser and kontakter tables from LPR3 (output from `join_lpr3`)
#'
#' @return A tibble with the following columns:
#' -  `pnr`: The personal identification variable.
#' -  `date`: The dates of the first and second hospital diabetes diagnosis.
#' -  `has_diabetes_diagnoses`: A logical variable that acts as a helper
#'      indicator for use in later functions.
#'
#' The output is passed to `join_inclusions()`, where the `dates` variable is used to define the inclusion date.
#' The variables `any_t1d_primary_diagnosis` and `majority_t1d_primary_diagnoses` are subsequently passed to `get_diabetes_type()` for final classification of diabetes type.
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(c("lpr_diag", "lpr_adm", "diagnoser", "kontakter"))
#' lpr_diag = register_data$lpr_diag
#' lpr_adm = register_data$lpr_adm
#' diagnoser = register_data$diagnoser
#' kontakter = register_data$kontakter
#' lpr_2 <- join_lpr2(lpr_adm, lpr_diag)
#' lpr_3 <- join_lpr3(kontakter, diagnoser)
#'
#' include_diabetes_diagnoses(lpr_2 = lpr_2, lpr_3 = lpr_3)
#' }
include_diabetes_diagnoses <- function(lpr_2, lpr_3) {

  # Filter LPR2 data

  # Extract necessary algorithm logic:
  lpr2_any_diabetes_logic <- get_algorithm_logic("lpr2_any_diabetes") |>
    rlang::parse_expr()

  # Filter to LPR2 diabetes diagnoses
  lpr2_diabetes_diagnoses <- lpr_2 |>
    dplyr::filter(!!lpr2_any_diabetes_logic)

  # Rename LPR2 variables
  lpr2_diabetes_renamed <- lpr2_diabetes_diagnoses |> dplyr::mutate(
    pnr = pnr,
    date = d_inddto,
    .keep = "none"
  )


  # Filter LPR3 data:
  lpr3_any_diabetes_logic <- get_algorithm_logic("lpr3_any_diabetes") |>
    rlang::parse_expr()


  # Filter to diabetes diagnoses using expression filter.
  lpr3_diabetes_diagnoses <- lpr_3 |>
    dplyr::filter(!!lpr3_any_diabetes_logic)

  # rename LPR3 variables:

  lpr3_diabetes_renamed <- lpr3_diabetes_diagnoses |> dplyr::mutate(
    pnr = pnr,
    date = dato_start,
    .keep = "none"
  )

  # Combine lpr2 and lpr 3 and slice to two earliest inclusion dates

lpr2_diabetes_renamed |>
  dplyr::full_join(
    lpr3_diabetes_renamed,
    by = dplyr::join_by("pnr", "date")
  ) |> dplyr::mutate(
    date = lubridate::ymd(date)) |>
  dplyr::group_by(.data$pnr) |>
  # Keep earliest two dates per individual.
  dplyr::filter(dplyr::row_number(.data$date) %in% 1:2) |>
  dplyr::ungroup() |>
  # Create an indicator variable for later use.
  dplyr::mutate(has_diabetes_diagnoses = TRUE)

}
