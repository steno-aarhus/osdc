#' Create inclusion dates from all the inclusion events.
#'
#' This function takes the output from
#' `join_inclusions()` and defines the final inclusion dates, raw and stable
#' based on all inclusion event types. Since inclusion requires at least two
#' events (of any type), this function keeps only those with 2 or more events.
#' E.g., an individual with two elevated HbA1c tests followed by a
#' glucose-lowering drug purchase is included with the latest elevated HbA1c
#' test and the purchase of glucose-lowering drugs.
#'
#' The function creates two new columns: one indicating the "raw"
#' inclusion date and one indicating
#' a "stable" inclusion date, see @returns for more details.
#'
#' @param inclusions Output from [join_inclusions()].
#' @param stable_inclusion_start_date Cutoff date after which inclusion events
#'    are considered reliable (e.g., after changes in drug labeling or data
#'    entry practices). Defaults to "1998-01-01" which is one year after
#'    obstetric codes are reliable in the GLD data (since we use LPR data to
#'    drop rows related to gestational diabetes). This limits the included
#'    cohort to individuals with inclusion dates after this cutoff date.
#'
#' @returns The same type as the input data, default as a [tibble::tibble()],
#'   along with the `pnr` and `date` columns along with the `atc` column from
#'   `exclude_pregnancy()`, and the `n_t1d_endocrinology`,
#'   `n_t2d_endocrinology`, `n_t1d_medical`, and `n_t2d_medical` columns from
#'   `include_diabetes_diagnoses()`. It also creates two new columns:
#'
#'   - `raw_inclusion_date`: Date of raw inclusion, the second earliest recorded
#'        event for each individual.
#'   - `stable_inclusion_date`: Same as raw inclusion date, but set to `NA` if
#'        the raw inclusion date is before the stable inclusion start date.
#'
#' @keywords internal
#' @inherit algorithm seealso
create_inclusion_dates <- function(
  inclusions,
  stable_inclusion_start_date = "1998-01-01"
) {
  inclusions |>
    # Drop earliest date per pnr so only those with two or more events are kept.
    dplyr::filter(.data$date != min(.data$date, na.rm = TRUE), .by = "pnr") |>
    dplyr::mutate(
      # Earliest date in the rows for each individual.
      raw_inclusion_date = min(.data$date, na.rm = TRUE),
      # Set the stable inclusion date to NA if the raw inclusion date is before
      # stable_inclusion_start_date.
      stable_inclusion_date = dplyr::if_else(
        .data$raw_inclusion_date <
          lubridate::as_date(stable_inclusion_start_date),
        NA,
        .data$raw_inclusion_date
      ),
      .by = "pnr"
    ) |>
    dplyr::select(
      "pnr",
      "date",
      "raw_inclusion_date",
      "stable_inclusion_date",

      # From `exclude_pregnancy()` via the GLD purchases
      "atc",

      # From `include_diabetes_diagnoses()`
      "n_t1d_endocrinology",
      "n_t2d_endocrinology",
      "n_t1d_medical",
      "n_t2d_medical"
    )
}
