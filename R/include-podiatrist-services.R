#' Include only those who have had podiatrist services
#'
#' See [algorithm] for the logic used to filter these patients.
#'
#' @param sysi
#' @param sssy
#'
#' @return The same type as the input data, default as a [tibble::tibble()].
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' include_podiatrist_services(register_data$sysi, register_data$sssy)
#' }
include_podiatrist_services <- function(sysi, sssy) {
  verify_required_variables(sysi, "sysi")
  verify_required_variables(sssy, "sssy")
  criteria <- get_algorithm_logic("podiatrist_services") |>
    # To convert the string into an R expression.
    rlang::parse_expr()

  # full join
  dplyr::full_join(column_names_to_lower(sysi), column_names_to_lower(sssy)) |>
    # filter based algorithm logic
    dplyr::filter(!!criteria) |>
    # remove duplicates
    dplyr::distinct() |>
    # keep only the two columns we need
    dplyr::mutate(pnr = pnr,
                  # transform to date
                  date = wwyy_to_date(honuge),
                  .keep = "none") |>
    # FIXME: This might be computationally intensive.
    dplyr::group_by(pnr) |>
    # Keep earliest two dates.
    dplyr::filter(dplyr::row_number(date) %in% 1:2) |>
    dplyr::ungroup()
}
