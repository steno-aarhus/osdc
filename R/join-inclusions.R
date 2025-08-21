#' Join included events.
#'
#' @description
#' This function joins the outputs from all the inclusion and exclusion
#' functions, by `pnr` and `dates`. Input datasets:
#'
#' - `included_diabetes_diagnoses`: Dates are the first and second hospital
#' diabetes diagnosis.
#'
#' - `included_podiatrist_services`: Dates are the first and second
#' diabetes-specific podiatrist record.
#'
#' - `gld_hba1c_after_exclusions`: Dates are the first and second elevated HbA1c
#' test results (after censoring potential gestational diabetes) and are the
#' first and second purchase of a glucose-lowering drug (after censoring
#' potential polycystic ovary syndrome and gestational diabetes).
#'
#' @param included_diabetes_diagnoses Output from [include_diabetes_diagnoses()].
#' @param included_podiatrist_services Output from [include_podiatrist_services()].
#' @param gld_hba1c_after_exclusions Output from [exclude_pregnancy()] and
#'    [exclude_potential_pcos()].
#'
#' @returns The same type as the input data, default as a [tibble::tibble()],
#'   with the joined columns from the output of [include_diabetes_diagnoses()],
#'   [include_podiatrist_services()], [exclude_potential_pcos()], and
#'   [exclude_pregnancy()]. There will be 1-8 rows per `pnr`.
#' @keywords internal
#' @inherit algorithm seealso
join_inclusions <- function(
  included_diabetes_diagnoses,
  included_podiatrist_services,
  gld_hba1c_after_exclusions
) {
  # This joins *only* by pnr and dates. If datasets have the same column
  # names, they will be renamed to differentiate them.
  # TODO: We may need to ensure that no two datasets have the same columns.
  included_diabetes_diagnoses |>
    dplyr::full_join(included_podiatrist_services, by = c("pnr", "date")) |>
    dplyr::full_join(gld_hba1c_after_exclusions, by = c("pnr", "date"))
}
