#' Include only those with HbA1c above the required threshold.
#'
#' In the `lab_forsker` register, NPU27300 is HbA1c in the modern units (IFCC)
#' while NPU03835 is HbA1c in old units (DCCT). Multiple elevated results on the
#' same day within each individual are deduplicated, to account for the same
#' test result often being reported twice (one for IFCC, one for DCCT units).
#'
#' The output is passed to the `exclude_pregnancy()` function for
#' filtering of elevated results due to potential gestational diabetes (see
#' below).
#'
#' @param lab_forsker The `lab_forsker` register.
#'
#' @return An object of the same input type, default as a [tibble::tibble()],
#'   with three columns:
#'
#'   - `pnr`: Personal identification variable.
#'   - `dates`: The dates of all elevated HbA1c test results.
#'   - `has_elevated_hba1c`: A logical variable indicating that the HbA1c test
#'   was included. Used as an indicator and reminder in other internal
#'   functions.
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' register_data$lab_forsker |> include_hba1c()
#' }
include_hba1c <- function(lab_forsker) {
  verify_required_variables(lab_forsker, "lab_forsker")
  criteria <- get_algorithm_logic("hba1c") |>
    # To convert the string into an R expression.
    rlang::parse_expr()
  lab_forsker |>
    column_names_to_lower() |>
    # Use !! to inject the expression into filter.
    dplyr::filter(!!criteria) |>
    # Keep only the columns we need.
    dplyr::mutate(
      pnr = .data$patient_cpr,
      date = .data$samplingdate,
      has_elevated_hba1c = TRUE,
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
