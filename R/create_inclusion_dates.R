#' Create inclusion dates from all the inclusion events
#'
#' This function takes the output from
#' [join_inclusions()] and defines the final inclusion dates, raw and stable
#' based on all inclusion event types. Since inclusion requires at least two
#' events (of any type), this function keeps only those with 2 or more events.
#' E.g., an individual with two elevated HbA1c tests followed by a
#' glucose-lowering drug purchase is included with the latest elevated HbA1c
#' test and the purchase of glucose-lowering drugs.
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
#'   with the `pnr` and `date` columns along with the columns from the input
#'   that's needed to classify T1D.
#'   It also creates two new columns:
#'
#'   - `raw_inclusion_date`: Date of raw inclusion, the second earliest recorded
#'        event for each individual.
#'   - `stable_inclusion_date`: Same as raw inclusion date, but set to `NA` if
#'        the raw inclusion date is before the stable inclusion start date.
#'
#' @keywords internal
create_inclusion_dates <- function(
  inclusions,
  stable_inclusion_start_date = "1998-01-01"
) {
  inclusions |>
    # Take the second date per person (or drop if < 2 events).
    dplyr::filter(dplyr::row_number(.data$date) == 2, .by = "pnr") |>
    dplyr::mutate(
      raw_inclusion_date = date,
      # Set the stable inclusion date to NA if the raw inclusion date is before
      # stable_inclusion_start_date.
      stable_inclusion_date = dplyr::if_else(
        .data$raw_inclusion_date <
          lubridate::as_date(stable_inclusion_start_date),
        NA,
        .data$raw_inclusion_date)
      ) |>
    dplyr::select(
      "pnr",
      "date",
      # Columns used for classifying T1D.
      "is_only_insulin_purchases",
      "is_two_thirds_insulin",
      "is_insulin_purchases_within_180_days",
      "is_majority_t1d_dx",
      "is_any_t1d_primary_dx",
      "is_primary_dx",
      # Inclusion date columns.
      "raw_inclusion_date",
      "stable_inclusion_date",
    )
}
