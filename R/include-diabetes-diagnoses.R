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

  # Filter and join LPR2 data:
  lpr2_criteria <- get_algorithm_logic("lpr2_diabetes", algorithm_logic = algorithm_logic) |>
    # To convert the string into an R expression.
    rlang::parse_expr()

  # Filter to diabetes diagnoses using expression filter.
  lpr2_diabetes_diagnoses <- lpr2_diag |>
    column_names_to_lower() |>
    dplyr::filter(!!lpr2_criteria)

  lpr2_diabetes <- join_lpr2(lpr_adm = lpr2_adm, lpr_diag = lpr2_diabetes_diagnoses)

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
  lpr3_criteria <- get_algorithm_logic("lpr3_diabetes", algorithm_logic =algorithm_logic) |>
    rlang::parse_expr()

  # Filter to diabetes diagnoses using expression filter.
  lpr3_diabetes_diagnoses <- lpr3_diagnoser |>
    column_names_to_lower() |>
    dplyr::filter(!!lpr3_criteria)

  lpr3_diabetes <- join_lpr3(kontakter = lpr3_kontakter, diagnoser = lpr3_diabetes_diagnoses)

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

  rbind(lpr2_diabetes, lpr3_diabetes) |>
    # Remove any duplicates
    dplyr::distinct() |>
    # FIXME: This might be computationally intensive.
    dplyr::group_by(.data$pnr) |>
    dplyr::mutate(n_t1d_endocrinology = sum(is_t1d & is_primary & department == 'endocrinology', na.rm = TRUE),
                  n_t2d_endocrinology = sum(is_t2d & is_primary & department == 'endocrinology', na.rm = TRUE),
                  n_t1d_medical = sum(is_t1d & is_primary & department == 'other medical', na.rm = TRUE),
                  n_t2d_medical = sum(is_t2d & is_primary & department == 'other medical', na.rm = TRUE))
    # Keep earliest two dates.
    return(dplyr::filter(dplyr::row_number(date) %in% 1:2) |>
      dplyr::mutate(pnr,
                    date,
                    any_t1d_primary_diagnosis = sum(n_t1d_endocrinology, n_t1d_medical) >= 1,
                    majority_t1d_primary_diagnoses = get_majority_of_t1d_diagnoses()
      ) |>
      dplyr::ungroup())


}
