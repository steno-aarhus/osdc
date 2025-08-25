#' Determine if majority of diagnoses are type 1 diabetes
#'
#' Uses the hospital contacts from LPR2 and LPR3 to include all
#' dates of diabetes diagnoses to use for inclusion, as well as
#' additional information needed to classify diabetes type.
#' Diabetes diagnoses from both ICD-8 and ICD-10 are included.
#'
#' This function evaluates whether an individual has a majority of type 1
#' diabetes-specific hospital diagnoses (DE10) among all type-specific diabetes
#' primary diagnoses (DE10 & DE11) from medical departments. If an individual
#' has any type-specific diabetes diagnoses from endocrinology departments,
#' the majority is determined only among these contacts.
#'
#' This output is passed to the `join_inclusions()` function, where the
#' `dates` variable is used for the final step of the inclusion process.
#' The variables for whether the majority of diagnoses are for type 1 diabetes
#' is used for later classification of type 1 diabetes.
#'
#' @param lpr2 The output from [prepare_lpr2()].
#' @param lpr3 The output from [prepare_lpr3()].
#'
#' @return The same type as the input data, default as a [tibble::tibble()],
#'  with the following columns and up to two rows per individual:
#'
#'  -   `pnr`: The personal identification variable.
#'  -   `dates`: The dates of the first and second hospital diabetes diagnosis.
#'  -   `has_majority_t1d_diagnosis`: A logical vector indicating whether the
#'      majority of primary diagnoses are related to type 1 diabetes.
#'
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(c("lpr_diag", "lpr_adm", "diagnoser", "kontakter"))
#' include_diabetes_diagnoses(
#'   lpr2 = prepare_lpr2(register_data$lpr_adm, register_data$lpr_diag),
#'   lpr3 = prepare_lpr3(register_data$kontakter, register_data$diagnoser)
#' )
#' }
include_diabetes_diagnoses <- function(lpr2, lpr3) {
  logic <- get_algorithm_logic("has_majority_t1d_diagnosis") |>
    # To convert the string into an R expression.
    rlang::parse_expr()

  # Combine and process the two inputs
  lpr2 |>
    dplyr::bind_rows(lpr3) |>
    dplyr::filter(.data$is_diabetes_code) |>
    # Number of primary diagnoses for either type 1 or 2 diabetes in either
    # endocrinology or other medical departments, across a person's whole
    # history.
    dplyr::mutate(
      n_t1d_endocrinology = sum(
        .data$is_t1d_code & .data$is_primary_dx & .data$is_endocrinology_dept,
        na.rm = TRUE
      ),
      n_t2d_endocrinology = sum(
        .data$is_t2d_code & .data$is_primary_dx & .data$is_endocrinology_dept,
        na.rm = TRUE
      ),
      n_t1d_medical = sum(
        .data$is_t1d_code & .data$is_primary_dx & .data$is_medical_dept,
        na.rm = TRUE
      ),
      n_t2d_medical = sum(
        .data$is_t2d_code & .data$is_primary_dx & .data$is_medical_dept,
        na.rm = TRUE
      ),
      .keep = "all",
      .by = "pnr"
    ) |>
    # Convert NA values to 0.
    dplyr::mutate(
      dplyr::across(
        tidyselect::matches("^n_t[12]d_"),
        \(x) dplyr::coalesce(x, 0)
      )
    ) |>
    # Keep earliest two dates per individual.
    dplyr::filter(dplyr::row_number(.data$date) %in% 1:2, .by = "pnr") |>
    dplyr::mutate(has_majority_t1d_diagnosis = !!logic) |>
    dplyr::select(
      "pnr",
      "date",
      "has_majority_t1d_diagnosis"
    )
}
