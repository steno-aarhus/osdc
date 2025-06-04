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
#' lpr2 <- join_lpr2(register_data$lpr_adm, register_data$lpr_diag)
#' lpr3 <- join_lpr3(register_data$kontakter, register_data$diagnoser)
#' get_pregnancy_dates(lpr2, lpr3)
#' }
get_pregnancy_dates <- function(lpr2, lpr3) {
  # Filter using the algorithm for pregnancy events
  criteria <- get_algorithm_logic("has_pregnancy_event") |>
    # To convert the string into an R expression.
    rlang::parse_expr()

  lpr2 |>
    # Row bind to avoid potential rows with multiple diagnoses and dates
    # (e.g., when a pnr has multiple events)
    dplyr::bind_rows(lpr3) |>
    dplyr::filter(!!criteria) |>
    dplyr::mutate(
      pregnancy_event_date = lubridate::as_date(dplyr::if_else(
        !is.na(.data$d_inddto),
        .data$d_inddto,
        .data$dato_start
      ))
    ) |>
    dplyr::select(
      pnr,
      pregnancy_event_date
    ) |>
    # Add logical helper variable to indicate pregnancy events
    dplyr::mutate(has_pregnancy_event = TRUE)
}
