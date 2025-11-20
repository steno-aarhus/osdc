#' Add columns for information about insulin drug purchases
#'
#' @param gld_hba1c_after_drop_steps The GLD and HbA1c data after drop steps
#'
#' @return The same type as the input data, as a [duckplyr::duckdb_tibble()].
#'   Three new columns are added:
#'
#'   -   `has_two_thirds_insulin`: A logical variable used in classifying type 1
#'       diabetes. See [algorithm()] for more details.
#'   -   `has_only_insulin_purchases`: A logical variable used in classifying
#'       type 1 diabetes. See [algorithm()] for more details.
#'   -   `has_insulin_purchases_within_180_days`: A logical variable used in
#'       classifying type 1 diabetes. See [algorithm()] for more details.
#'
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' simulate_registers("lmdb", 10000)[[1]] |>
#'   keep_gld_purchases() |>
#'   add_insulin_purchases_cols()
#' }
add_insulin_purchases_cols <- function(gld_hba1c_after_drop_steps) {
  logic <- c(
    "is_insulin_gld_code",
    "has_two_thirds_insulin",
    "has_only_insulin_purchases",
    "has_insulin_purchases_within_180_days"
  ) |>
    logic_as_expression()

  insulin_cols <- gld_hba1c_after_drop_steps |>
    # Remove hba1c rows so dates from HbA1c measurements aren't included.
    dplyr::filter(is.na(.data$has_hba1c_over_threshold)) |>
    # `volume` is the doses contained in the purchased package and `apk` is the
    # number of packages purchased
    dplyr::mutate(
      contained_doses = .data$volume * .data$apk,
      is_insulin_gld_code = !!logic$is_insulin_gld_code,
      date = as_date(date)
    ) |>
    dplyr::select(
      "pnr",
      "date",
      "contained_doses",
      "is_insulin_gld_code"
    ) |>
    dplyr::summarise(
      # Get first date of a GLD purchase and if a purchase of insulin occurs
      # within 180 days of the first purchase.
      first_gld_date = min(date, na.rm = TRUE),
      has_insulin_purchases_within_180_days = !!logic$has_insulin_purchases_within_180_days,
      # Sum up total doses of insulin and of all GLD.
      n_insulin_doses = sum(
        .data$contained_doses[.data$is_insulin_gld_code],
        na.rm = TRUE
      ),
      n_gld_doses = sum(.data$contained_doses, na.rm = TRUE),
      .by = "pnr"
    ) |>
    dplyr::mutate(
      # When at least two-thirds of the doses are insulin doses.
      has_two_thirds_insulin = !!logic$has_two_thirds_insulin,
      # When all doses are insulin.
      has_only_insulin_purchases = !!logic$has_only_insulin_purchases,
      .by = "pnr"
    ) |>
    dplyr::select(
      "pnr",
      "has_two_thirds_insulin",
      "has_only_insulin_purchases",
      "has_insulin_purchases_within_180_days"
    )

  gld_hba1c_after_drop_steps |>
    dplyr::left_join(insulin_cols, by = dplyr::join_by("pnr"))
}

#' Add columns related to type 1 diabetes diagnoses
#'
#' This function evaluates whether an individual has a majority of type 1
#' diabetes-specific hospital diagnoses (DE10) among all type-specific diabetes
#' primary diagnoses (DE10 & DE11) from endocrinology departments. If an individual
#' doesn't have any type-specific diabetes diagnoses from endocrinology departments,
#' the majority is determined by diagnoses from medical departments.
#'
#' It also adds a column indicating whether an individual has at least one
#' primary diagnosis related to type 1 diabetes.
#'
#' This output is passed to the `join_inclusions()` function, where the
#' `dates` variable is used for the final step of the inclusion process.
#' The variables for whether the majority of diagnoses are for type 1 diabetes
#' is used for later classification of type 1 diabetes.
#'
#' @param data Data from [keep_diabetes_diagnoses()] function.
#'
#' @returns The same type as the input data, as a [duckplyr::duckdb_tibble()],
#'  with the following added columns and up to two rows per individual:
#'
#'  -   `has_majority_t1d_diagnoses`: A logical vector indicating whether the
#'      majority of primary diagnoses are related to type 1 diabetes.
#'  -   `has_any_t1d_primary_diagnosis`: A logical vector indicating whether
#'      there is at least one primary diagnosis related to type 1 diabetes.
#'
#' @keywords internal
#' @inherit algorithm seealso
add_t1d_diagnoses_cols <- function(data) {
  logic <- c(
    "has_majority_t1d_diagnoses",
    "has_any_t1d_primary_diagnosis"
  ) |>
    logic_as_expression()

  data |>
    # Number of primary diagnoses for either type 1 or 2 diabetes in either
    # endocrinology or other medical departments, across a person's whole
    # history.
    dplyr::mutate(
      n_t1d_endocrinology = sum(
        .data$is_t1d_code &
          .data$is_primary_diagnosis &
          .data$is_endocrinology_dept,
        na.rm = TRUE
      ),
      n_t2d_endocrinology = sum(
        .data$is_t2d_code &
          .data$is_primary_diagnosis &
          .data$is_endocrinology_dept,
        na.rm = TRUE
      ),
      n_t1d_medical = sum(
        .data$is_t1d_code & .data$is_primary_diagnosis & .data$is_medical_dept,
        na.rm = TRUE
      ),
      n_t2d_medical = sum(
        .data$is_t2d_code & .data$is_primary_diagnosis & .data$is_medical_dept,
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
    # Add two columns for type 1 diabetes diagnoses logic.
    dplyr::mutate(
      has_majority_t1d_diagnoses = !!logic$has_majority_t1d_diagnoses,
      has_any_t1d_primary_diagnosis = !!logic$has_any_t1d_primary_diagnosis
    ) |>
    dplyr::select(-dplyr::starts_with("n_t"))
}
