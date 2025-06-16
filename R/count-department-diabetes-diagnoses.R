#' Count diabetes-related primary diagnoses by department
#'
#' @param df A data.frame or tibble with the columns: is_t1d, is_t2d, is_primary, is_endo_department
#' @return The same tibble grouped by pnr with added counts for T1D and T2D in different departments
count_primary_diagnoses_by_department <- function(data) {
  data |>
    dplyr::group_by(.data$pnr) |>
    dplyr::mutate(
      n_t1d_endocrinology = sum(
        is_t1d_code & is_primary_dx & is_endocrinology_dept,
        na.rm = TRUE
      ),
      n_t2d_endocrinology = sum(
        is_t2d_code & is_primary_dx & is_endocrinology_dept,
        na.rm = TRUE
      ),
      n_t1d_medical = sum(
        is_t1d_code & is_primary_dx & is_medical_dept,
        na.rm = TRUE
      ),
      n_t2d_medical = sum(
        is_t2d_code & is_primary_dx & is_medical_dept,
        na.rm = TRUE
      ),
      .keep = "all"
    )
}
