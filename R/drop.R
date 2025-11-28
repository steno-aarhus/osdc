#' Drop rows with metformin purchases for the treatment of PCOS
#'
#' Takes the output from [keep_gld_purchases()] and `bef` (information on
#' sex and date of birth) to drop rows with metformin purchases that are
#' potentially for the treatment of polycystic ovary syndrome. This function
#' only performs a filtering operation so it outputs the same structure and
#' variables as the input from [keep_gld_purchases()], except the
#' addition of a logical helper variable `no_pcos` that is used in later
#' functions. After these rows have been dropped, the output is used by
#' [drop_pregnancies()].
#'
#' @param gld_purchases The output from [keep_gld_purchases()].
#' @param bef The `bef` register.
#'
#' @return The same type as the input data, as a [duckplyr::duckdb_tibble()].
#'    It also has the same columns as [osdc::keep_gld_purchases()], except for a
#'    logical helper variable `no_pcos` that is used in later functions.
#' @keywords internal
#' @inherit algorithm seealso
drop_pcos <- function(gld_purchases, bef) {
  logic <- logic_as_expression("is_not_metformin_for_pcos")[[1]]

  # Use the algorithm logic to drop potential PCOS
  gld_purchases |>
    dplyr::inner_join(bef, by = dplyr::join_by("pnr")) |>
    dplyr::mutate(
      date = !!as_sql_datetime("date"),
      date = as.Date(.data$date),
      foed_dato = !!as_sql_datetime("foed_dato"),
      foed_dato = as.Date(.data$foed_dato)
    ) |>
    # Use !! to inject the expression into filter
    dplyr::filter(!!logic) |>
    # Keep only the columns we need
    dplyr::select(
      -"koen",
      -"foed_dato"
    )
}

#' Drop pregnancy events that could be gestational diabetes
#'
#' @description
#' This function takes the combined outputs from
#' [keep_pregnancy_dates()], [keep_hba1c()], and
#' [drop_pcos()] and uses diagnoses from LPR2 or LPR3 to drop both
#' elevated HbA1c tests and GLD purchases during pregnancy, as these may be due
#' to gestational diabetes, rather than type 1 or type 2 diabetes. The aim is to
#' identify pregnancies based on diagnosis codes specific to pregnancy-ending
#' events (e.g. live births or miscarriages), and then use the dates of these
#' events to remove inclusion events in the preceding months that may be related
#' to gestational diabetes (e.g. elevated HbA1c tests or purchases of
#' glucose-lowering drugs during pregnancy).
#'
#' After these drop functions have been applied, the output serves as
#' input to the [add_insulin_purchases_cols()] function.
#'
#' @param dropped_pcos Output from [drop_pcos()].
#' @param pregnancy_dates Output from [keep_pregnancy_dates()].
#' @param included_hba1c Output from [keep_hba1c()].
#'
#' @returns The same type as the input data, as a [duckplyr::duckdb_tibble()].
#'    Has the same output data as the input [drop_pcos()], except
#'    for a helper logical variable `no_pregnancy` that is used in later
#'    functions.
#' @keywords internal
#' @inherit algorithm seealso
drop_pregnancies <- function(
  dropped_pcos,
  pregnancy_dates,
  included_hba1c
) {
  criteria <- logic_as_expression("is_within_pregnancy_interval")[[1]]

  dropped_pcos |>
    # Full join to keep rows from both dropped_pcos and included_hba1c.
    dplyr::full_join(included_hba1c, by = dplyr::join_by("pnr", "date")) |>
    dplyr::left_join(
      pregnancy_dates,
      by = dplyr::join_by("pnr"),
      relationship = "many-to-many"
    ) |>
    # Apply the criteria to flag rows that are within the pregnancy interval.
    dplyr::mutate(
      # Force NA pregnancy event dates to FALSE for the criteria.
      is_within_pregnancy_interval = dplyr::coalesce(!!criteria, FALSE)
    ) |>
    # Group by pnr and date to ensure the row is dropped if it falls within
    # *any* pregnancy interval. This prevents mistakenly keeping a row just
    # because it falls outside one pregnancy window, when it may still fall
    # inside another for the same pnr.
    # Only keep rows that don't fall within any pregnancy interval.
    dplyr::filter(
      !any(.data$is_within_pregnancy_interval),
      .by = c("pnr", "date")
    ) |>
    # Drop columns that were only used here.
    dplyr::select(
      -"pregnancy_event_date",
      -"has_pregnancy_event",
      -"is_within_pregnancy_interval"
    ) |>
    # Drop columns that were only used here and remove duplicates from the
    # many-to-many joining of the pregnancy dates row that falls outside all
    # of them.
    dplyr::distinct(
      .data$pnr,
      .data$volume,
      .data$date,
      .data$atc,
      .data$apk,
      .data$from_hba1c_over_threshold,
      .data$from_gld_purchase
    )
}
