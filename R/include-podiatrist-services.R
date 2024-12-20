#' Include only those who have had podiatrist services
#'
#' See [algorithm] for the logic used to filter these patients.
#' In addition to the algorithm logic, duplicates are removed and only
#' the two earliest dates per individual are kept.
#'
#' The output is passed to `join_inclusions()` function to be joined with
#' the rest of the inclusion data.
#'
#' @param sysi The SYSI register.
#' @param sssy The SSSY register.
#'
#' @return The same type as the input data, default as a [tibble::tibble()]
#'  with two columns:
#'  - `pnr`: Personal identification variable.
#'  - `dates`: The dates of podiatrist services.
#'
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

  dplyr::full_join(column_names_to_lower(sysi), column_names_to_lower(sssy)) |>
    # filter based algorithm logic
    dplyr::filter(!!criteria) |>
    # remove duplicates
    dplyr::distinct() |>
    # keep only the two columns we need and transform `honuge` to date
    dplyr::mutate(
      pnr = .data$pnr,
      date = yyww_to_date(.data$honuge),
      .keep = "none"
    ) |>
    # FIXME: This might be computationally intensive.
    dplyr::group_by(.data$pnr) |>
    # Keep earliest two dates per individual
    dplyr::filter(dplyr::row_number(.data$date) %in% 1:2) |>
    dplyr::ungroup()
}
