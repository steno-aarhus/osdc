#' Drop rows with metformin purchases that are potentially for the treatment of polycystic ovary syndrome
#'
#' Takes the output from [keep_gld_purchases()] and `bef` (information on sex and date
#' of birth) to drop rows with metformin purchases that are potentially for the treatment
#' of polycystic ovary syndrome.
#' This function only performs a filtering operation so it outputs the same structure and
#' variables as the input from [keep_gld_purchases()], except the addition of a logical
#' helper variable `no_pcos` that is used in later functions.
#' After these rows have been dropped, the output is used by `drop_pregnancies()`.
#'
#' @param gld_purchases The output from [keep_gld_purchases()].
#' @param bef The `bef` register.
#'
#' @return The same type as the input data, default as a [tibble::tibble()].
#'    It also has the same columns as [keep_gld_purchases()], except for a logical
#'    helper variable `no_pcos` that is used in later functions.
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(c("lmdb", "bef"), 100)
#' drop_pcos(
#'   gld_purchases = keep_gld_purchases(register_data$lmdb),
#'   bef = register_data$bef
#' )
#' }
drop_pcos <- function(gld_purchases, bef) {
  logic <- logic_as_expression("is_not_metformin_for_pcos")[[1]]

  # Use the algorithm logic to drop potential PCOS
  gld_purchases |>
    dplyr::inner_join(bef, by = dplyr::join_by("pnr")) |>
    dplyr::mutate(
      date = lubridate::as_date(.data$date),
      foed_dato = lubridate::as_date(.data$foed_dato)
    ) |>
    # Use !! to inject the expression into filter
    dplyr::filter(!!logic) |>
    # Keep only the columns we need
    dplyr::select(
      -"koen",
      -"foed_dato"
    )
}

#' Drop pregnancy events that could be gestational diabetes.
#'
#' This function takes the combined outputs from
#' [keep_pregnancy_dates()], [keep_hba1c()], and
#' [drop_pcos()] and uses diagnoses from LPR2 or LPR3 to
#' drop all elevated HbA1c tests and GLD purchases during pregnancy, as
#' these may be due to gestational diabetes, rather than type 1 or type 2
#' diabetes. Pregnancies are defined based on diagnosis codes
#' specific to pregnancy-ending events (e.g. live births or miscarriages),
#' and then use the dates of these events to remove inclusion events in the
#' preceding months that may be related to gestational diabetes (e.g.
#' elevated HbA1c tests or purchases of glucose-lowering drugs during
#' pregnancy).
#'
#' After these drop functions have been applied, the output serves as
#' input to:
#'
#' 1.  The censored HbA1c and GLD data are passed to the [add_insulin_purchases_cols()] function.
#'
#' @param dropped_pcos Output from [drop_pcos()].
#' @param pregnancy_dates Output from [keep_pregnancy_dates()].
#' @param included_hba1c Output from [keep_hba1c()].
#'
#' @returns The same type as the input data, default as a [tibble::tibble()].
#'    Has the same output data as the input [drop_pcos()], except
#'    for a helper logical variable `no_pregnancy` that is used in later
#'    functions.
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(
#'   c(
#'     "lpr_adm",
#'     "lpr_diag",
#'     "kontakter",
#'     "diagnoser",
#'     "lmdb",
#'     "bef",
#'     "lab_forsker"
#'   ),
#'   n = 1000
#' )
#' lpr2 <- prepare_lpr2(
#'   lpr_adm = register_data$lpr_adm,
#'   lpr_diag = register_data$lpr_diag
#' )
#' lpr3 <- prepare_lpr3(
#'   kontakter = register_data$kontakter,
#'   diagnoser = register_data$diagnoser
#' )
#'
#' # Drop pregnancy dates
#' register_data$lmdb |>
#'   keep_gld_purchases() |>
#'   drop_pcos(register_data$bef) |>
#'   drop_pregnancies(
#'     keep_pregnancy_dates(lpr2, lpr3),
#'     keep_hba1c(register_data$lab_forsker)
#'   )
#' }
drop_pregnancies <- function(
  dropped_pcos,
  pregnancy_dates,
  included_hba1c
) {
  criteria <- logic_as_expression("is_not_within_pregnancy_interval")[[1]]

  # TODO: This should be done at an earlier stage.
  # Ensure both date columns are of type Date.
  dropped_pcos <- dropped_pcos |>
    dplyr::mutate(
      date = lubridate::as_date(.data$date)
    )
  included_hba1c <- included_hba1c |>
    dplyr::mutate(
      date = lubridate::as_date(.data$date)
    )

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
      is_not_within_pregnancy_interval = !!criteria
    ) |>
    # Group by pnr and date to ensure the row is dropped if it falls within
    # *any* pregnancy interval. This prevents mistakenly keeping a row just
    # because it falls outside one pregnancy window, when it may still fall
    # inside another for the same pnr.
    # Only keep rows that don't fall within any pregnancy interval.
    dplyr::filter(
      all(.data$is_not_within_pregnancy_interval),
      .by = c("pnr", "date")
    ) |>
    # Drop columns that were only used here.
    dplyr::select(
      -"pregnancy_event_date",
      -"has_pregnancy_event",
      -"is_not_within_pregnancy_interval"
    ) |>
    # Remove duplicates after pregnancy date column has been removed.
    # Duplicates are created when a pnr has multiple pregnancy events and a
    # row that falls outside all of them.
    dplyr::distinct()
}
