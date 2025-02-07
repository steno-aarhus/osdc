#' Determine Majority of Type 1 Diabetes Diagnoses
#'
#' This function evaluates whether an individual has a majority of type 1 diabetes-specific hospital diagnoses (DE10) among all type-specific diabetes primary diagnoses (DE10 & DE11) from medical departments.
#' If an individual has any type-specific diabetes diagnoses from endocrinology departments, the majority is determined only among these contacts.
#'
#' @param n_t1d_endocrinology Numeric vector. The count of type 1 diabetes primary diagnoses from endocrinology departments.
#' @param n_t2d_endocrinology Numeric vector. The count of type 2 diabetes primary diagnoses from endocrinology departments.
#' @param n_t1d_medical Numeric vector. The count of type 1 diabetes primary diagnoses from other medical departments.
#' @param n_t2d_medical Numeric vector. The count of type 2 diabetes primary diagnoses from other medical departments.
#'
#' @return A logical vector indicating whether the majority of primary diagnoses are related to type 1 diabetes.
#' @keywords internal
#'
#' @examples
#' # Example usage within the include_diabetes_diagnoses() pipeline:
#' rbind(lpr2_diabetes, lpr3_diabetes) |>
#'   dplyr::group_by(.data$pnr) |>
#'   dplyr::mutate(
#'     n_t1d_endocrinology = sum(is_t1d & is_primary & department == 'endocrinology', na.rm = TRUE),
#'     n_t2d_endocrinology = sum(is_t2d & is_primary & department == 'endocrinology', na.rm = TRUE),
#'     n_t1d_medical = sum(is_t1d & is_primary & department == 'other medical', na.rm = TRUE),
#'     n_t2d_medical = sum(is_t2d & is_primary & department == 'other medical', na.rm = TRUE)
#'   ) |>
#'   dplyr::mutate(
#'     majority_t1d_primary_diagnoses = get_majority_of_t1d_diagnoses(
#'       n_t1d_endocrinology, n_t2d_endocrinology, n_t1d_medical, n_t2d_medical
#'     )
#'   ) |>
#'   dplyr::ungroup()
#'
#' @seealso [dplyr::case_when()] for condition handling.
get_majority_of_t1d_diagnoses <- function(n_t1d_endocrinology, n_t2d_endocrinology, n_t1d_medical, n_t2d_medical) {
  # Not sure how to go about verify_required_variables() here, or if we needed since the variables have already been verified previously in the pipeline

    dplyr::case_when(
      sum(n_t1d_endocrinology, n_t2d_endocrinology, na.rm = TRUE) > 0 ~ n_t1d_endocrinology > n_t2d_endocrinology,
      sum(n_t1d_endocrinology, n_t2d_endocrinology, na.rm = TRUE) == 0 ~ n_t1d_medical > n_t2d_medical,
      .default = FALSE
    )
  }
