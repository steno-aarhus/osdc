#' Include diabetes-specific podiatrist services.
#'
#' Uses the `sysi` or `sssy` registers as input to extract the dates of all
#' diabetes-specific podiatrist services. Removes duplicate services on the
#' same date. Only the two earliest dates per individual are kept.
#'
#' The output is passed to the `join_inclusions()` function for the final
#' step of the inclusion process.
#'
#' @param sysi The SYSI register.
#' @param sssy The SSSY register.
#'
#' @return The same type as the input data, default as a [tibble::tibble()],
#'   with two columns and up to two rows for each individual:
#'
#'   -  `pnr`: Identifier variable
#'   -  `date`: The dates of the first and second diabetes-specific
#'      podiatrist record
#'  -  `has_podiatrist_services`: A logical variable that acts as a helper
#'      indicator for use in later functions.
#'
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(c("sysi", "sssy"), 100)
#' include_podiatrist_services(register_data$sysi, register_data$sssy)
#' }
include_podiatrist_services <- function(sysi, sssy) {
  logic <- get_algorithm_logic("is_podiatrist_services") |>
    # To convert the string into an R expression.
    rlang::parse_expr()

  sysi |>
    dplyr::full_join(
      sssy,
      by = dplyr::join_by("pnr", "barnmak", "speciale", "honuge")
    ) |>
    # Both of these need to be converted to correct format in order for
    # Arrow to correctly filter them later.
    dplyr::mutate(
      speciale = as.character(.data$speciale),
      barnmak = as.integer(.data$barnmak)
    ) |>
    # Filter based algorithm logic.
    dplyr::filter(!!logic) |>
    # Remove duplicates
    dplyr::distinct() |>
    # Keep only the two columns we need and transform `honuge` to YYYY-MM-DD.
    dplyr::mutate(
      pnr = .data$pnr,
      date = yyww_to_yyyymmdd(.data$honuge),
      .keep = "none"
    ) |>
    # Keep earliest two dates per individual.
    dplyr::filter(dplyr::row_number(.data$date) %in% 1:2, .by = "pnr") |>
    # Create an indicator variable for later use.
    dplyr::mutate(has_podiatrist_services = TRUE)
}
