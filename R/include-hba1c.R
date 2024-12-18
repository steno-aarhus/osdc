#' Include only those with HbA1c in the required range.
#'
#' In the `lab_forsker` register, NPU27300 is HbA1c in the modern units (IFCC)
#' while NPU03835 is HbA1c in old units (DCCT).
#'
#' @param data The `lab_forsker` register.
#'
#' @return An object of the same input type, default as a [tibble::tibble()],
#'   with two columns: `pnr` and `included_hba1c`.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' register_data$lab_forsker |> include_hba1c()
#' }
include_hba1c <- function(data) {
  verify_required_variables(data, "lab_forsker")
  criteria <- get_algorithm_logic("hba1c") |>
    # To convert the string into an R expression.
    rlang::parse_expr()
  data |>
    column_names_to_lower() |>
    # Use !! to inject the expression into filter.
    dplyr::filter(!!criteria) |>
    # Keep only the columns we need.
    dplyr::mutate(
      pnr = .data$patient_cpr,
      date = .data$samplingdate,
      included_hba1c = TRUE,
      .keep = "none"
    ) |>
    # Remove any duplicates
    dplyr::distinct() |>
    # FIXME: This might be computationally intensive.
    dplyr::group_by(.data$pnr) |>
    # Keep earliest two dates.
    dplyr::filter(dplyr::row_number(date) %in% 1:2) |>
    dplyr::ungroup()
}
