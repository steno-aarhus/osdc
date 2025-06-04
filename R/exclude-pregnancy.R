#' Exclude any pregnancy events that could be gestational diabetes.
#'
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
#'     [join_inclusions()] function for the final step of the inclusion
#'     process.
#' 2.  the censored GLD data is passed to the
#'     [get_only_insulin_purchases()],
#'     [get_insulin_purchases_within_180_days()], and
#'     [get_insulin_is_two_thirds_of_gld_doses()] helper functions for the
#'     classification of diabetes type.
#'
#' @param excluded_pcos Output from [exclude_potential_pcos()].
#' @param pregnancy_dates Output from [get_pregnancy_dates()].
#' @param included_hba1c Output from [include_hba1c()].
#'
#' @returns The same type as the input data, default as a [tibble::tibble()].
#'    Has the same output data as the input [excluded_potential_pcos()], except
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
#' lpr2 <- join_lpr2(register_data$lpr_adm, register_data$lpr_diag)
#' lpr3 <- join_lpr3(register_data$kontakter, register_data$diagnoser)
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
exclude_pregnancy <- function(excluded_pcos, pregnancy_dates, included_hba1c) {
  criteria <- get_algorithm_logic("no_pregnancy") |>
    # To convert the string into an R expression.
    rlang::parse_expr()

  # Exclude GLD purchases within pregnancy period
  excluded_pcos_no_pregnancy <- excluded_pcos |>
    dplyr::full_join(pregnancy_dates, by = dplyr::join_by(pnr)) |>
    dplyr::mutate(date = lubridate::as_date(date)) |>
    dplyr::filter(!!criteria) |>
    dplyr::select(pnr, date, has_gld_purchases)

  # Exclude increased hba1c events within pregnancy period
  included_pcos_no_pregnancy <- included_hba1c |>
    dplyr::full_join(pregnancy_dates, by = dplyr::join_by(pnr)) |>
    dplyr::mutate(date = lubridate::as_date(date)) |>
    dplyr::filter(!!criteria) |>
    # Only keep columns we need
    dplyr::select(pnr, date, has_elevated_hba1c)

  # join
  excluded_pcos_no_pregnancy |>
    dplyr::full_join(
      included_pcos_no_pregnancy,
      by = dplyr::join_by(pnr, date)
    ) |>
    dplyr::mutate(no_pregnancy = TRUE)
}

# excluded_pcos <- register_data$lmdb |>
#   include_gld_purchases() |>
#   exclude_potential_pcos(register_data$bef)
#
# pregnancy_dates <- get_pregnancy_dates(lpr2, lpr3)
#
# included_hba1c <- include_hba1c(register_data$lab_forsker)
