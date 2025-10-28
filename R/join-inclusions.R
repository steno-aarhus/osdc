#' Join kept events.
#'
#' @description
#' This function joins the outputs from all the filtering
#' functions, by `pnr` and `dates`. Input datasets:
#'
#' - `diabetes_diagnoses`: Dates are the first and second hospital
#' diabetes diagnosis.
#'
#' - `podiatrist_services`: Dates are the first and second
#' diabetes-specific podiatrist record.
#'
#' - `gld_hba1c_after_drop_steps`: Dates are the first and second elevated HbA1c
#' test results (after censoring potential gestational diabetes) and are the
#' first and second purchase of a glucose-lowering drug (after censoring
#' potential polycystic ovary syndrome and gestational diabetes).
#'
#' @param diabetes_diagnoses Output from [keep_diabetes_diagnoses()].
#' @param podiatrist_services Output from [keep_podiatrist_services()].
#' @param gld_hba1c_after_drop_steps Output from [drop_pregnancies()] and
#'    [drop_pcos()].
#'
#' @returns The same type as the input data, default as a [tibble::tibble()],
#'   with the joined columns from the output of [keep_diabetes_diagnoses()],
#'   [keep_podiatrist_services()], [drop_pcos()], and
#'   [drop_pregnancies()]. There will be 1-8 rows per `pnr`.
#' @keywords internal
#' @inherit algorithm seealso
join_inclusions <- function(
  diabetes_diagnoses,
  podiatrist_services,
  gld_hba1c_after_drop_steps
) {
  # This joins *only* by pnr and dates. If datasets have the same column
  # names, they will be renamed to differentiate them.
  # TODO: We may need to ensure that no two datasets have the same columns.
  joined_inclusions <- diabetes_diagnoses |>
    dplyr::full_join(podiatrist_services, by = c("pnr", "date")) |>
    dplyr::full_join(gld_hba1c_after_drop_steps, by = c("pnr", "date"))
  # |>
  # dplyr::mutate()

  # Propagate computed "has_" values to all rows per PNR.
  joined_inclusions |>
    dplyr::group_by(pnr) |>
    tidyr::fill(tidyr::starts_with("has_"), .direction = "downup") |>
    dplyr::ungroup()
  #|>
  # dplyr::mutate(
  #   dplyr::across(everything(), ~ tidyr::replace_na(.x, FALSE))
  # )

  # Join by pnr only to propagate the values in `has_` columns across
  # all rows for each PNR.
  # joined_inclusions <- diabetes_diagnoses |>
  #   dplyr::full_join(podiatrist_services, by = c("pnr")) |>
  #   dplyr::full_join(gld_hba1c_after_drop_steps, by = c("pnr"))

  # Pivot longer to collect the three date columns into one again.
  # joined_inclusions |> dplyr
}
