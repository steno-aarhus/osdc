#' Simple function to get only the pregnancy event dates.
#'
#' @param lpr2 Output from `join_lpr2()`.
#' @param lpr3 Output from `join_lpr3()`.
#'
#' @returns The same type as the input data, default as a [tibble::tibble()].
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(
#'   c("lpr_adm", "lpr_diag", "kontakter", "diagnoser"),
#'   n = 1000
#' )
#' lpr2 <- prepare_lpr2(register_data$lpr_adm, register_data$lpr_diag)
#' lpr3 <- prepare_lpr3(register_data$diagnoser, register_data$kontakter)
#' keep_pregnancy_dates(lpr2, lpr3)
#' }
keep_pregnancy_dates <- function(lpr2, lpr3) {
  lpr2 |>
    dplyr::bind_rows(lpr3) |>
    dplyr::filter(.data$is_pregnancy_code) |>
    dplyr::select(
      "pnr",
      "pregnancy_event_date" = date
    ) |>
    # Remove potential duplicates.
    dplyr::distinct() |>
    # Add logical helper variable to indicate pregnancy events.
    dplyr::mutate(has_pregnancy_event = TRUE)
}
