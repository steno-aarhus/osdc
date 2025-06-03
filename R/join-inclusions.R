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
#' - `hba1c_censored_pregnancy`: Dates are the first and second elevated HbA1c
#' test results (after censoring potential gestational diabetes).
#'
#' - `gld_censored_pcos_pregnancy`: Dates are the first and second purchase of a
#' glucose-lowering drug (after censoring potential polycystic ovary syndrome
#' and gestational diabetes).
#'
#' @param included_diabetes_diagnoses Output from [include_diabetes_diagnoses()].
#' @param included_podiatrist_services Output from [include_podiatrist_services()].
#' @param hba1c_censored_pregnancy Output from [exclude_pregnancy()] when given
#'   `hba1c` data.
#' @param gld_censored_pcos_pregnancy Output from [exclude_pregnancy()] when
#'   given `gld_censored_pcos` data.
#'
#' @returns The same type as the input data, default as a [tibble::tibble()],
#'   with the joined columns from the output of [include_diabetes_diagnoses()],
#'   [include_podiatrist_services()] and [exclude_pregnancy()]. There will be
#'   1-8 rows per `pnr`.
#' @keywords internal
#' @inherit algorithm seealso
join_inclusions <- function(
  included_diabetes_diagnoses,
  included_podiatrist_services,
  hba1c_censored_pregnancy,
  gld_censored_pcos_pregnancy
) {
  # Combine the outputs from the inclusion and exclusion events
  purrr::reduce(
    list(
      included_diabetes_diagnoses,
      included_podiatrist_services,
      hba1c_censored_pregnancy,
      gld_censored_pcos_pregnancy
    ),
    # This joins *only* by pnr and dates. If datasets have the same column
    # names, they will be renamed to differentiate them.
    # TODO: We may need to ensure that no two datasets have the same columns.
    \(x, y) dplyr::full_join(x, y, by = dplyr::join_by(.data$pnr, .data$dates))
  )
}
