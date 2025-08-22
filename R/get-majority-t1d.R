#' Determine if majority of diagnoses are for type 1 diabetes
#'
#' This function evaluates whether an individual has a majority of type 1 diabetes-
#' specific hospital diagnoses (DE10) among all type-specific diabetes primary
#' diagnoses (DE10 & DE11) from medical departments. If an individual has any type-
#' specific diabetes diagnoses from endocrinology departments, the majority is
#' determined only among these contacts.
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
#' \dontrun{
#' # Example usage within the include_diabetes_diagnoses() pipeline:
#' include_diabetes_diagnoses(lpr2, lpr3) |>
#'  dplyr::mutate(
#'    majority_t1d_primary_diagnoses = get_majority_of_t1d(
#'      n_t1d_endocrinology,
#'      n_t2d_endocrinology,
#'      n_t1d_medical,
#'      n_t2d_medical
#'    )
#'  ) |>
#'  dplyr::arrange(.data$pnr)
#' }
#'
#' @seealso [dplyr::case_when()] for condition handling.
get_majority_of_t1d <- function(n_t1d_endocrinology,
                                n_t2d_endocrinology,
                                n_t1d_medical,
                                n_t2d_medical) {
  dplyr::case_when(
    # Cases with contacts to endocrinological departments: evaluate endo contacts
    sum(n_t1d_endocrinology, n_t2d_endocrinology, na.rm = TRUE) > 0 ~
      n_t1d_endocrinology > n_t2d_endocrinology,

    # Cases without any contacts to endocrinological departments: evaluate medical contacts
    sum(n_t1d_endocrinology, n_t2d_endocrinology, na.rm = TRUE) == 0 ~
      n_t1d_medical > n_t2d_medical,

    # Cases with no contacts to endocrinology nor medical departments: default to false
    .default = FALSE
  )
}
