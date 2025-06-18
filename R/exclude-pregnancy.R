#  TODO: Add "[]" instead of quotes around function names, when they've been implemented
#' Exclude any pregnancy events that could be gestational diabetes.
#'
#' This function takes the combined outputs from
#' [get_pregnancy_dates()], [include_hba1c()], and
#' [exclude_potential_pcos()] and uses diagnoses from LPR2 or LPR3 to
#' exclude both elevated HbA1c tests and GLD purchases during pregnancy, as
#' these may be due to gestational diabetes, rather than type 1 or type 2
#' diabetes. The aim is to identify pregnancies based on diagnosis codes
#' specific to pregnancy-ending events (e.g. live births or miscarriages),
#' and then use the dates of these events to remove inclusion events in the
#' preceding months that may be related to gestational diabetes (e.g.
#' elevated HbA1c tests or purchases of glucose-lowering drugs during
#' pregnancy).
#'
#' After these exclusion functions have been applied, the output serves as
#' inputs to two sets of functions:
#'
#' 1.  The censored HbA1c and GLD data are passed to the
#'     "join_inclusions()" function for the final step of the inclusion
#'     process.
#' 2.  The censored GLD data is passed to the
#'     "get_only_insulin_purchases()",
#'     "get_insulin_purchases_within_180_days()", and
#'     "get_insulin_is_two_thirds_of_gld_doses()" helper functions for the
#'     classification of diabetes type.
#'
#' @param excluded_pcos Output from [exclude_potential_pcos()].
#' @param pregnancy_dates Output from [get_pregnancy_dates()].
#' @param included_hba1c Output from [include_hba1c()].
#'
#' @returns The same type as the input data, default as a [tibble::tibble()].
#'    Has the same output data as the input [exclude_potential_pcos()], except
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
#' lpr2 <- prepare_lpr2(register_data$lpr_adm, register_data$lpr_diag)
#' lpr3 <- prepare_lpr3(register_data$diagnoser, register_data$kontakter)
#'
#' # Exclude pregnancy dates
#' register_data$lmdb |>
#'   include_gld_purchases() |>
#'   exclude_potential_pcos(register_data$bef) |>
#'   exclude_pregnancy(
#'     get_pregnancy_dates(lpr2, lpr3),
#'     include_hba1c(register_data$lab_forsker)
#'   )
#' }
exclude_pregnancy <- function(
  excluded_pcos,
  pregnancy_dates,
  included_hba1c
) {
  criteria <- get_algorithm_logic("is_not_within_pregnancy_interval") |>
    # To convert the string into an R expression.
    rlang::parse_expr()

  # TODO: This should be done at an earlier stage.
  # Ensure both date columns are of type Date.
  excluded_pcos <- excluded_pcos |>
    dplyr::mutate(
      date = lubridate::as_date(.data$date)
    )
  included_hba1c <- included_hba1c |>
    dplyr::mutate(
      date = lubridate::as_date(.data$date)
    )

  excluded_pcos |>
    # Row bind to keep rows from excluded_pcos and included_hba1c separate.
    dplyr::bind_rows(included_hba1c) |>
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
    dplyr::group_by(.data$pnr, .data$date) |>
    # Only keep rows that don't fall within any pregnancy interval.
    dplyr::filter(all(.data$is_not_within_pregnancy_interval)) |>
    dplyr::ungroup() |>
    # Select relevant columns.
    dplyr::select(
      "pnr",
      "date",
      "atc",
      "contained_doses",
      "has_gld_purchases",
      "has_elevated_hba1c"
    ) |>
    # Remove duplicates after pregnancy date column has been removed.
    # Duplicates are created when a pnr has multiple pregnancy events and a
    # row that falls outside all of them.
    dplyr::distinct() |>
    # Add logical helper variable.
    dplyr::mutate(no_pregnancy = TRUE)
}
